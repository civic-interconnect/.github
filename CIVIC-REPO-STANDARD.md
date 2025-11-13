# Civic Interconnect Repository Standard

This document summarizes the standard layout, tools, and conventions used across all Civic Interconnect repositories.

## 1. Required Tools
All repositories assume:

- Git
- VS Code (recommended)
- Python 3.12+
- **uv** (environment + dependency manager)
- **pre-commit**
- Node.js (for JS/TS or front-end projects only)
- MkDocs + mike (for documentation-enabled repos)

## 2. Directory Layout

Most Python repositories follow this structure:

```
repo-name/
  src/
    package_name/
  tests/
  provenance/
    ptag.json
  docs/
  .github/
  pyproject.toml
  README.md
```

## 3. Source Layout (src/)
All Python projects use the `src/` layout.  
Modules import internally as:

```
from package_name.module import function
```

This avoids namespace collisions and improves test reliability.

## 4. Provenance (ptag.json)
Every repository includes:

```
provenance/ptag.json
```

This records:

- repository metadata  
- data sources  
- transformations  
- schema versions  
- adapter versions  
- authorship provenance  

Schemas are maintained in:

```
civic-ptag-core-schema
```

Validation happens via reusable GitHub Actions defined in:

```
civic-interconnect/.github/workflows/
```

## 5. Dependencies
All repositories use **uv**:

```
uv python pin 3.12
uv venv
uv sync --extra dev --extra docs --upgrade
```

Lock files are intentionally not tracked (`uv.lock` is ignored).

## 6. Testing and Quality Tools
Standard tools used across projects:

- Ruff (formatting + linting)
- Pyright (type checking)
- Deptry (dependency hygiene)
- Pytest (tests)
- Bandit (security)
- pre-commit (local automation)

Running all checks:

```
uvx pre-commit run --all-files
```

## 7. Documentation
Documentation-enabled repos contain:

- `docs/` directory  
- `mkdocs.yml`  
- versioned docs via `mike`

Deployment uses the shared GitHub Action:

```
docs-deploy-mkdocs.yml
```

## 8. GitHub Actions
Repos call the org-wide reusable workflows:

- CI (Python): `ci-python.yml`
- CI (Node): `ci-node.yml`
- Release workflow (Python): `release-python.yml`
- Docs deployment: `docs-deploy-mkdocs.yml`
- Provenance validation:
  - `validate-ptag-core.yml`
  - `validate-ptag-civic-data.yml`

These workflows enforce consistency across the organization.

## 9. Licensing
All Civic Interconnect repositories use the MIT License unless stated otherwise.

## 10. Pull Requests
Contributors should read:

```
REF_PULL_REQUESTS.md
```

which documents the label scheme (infra, docs, feat, fix, etc.).

---

This standard keeps all Civic Interconnect repositories consistent, predictable, and easy to maintain.
