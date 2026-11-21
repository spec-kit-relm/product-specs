<!--
Sync Impact Report
- Version change: template → 1.0.0 (initial ratification)
- Part A: RELM:ORG-BASELINE v1.0.0 (synced, unchanged)
- Part B: RELM:TEAM-PRODUCT v1.0.0 (synced, unchanged)
- Part C: added PS-1, PS-2, PS-3, PS-4
- Templates: provided by presets relm-org + relm-product (runtime resolution, no file edits)
- Deferred TODOs: none
-->
# product-specs Constitution

> **How this constitution is layered (Relm SDD).**
> Part A is the organization baseline and Part B is the team overlay. Both are synced from
> `spec-kit-relm/speckit-platform` and MUST NOT be edited in this repository. Part C holds this
> repository's own amendments: they may add or tighten rules, never relax Parts A or B.
> Every Spec Kit command reads this file; `/speckit.analyze` treats any MUST violation as CRITICAL.

<!-- BEGIN RELM:ORG-BASELINE v1.0.0 | source: spec-kit-relm/speckit-platform/governance/org-baseline.md | DO NOT EDIT OUTSIDE speckit-platform -->
## Part A — Relm Organization Baseline (MUST)

These principles apply to every Relm repository. They are deliberately few and every one of
them names the check that enforces it. Lower layers (team overlay, repository amendments) may
**add or tighten** rules, never relax or contradict them.

### ORG-1 Spec before code
Any change that alters user-visible behavior, a public contract, or persisted data MUST trace to
a Spec Kit feature (`Feature: RELM-<n>`) or to a declared lightweight lane (`lane:bugfix`,
`lane:chore`) on the pull request.
*Check: `sdd-gates / pr-check`.*

### ORG-2 Specs describe WHAT and WHY, never HOW
`spec.md` contains no frameworks, languages, or storage choices. Every user story has
Given/When/Then acceptance scenarios and measurable success criteria. No
`[NEEDS CLARIFICATION]` marker may remain once a spec's status is `Approved` or later.
*Check: `sdd-gates / spec-lint`, `/speckit.analyze`.*

### ORG-3 Contract-first integration
Every cross-repository interaction (HTTP, events, shared schemas) is defined in a versioned
contract (OpenAPI 3.1 or AsyncAPI 3) with exactly one owning (provider) repository. Consumers pin a
version and treat vendored copies as read-only. Breaking changes require a MAJOR version and the
expand → migrate → contract sequence.
*Check: `contract-check` workflow, consumer review on contract PRs.*

### ORG-4 Tests prove the spec
Each acceptance scenario maps to at least one automated test that carries its scenario ID
(e.g. `RELM-1/US1/AS2`). Every interface touched by a feature has provider verification and
consumer contract tests, including negative cases. Tests land in the same pull request as the
behavior they verify.
*Check: CI test jobs, `/speckit.converge`, QA review.*

### ORG-5 Secure and private by default
No secrets in code, specs, prompts, or logs. Every endpoint enforces authentication and
authorization. Personal data is classified in `data-model.md` and never logged or sent to analytics.
*Check: secret scanning, CodeQL, dependency review, PR review.*

### ORG-6 Observable by design
Services emit structured logs carrying a trace ID and RED metrics (rate, errors, duration) per
endpoint or consumer. Every feature states how each success criterion is measured in production.
*Check: plan review (`Observability` section), dashboards linked before release.*

### ORG-7 Safe, reversible delivery
New behavior ships behind a feature flag, is deployed in the dependency order defined in the
product feature's `impact.md`, and has a rollback path written in `plan.md`.
*Check: plan review, release-readiness gate.*

### ORG-8 Simplicity, justified complexity
No new service, datastore, message broker, or major dependency without an accepted ADR. Any
deviation from these principles is recorded in the plan's Complexity Tracking table.
*Check: `/speckit.analyze`, architecture review.*

### ORG-9 Humans own AI output
A named human owns every pull request and reviews AI-generated code to the same standard as
hand-written code. `/speckit.analyze` reports **0 CRITICAL** findings before `/speckit.implement`,
implementation runs are scoped to one phase at a time, and `/speckit.converge` reports converged
before merge.
*Check: PR template, CODEOWNERS, `sdd-gates / pr-check`.*

### Organization governance
- **Precedence**: Org baseline (Part A) > team overlay (Part B) > repository amendments (Part C).
  If an agent finds a conflict between layers it MUST stop and report it, not choose.
- **Amendments**: only by pull request to `spec-kit-relm/speckit-platform` (`governance/`), reviewed
  by the SDD Guild plus one approver per discipline. Versioned with semantic versioning
  (MAJOR = principle removed/redefined, MINOR = principle added/expanded, PATCH = wording).
- **Propagation**: the propagation bot opens a sync PR in every repository. Repositories MUST be on
  the same MAJOR and at most one MINOR behind; `sdd-gates / constitution-check` fails otherwise.
- **Exceptions**: listed in Part C → *Exceptions* with an ADR link, an owner, and an expiry date.
<!-- END RELM:ORG-BASELINE -->



<!-- BEGIN RELM:TEAM-PRODUCT v1.0.0 | source: spec-kit-relm/speckit-platform/governance/overlays/product.md | owner: @spec-kit-relm/architecture | DO NOT EDIT OUTSIDE speckit-platform -->
## Part B — Product & Architecture Overlay (MUST)

Applies to the product-level specification repository (`product-specs`) owned by
`@spec-kit-relm/architecture` together with product owners and QA.

### PRD-1 One product feature, one parent issue
Every cross-repository feature starts as a `Feature` issue in `product-specs`. Its issue number
`<n>` is the Feature ID `RELM-<n>` and the Spec Kit feature number used in **every** repository
(`specify --number <n>`), so all repos share the directory and branch `NNN-<short-name>`.
*Check: `sdd-gates / spec-lint` (Feature ID matches directory number).*

### PRD-2 Technology-agnostic product specs
Product specs describe users, outcomes, scenarios, and constraints. They never prescribe
services, frameworks, or schemas — that is decided in each repository's plan.
*Check: Gate 1 review, `/speckit.analyze`.*

### PRD-3 Explicit impact map
Every product feature has an `impact.md` that lists each participating repository, its role
(provider/consumer) for each interface, the contract owner, the rollout order, and the rollback
order.
*Check: `sdd-gates / spec-lint` (required files), Gate 1 review.*

### PRD-4 Locked contract versions
When contract PRs are approved, `contracts.lock.md` for the feature and the org-wide
`contracts/REGISTRY.md` are updated in the same pull request. Service plans reference only locked
versions.
*Check: Gate 2 review.*

### PRD-5 Right-sized features
Each repository's slice of a feature fits in roughly five developer-days. Larger features are
split into several product features linked from a parent epic.
*Check: Gate 1 review (`Slices` table in impact.md).*

### PRD-6 Living product specs
After release, the product spec is updated whenever shipped behavior changes, and follow-up work
opens a new feature that links back. Service-level specs are flow-forward (immutable history).
*Check: PR template item "central spec updated", quarterly spec audit.*
<!-- END RELM:TEAM-PRODUCT -->

## Part C — Repository Amendments (MUST)

### PS-1 No code, no implementation plans
This repository holds product specs, impact maps, contract locks, the contract registry, and the
workspace manifest only. `/speckit.plan`, `/speckit.tasks` and `/speckit.implement` are not used
here; implementation planning happens in each participating repository (tightens PRD-2).
*Check: CODEOWNERS review; `sdd-gates / spec-lint --kind product` (no plan.md/tasks.md expected).*

### PS-2 Complete product feature directories
Every `specs/NNN-*/` contains `spec.md`, `impact.md`, `contracts.lock.md` and
`checklists/requirements.md` before its spec review PR is approved (tightens PRD-3, PRD-4).
*Check: `sdd-gates / spec-lint --kind product`.*

### PS-3 Registry and locks are edited by the architecture team
`contracts/REGISTRY.md` and every `contracts.lock.md` change only in PRs approved by
`@spec-kit-relm/architecture` and, for lock rows, by the provider and every listed consumer.
*Check: CODEOWNERS on `contracts/` and `specs/*/contracts.lock.md`.*

### PS-4 The workspace manifest lists every Spec Kit repository
`workspace/repositories.yml`, `workspace/relm.code-workspace` and `workspace/clone-all.sh` list
every repository that participates in product features, with its team and kind.
*Check: onboarding playbook; quarterly SDD Guild audit.*

### Exceptions
None. <!-- Format: | Rule | Exception | ADR | Owner | Expires | -->

## Repository governance
- Part C is amended by pull request in this repository, approved by the CODEOWNERS of
  `.specify/memory/`, on a dedicated `governance/*` branch (never inside a feature branch).
- Parts A and B change only through the automated governance sync pull request.

**Version**: 1.0.0 | **Ratified**: 2026-11-21 | **Last Amended**: 2026-11-21
**Governance blocks**: RELM:ORG-BASELINE v1.0.0 · RELM:TEAM-PRODUCT v1.0.0
