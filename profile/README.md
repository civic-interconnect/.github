 # Civic Interconnect

[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Project Status: In Progress](https://img.shields.io/badge/status-in--progress-yellow)](https://github.com/civic-interconnect)

[![Schema Agent](https://github.com/civic-interconnect/agents-monitor-schema/actions/workflows/agent-runner.yml/badge.svg)](https://github.com/civic-interconnect/agents-monitor-schema/actions/workflows/agent-runner.yml)
[![Mapping Agent](https://github.com/civic-interconnect/agents-monitor-mapping/actions/workflows/agent-runner.yml/badge.svg)](https://github.com/civic-interconnect/agents-monitor-mapping/actions/workflows/agent-runner.yml)
[![Bills Agent](https://github.com/civic-interconnect/agents-monitor-bills/actions/workflows/agent-runner.yml/badge.svg)](https://github.com/civic-interconnect/agents-monitor-bills/actions/workflows/agent-runner.yml)
[![People Agent](https://github.com/civic-interconnect/agents-monitor-people/actions/workflows/agent-runner.yml/badge.svg)](https://github.com/civic-interconnect/agents-monitor-people/actions/workflows/agent-runner.yml)

[![Lib Core](https://github.com/civic-interconnect/civic-lib-core/actions/workflows/lib.yml/badge.svg)](https://github.com/civic-interconnect/civic-lib-core/actions/workflows/lib.yml)
[![Lib Geo](https://github.com/civic-interconnect/civic-lib-geo/actions/workflows/lib.yml/badge.svg)](https://github.com/civic-interconnect/civic-lib-geo/actions/workflows/lib.yml)

[![Data Boundaries](https://github.com/civic-interconnect/civic-data-boundaries-us/actions/workflows/tests.yml/badge.svg)](https://github.com/civic-interconnect/civic-data-boundaries-us/actions/workflows/tests.yml)


> Connecting civic data from public sources to support transparency, interoperability, and civic insights.

## Live Web Apps Running on GitHub Pages

| App               | Web App                                        |  Source Repo |
|-------------------|---------------------------------------------------|--------------|
| GeoExplorer       | https://civic-interconnect.github.io/geo-explorer/ | [geo-explorer](https://github.com/civic-interconnect/geo-explorer) |
| Agent Dashboard   | https://civic-interconnect.github.io/app-agents/  | [app-agents](https://github.com/civic-interconnect/app-agents) |
| Reps App          | https://civic-interconnect.github.io/app-reps/    | [app-reps](https://github.com/civic-interconnect/app-reps) |
| Knowledge Graph | https://civic-interconnect.github.io/civic-kg/ |  [civic-kg](https://github.com/civic-interconnect/civic-reps) |


## Monitoring Agents

- **[agents-monitor-schema](https://github.com/civic-interconnect/agents-monitor-schema)**
  Monitor Open Civic Data (OCD) and OpenStates schemas for structural changes.

- **[agents-monitor-mapping](https://github.com/civic-interconnect/agents-monitor-mapping)**
  Extract and report on jurisdiction mappings from OCD to OpenStates.

- **[agents-monitor-bills](https://github.com/civic-interconnect/agents-monitor-bills)**
  Track daily bill activity by jurisdiction using OpenStates GraphQL.

- **[agents-monitor-people](https://github.com/civic-interconnect/agents-monitor-people)**
  Track elected official changes and affiliations.

## Hosted Data Sources

- **[civic-data-boundaries-us](https://github.com/civic-interconnect/civic-data-boundaries-us)**
  Core geographic data for U.S. states and counties.

- **[civic-data-boundaries-us-cd118](https://github.com/civic-interconnect/civic-data-boundaries-us-cd118)**
  Core geographic data for U.S. 118th Congressional Districts.

## Shared Libraries

- **[civic-lib-core](https://github.com/civic-interconnect/civic-lib-core)**
  Core library for logging, error handling, and API utilities.

- **[civic-lib-geo](https://github.com/civic-interconnect/civic-lib-geo)**
  Shared geospatial utilities for boundary and mapping operations.

## Project Organization

```text
civic-interconnect/
├── geo-explorer/
├── app-agents/
├── app-reps/
├── agents-monitor-bills/
├── agents-monitor-schema/
├── agents-monitor-people/
├── agents-monitor-mapping/
├── civic-data-boundaries-us/
├── civic-lib-core/
├── civic-lib-geo/
├── civic-lib-ocd/
├── civic-lib-snapshots/
└── civic-lib-ui/
```

---

MIT Licensed · Maintained by [Civic Interconnect](https://github.com/civic-interconnect)
