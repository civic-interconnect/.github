 # Civic Interconnect

[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Project Status: In Progress](https://img.shields.io/badge/status-in--progress-yellow)](https://github.com/civic-interconnect)

[![Schema Agent](https://github.com/civic-interconnect/agents-monitor-schema/actions/workflows/agent-runner.yml/badge.svg)](https://github.com/civic-interconnect/agents-monitor-schema/actions/workflows/agent-runner.yml)
[![Mapping Agent](https://github.com/civic-interconnect/agents-monitor-mapping/actions/workflows/agent-runner.yml/badge.svg)](https://github.com/civic-interconnect/agents-monitor-mapping/actions/workflows/agent-runner.yml)
[![Bills Agent](https://github.com/civic-interconnect/agents-monitor-bills/actions/workflows/agent-runner.yml/badge.svg)](https://github.com/civic-interconnect/agents-monitor-bills/actions/workflows/agent-runner.yml)
[![People Agent](https://github.com/civic-interconnect/agents-monitor-people/actions/workflows/agent-runner.yml/badge.svg)](https://github.com/civic-interconnect/agents-monitor-people/actions/workflows/agent-runner.yml)
[![Lib Tests](https://github.com/civic-interconnect/civic-interconnect-lib/actions/workflows/tests.yml/badge.svg)](https://github.com/civic-interconnect/civic-interconnect-lib/actions/workflows/tests.yml)

> Connecting civic data from public sources.

Goal: support transparency, interoperability, and civic insights.

## Live Agent Dashboard

- [View the Agent Status Dashboard](https://civic-interconnect.github.io/agents-maintenance-dashboard/)

## Current Agents

- **[agents-monitor-schema](https://github.com/civic-interconnect/agents-monitor-schema)**
  Monitor Open Civic Data (OCD) and OpenStates schemas for structural changes.

- **[agents-monitor-mapping](https://github.com/civic-interconnect/agents-monitor-mapping)**
  Extract and report on jurisdiction mappings from OCD to OpenStates.

- **[agents-monitor-bills](https://github.com/civic-interconnect/agents-monitor-bills)**
  Track daily bill activity by jurisdiction using OpenStates GraphQL.

- **[agents-monitor-people](https://github.com/civic-interconnect/agents-monitor-people)**
  Track elected official changes and affiliations.

## Shared Libraries

- **[civic-interconnect-lib](https://github.com/civic-interconnect/civic-interconnect-lib)**
  Core library for logging, error handling, and API utilities.

- **[civic-lib-geo](https://github.com/civic-interconnect/civic-lib-geo)**
  Shared geospatial utilities for boundary and mapping operations.
---

## Vision

```text
civic-interconnect/
├── agents-maintenance-dashboard/
├── agents-monitor-bills/
├── agents-monitor-schema/
├── agents-monitor-people/
├── agents-monitor-mappings/
├── agents-monitor-elections/
│
├── civic-lib/
├── civic-lib-boundaries/
├── civic-lib-geo/
├── civic-lib-ocd/
├── civic-lib-snapshots/
├── civic-lib-ui/
│
├── app-reps/
├── app-jurisdictions/
├── app-bill-compare/
├── app-scorecards/
│
├── site-website/
├── site-guides/
├── site-transparency/
│
├── infra-pages/
├── infra-monitoring/
│
└── meta/
```

---

MIT Licensed · Maintained by [Civic Interconnect](https://github.com/civic-interconnect)
