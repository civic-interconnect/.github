# check-redirects.ps1
# PowerShell 7+ recommended
# WHY-FILE: Resolve and report HTTP redirect behavior for domain portfolios using a reliable HttpClient pipeline.

param(
  [ValidateSet("se","ci","all","custom")]
  [string]$DomainProfile = "all",

  # Used only when DomainProfile = custom
  [string[]]$Domains = @(),

  # Used for DomainProfiles, or can be overridden
  [string]$Canonical = "",

  # If empty, script picks a default based on DomainProfile
  [string]$OutCsv = "",

  [int]$MaxHops = 12,
  [int]$TimeoutSec = 20
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# WHY: Progress output can materially slow HTTP loops; enable by changing to "Continue" if desired.
$ProgressPreference = "SilentlyContinue"

Write-Host ("PowerShell: {0}" -f $PSVersionTable.PSVersion)
Write-Host ("Script: {0}" -f $PSCommandPath)
Write-Host ("Params: Canonical='{0}' OutCsv='{1}' DomainProfile='{2}'" -f $Canonical, $OutCsv, $DomainProfile)
Write-Host ""

function Get-DomainProfileConfig([string]$p) {
  switch ($p) {
    "se" {
      return @{
        Name = "se"
        Canonical = "https://structuralexplainability.org"
        Domains = @(
          "structural-explainability.com",
          "structural-explainability.org",
          "structuralexplainability.com",
          "structuralexplainability.org"
        )
        OutCsv = "./redirect-report-se.csv"
      }
    }
    "ci" {
      return @{
        Name = "ci"
        Canonical = "https://civicinterconnect.org"
        Domains = @(
          "civicinterconnect.com",
          "civicinterconnect.org",
          "civicinterconnect.net"
        )
        OutCsv = "./redirect-report-ci.csv"
      }
    }
    "all" {
      return @{
        Name = "all"
        Canonical = ""
        Domains = @()
        OutCsv = ""
      }
    }
    "custom" {
      return @{
        Name = "custom"
        Canonical = ""
        Domains = @()
        OutCsv = "./redirect-report-custom.csv"
      }
    }
    default {
      throw ("Unknown DomainProfile '{0}'" -f $p)
    }
  }
}

function Normalize-Url([string]$u) {
  # WHY: Normalize trivial variants so canonical comparisons are stable.
  try {
    $uri = [Uri]$u
    $scheme = $uri.Scheme.ToLowerInvariant()
    $hostname = $uri.Host.ToLowerInvariant()

    # Preserve explicit port only if non-default.
    $portPart = ""
    if (-not $uri.IsDefaultPort) { $portPart = ":" + $uri.Port }

    $path = $uri.AbsolutePath
    if ([string]::IsNullOrEmpty($path)) { $path = "/" }

    # Normalize: treat empty path and "/" as equivalent for canonical matching.
    if ($path -eq "/") {
      # Keep query/fragment only if present.
      if ([string]::IsNullOrEmpty($uri.Query) -and [string]::IsNullOrEmpty($uri.Fragment)) {
        return ("{0}://{1}{2}" -f $scheme, $hostname, $portPart)
      }
    }

    return $uri.AbsoluteUri.Trim()
  } catch {
    return $u.Trim()
  }
}

function Resolve-AbsoluteUrl([string]$baseUrl, [string]$location) {
  try {
    $base = [Uri]$baseUrl
    $target = [Uri]::new($base, $location)
    return $target.AbsoluteUri
  } catch {
    return $location
  }
}

function New-HttpClient([int]$timeoutSec) {
  $handler = New-Object System.Net.Http.HttpClientHandler
  $handler.AllowAutoRedirect = $false

  # NOTE: If you ever need to tolerate broken TLS for a specific domain portfolio,
  # you can add a ServerCertificateCustomValidationCallback here. Do not do so by default.

  $client = New-Object System.Net.Http.HttpClient($handler)
  $client.Timeout = [TimeSpan]::FromSeconds($timeoutSec)

  # WHY: Identify the tool; some redirect providers behave differently by UA.
  $client.DefaultRequestHeaders.UserAgent.ParseAdd("redirect-check/1.0")

  # WHY: Range keeps payload small when servers ignore HEAD.
  $client.DefaultRequestHeaders.TryAddWithoutValidation("Range", "bytes=0-0") | Out-Null

  return $client
}

function Get-RedirectStep([System.Net.Http.HttpClient]$client, [string]$url) {
  $req = New-Object System.Net.Http.HttpRequestMessage([System.Net.Http.HttpMethod]::Get, $url)

  try {
    # WHY: Read headers only; no need for full body.
    $resp = $client.Send($req, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead)

    $status = [int]$resp.StatusCode
    $loc = $null
    if ($resp.Headers.Location) { $loc = $resp.Headers.Location.ToString() }

    # Ensure disposal
    $resp.Dispose()
    $req.Dispose()

    return [pscustomobject]@{
      StatusCode = $status
      Location  = $loc
      Error     = $null
    }
  } catch [System.Threading.Tasks.TaskCanceledException] {
    $req.Dispose()
    return [pscustomobject]@{
      StatusCode = $null
      Location  = $null
      Error     = "Timeout"
    }
  } catch {
    $req.Dispose()
    return [pscustomobject]@{
      StatusCode = $null
      Location  = $null
      Error     = $_.Exception.Message
    }
  }
}

function Resolve-RedirectChain([System.Net.Http.HttpClient]$client, [string]$startUrl, [int]$maxHops) {
  $current = $startUrl
  $hops = 0

  $step = Get-RedirectStep -client $client -url $current
  $startCode = $step.StatusCode
  $startLoc  = $step.Location
  $startErr  = $step.Error

  while ($hops -lt $maxHops) {
    if ($null -eq $step.StatusCode) { break }

    $status = [int]$step.StatusCode
    if ($status -ge 300 -and $status -lt 400 -and -not [string]::IsNullOrEmpty($step.Location)) {
      $current = Resolve-AbsoluteUrl -baseUrl $current -location $step.Location
      $hops += 1
      $step = Get-RedirectStep -client $client -url $current
      continue
    }

    break
  }

  return [pscustomobject]@{
    StartUrl  = $startUrl
    StartCode = $startCode
    StartLoc  = $startLoc
    StartErr  = $startErr
    FinalUrl  = $current
    HopCount  = $hops
  }
}

function Invoke-RedirectReport([string[]]$domains, [string]$canonical, [string]$outCsv, [int]$maxHops, [int]$timeoutSec) {
  if (-not $domains -or $domains.Count -eq 0) {
    Write-Host "No domains provided for report."
    return
  }
  if ([string]::IsNullOrWhiteSpace($canonical)) {
    Write-Host "Canonical URL is required for report."
    return
  }

  $schemes = @("http", "https")
  $hostsPrefix = @("", "www.")
  $paths = @("", "/")

  $tests = New-Object System.Collections.Generic.List[string]
  foreach ($d in $domains) {
    foreach ($s in $schemes) {
      foreach ($p in $hostsPrefix) {
        foreach ($path in $paths) {
          $tests.Add(("{0}://{1}{2}{3}" -f $s, $p, $d, $path))
        }
      }
    }
  }

  Write-Host ("Domains count: {0}" -f $domains.Count)
  Write-Host ("Domains: {0}" -f ($domains -join ", "))
  Write-Host ("URLs to test: {0}" -f $tests.Count)
  Write-Host ""

  $canonicalNorm = Normalize-Url $canonical

  $rows = New-Object System.Collections.Generic.List[object]
  $client = New-HttpClient -timeoutSec $timeoutSec

  try {
    $i = 0
    foreach ($t in $tests) {
      $i++
      Write-Host ("[{0}/{1}] {2}" -f $i, $tests.Count, $t)

      $r = Resolve-RedirectChain -client $client -startUrl $t -maxHops $maxHops

      if ($null -eq $r.StartCode) {
        Write-Host ("  -> ERROR: {0}" -f $r.StartErr)
      } else {
        Write-Host ("  -> {0} hops={1} final={2}" -f $r.StartCode, $r.HopCount, $r.FinalUrl)
      }

      $finalNorm = Normalize-Url $r.FinalUrl
      $match = ($finalNorm -eq $canonicalNorm)

      $rows.Add([pscustomobject]@{
        StartUrl            = $r.StartUrl
        StartStatus         = $r.StartCode
        StartLocation       = $r.StartLoc
        StartError          = $r.StartErr
        FinalUrl            = $r.FinalUrl
        FinalUrlNormalized  = $finalNorm
        Canonical           = $canonical
        CanonicalNormalized = $canonicalNorm
        MatchesCanonical    = $match
        HopCount            = $r.HopCount
      })
    }
  } finally {
    $client.Dispose()
  }

  $rows |
    Sort-Object MatchesCanonical, StartUrl |
    Format-Table StartStatus, MatchesCanonical, HopCount, StartUrl, StartLocation, FinalUrl -AutoSize

  $rows | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $outCsv
  Write-Host ""
  Write-Host ("Wrote: {0}" -f (Resolve-Path -LiteralPath $outCsv))
  Write-Host ("Rows collected: {0}" -f $rows.Count)
  Write-Host ""
}

# Decide what to run
if ($DomainProfile -eq "all") {
  $se = Get-DomainProfileConfig "se"
  $ci = Get-DomainProfileConfig "ci"

  Write-Host "=== SE report ==="
  Invoke-RedirectReport -domains $se.Domains -canonical $se.Canonical -outCsv $se.OutCsv -maxHops $MaxHops -timeoutSec $TimeoutSec

  Write-Host "=== CI report ==="
  Invoke-RedirectReport -domains $ci.Domains -canonical $ci.Canonical -outCsv $ci.OutCsv -maxHops $MaxHops -timeoutSec $TimeoutSec
  return
}

$cfg = Get-DomainProfileConfig $DomainProfile

$domainsToUse = if ($DomainProfile -eq "custom") { $Domains } else { $cfg.Domains }
$canonicalToUse = if ([string]::IsNullOrWhiteSpace($Canonical)) { $cfg.Canonical } else { $Canonical }
$outCsvToUse = if ([string]::IsNullOrWhiteSpace($OutCsv)) { $cfg.OutCsv } else { $OutCsv }

Invoke-RedirectReport -domains $domainsToUse -canonical $canonicalToUse -outCsv $outCsvToUse -maxHops $MaxHops -timeoutSec $TimeoutSec
