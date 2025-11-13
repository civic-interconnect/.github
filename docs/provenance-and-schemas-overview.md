# Understanding Schemas, Provenance, and PTags  

>A guide for Civic Interconnect

---

## 1. Why schemas exist

A **schema** is a formal definition of what a data object is allowed to look like.  
It is the **data contract** between creators, tools, and users.

- It defines *what fields exist* (like `project`, `license`, `source`).  
- It defines *what type each field must be* (string, array, number, object).  
- It can define *which fields are required* and *what valid values are*.

When data follows a schema:
- It can be **validated automatically** by software.  
- Others can safely **read or process** it without guesswork.  
- If a project changes structure, the schema version tells everyone what changed.

Example of validation in action:
```json
{
  "project": "civic-data-boundaries-us-mn",
  "license": "CC-BY-4.0",
  "source": "https://www.sos.mn.gov/media/2791/mn-precincts.json"
}
```
A schema can check:
- [x] Is `project` present?  
- [x] Is `license` a text field?  
- [x] Is `source` a valid URL?  
If not, the build fails early-before bad metadata spreads.

In open science and civic analytics, **schemas are guardrails** that keep shared data and metadata consistent across time, teams, and repositories.

---

## 2. Provenance: where things come from

**Provenance** literally means *origin or history*.  
In data analytics it answers:

> Where did this data come from, who made it, when, and how?

Provenance is the foundation of **reproducibility** and **trust**.

- In research: readers can trace results back to original datasets and methods.  
- In civic projects: the public can verify that maps, counts, or analyses were generated from official or transparent sources.  
- In analytics pipelines: analytics and auditors can re-run a process to confirm that the same inputs produce the same outputs.

The W3C **PROV model** formalizes this using three main objects:

| Concept | Meaning | Example |
|----------|----------|----------|
| **Entity** | Something that exists (a dataset, a file, a model) | MN precinct GeoJSON |
| **Activity** | Something that happened (a process that used or produced Entities) | Geo-generator build step |
| **Agent** | Someone or something responsible (person, organization, software) | Civic Interconnect |

Relationships between these (.e.g, `wasGeneratedBy`, `used`, `wasAttributedTo`) form a graph describing lineage.

---

## 3. The role of PTags

A **Provenance Tag (PTag)** is a lightweight, human-readable **bundle of provenance metadata**.  
It's like a label for an artifact in a repository:

- **What** it is (dataset, library, app)  
- **Who** made or maintained it  
- **When** it was generated  
- **How** it was created (tool, version, command)  
- **Where** its sources came from  
- **Under what license** it can be reused  

Each repository has a simple `provenance/ptag.json` that captures this snapshot.  
When every repo in a large ecosystem does this consistently, the tags become:

- **Auditable** - anyone can trace lineage end-to-end.  
- **Repeatable** - developers can re-run the same process with confidence.  
- **Interoperable** - outputs fit together without manual tracing.

---

## 4. Why schemas and PTags matter together

Without schemas, provenance tags would just be text someone might fill out somewhat correctly.  
With a JSON Schema, we can:

- **Enforce structure** across dozens of repos.  
- **Automate validation** (e.g., a GitHub Action runs `ptag validate provenance/ptag.json`).  
- **Enable federation** - external tools can index all PTags because they know the schema layout.  
- **Version control** - each schema version documents exactly what fields existed and what they meant at a point in time.

This turns a pile of separate repositories into a **linked, inspectable system** and every dataset, adapter, and app can be traced, rebuilt, and cited.

---

## 5. Auditability and reproducibility in open analytics

Open-source analytics should be based on **evidence, not trust**.  
A schema-based PTag system enables:

1. Scripts can check all PTags for required information.  
2. Provenance tells us which versions of tools, configs, and data were used.  
3. Every dataset or app is anchored to a reproducible lineage.  
4. Contributor roles are captured systematically.  
5. Compliance and transparency.

---

## 6. In Civic Interconnect

- **Schema Repo (`civic-ptag-core-schema`)** defines the standard PTag structure.  
- **Each active repo** includes a validated `provenance/ptag.json`.  
- **Provenance Tooling (`civic-ptag-tools`)** automates validation and integration.  
- **Extensions (“profiles”)** add domain-specific fields for elections, health, education, etc.

Together, they form a **metadata system** connecting projects into one transparent, traceable framework.

