# product-specs

**Where every Relm feature begins.** Product specs, requirement checklists, impact maps, contract
locks and the contract registry for features that span Relm's repositories.

Owner: `@spec-kit-relm/architecture` (PO + tech lead) with `@spec-kit-relm/qa` ·
Spec Kit project, kind **product** (presets `relm-org` + `relm-product`, extension `relm`)

> This repository contains **no code and no implementation plans**. It answers *what* and *why*.
> Each participating repository answers *how* in its own `specs/NNN-*/plan.md`.

## What's inside

| Path | What | Who writes it |
|------|------|---------------|
| [`specs/`](specs/) | One folder per product feature, `NNN-short-name`, where NNN = Feature issue number | PO with the agent, QA reviews |
| `specs/NNN-*/spec.md` | User stories, Given/When/Then scenarios with IDs, success criteria, clarifications | `/speckit.specify`, `/speckit.clarify` |
| `specs/NNN-*/checklists/` | Requirement-quality checklists ("unit tests for English") | `/speckit.checklist` (QA), ticked by humans |
| `specs/NNN-*/impact.md` | Participating repos, roles, interface owners, slices, rollout/rollback order | `/speckit.relm.impact` (tech lead) |
| `specs/NNN-*/contracts.lock.md` | Contract versions the feature is built against | tech lead after Gate 2 |
| [`contracts/REGISTRY.md`](contracts/REGISTRY.md) | Every interface: owner, current version, consumers | tech lead |
| [`workspace/`](workspace/) | `clone-all.sh`, multi-root `relm.code-workspace`, `repositories.yml` | SDD Guild |
| `.specify/memory/constitution.md` | Parts A (org) + B (`TEAM-PRODUCT`) synced; Part C = PS-1 … PS-4 | SDD Guild / architecture |
| `AGENTS.md` | How agents work in this repo | architecture |

## How to use it — in order

### 1. Set up your workspace (once)
```bash
mkdir -p ~/relm && cd ~/relm
git clone https://github.com/spec-kit-relm/product-specs
bash product-specs/workspace/clone-all.sh
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v1.4.3
```

### 2. Open a Feature issue
**Issues → New → Product feature.** The issue number `n` is the Feature ID **RELM-n**. Open it
*before* any pull request for the feature — issues and PRs share one number sequence.

### 3. Write the product spec (PO, QA spec partner)
```text
/speckit.specify RELM-<n> <short-name>: <problem statement, users, desired outcome>
/speckit.clarify
```
No technology in the spec. Answer every clarification; QA challenges the answers.

### 4. Check requirement quality (QA)
```text
/speckit.checklist requirements
/speckit.checklist api
/speckit.checklist ux
/speckit.checklist qa
```

### 5. Build the impact map (tech lead)
```text
/speckit.relm.impact
```
Confirms repos, roles, interface owners (from `contracts/REGISTRY.md`), slice sizes, rollout order.

### 6. Gate 1 — spec review PR
Branch `NNN-short-name` → `main`, `**Status**: In Review`, label `lane:feature`. Approvals: PO, QA,
tech lead. QA ticks checklists. Merge → `**Status**: Approved`. Tick *Gate 1* on the Feature issue.

### 7. Hand off to repositories
Each participating repo's feature owner runs `/speckit.relm.handoff RELM-<n>` there. Providers open
contract PRs; when they merge, the tech lead locks versions here (**Gate 2**: `contracts.lock.md` +
`REGISTRY.md`, one PR).

### 8. Keep it alive
After release, this spec describes current behavior (living spec, PRD-6). Changes in behavior come
back here as PRs; follow-ups open new Feature issues that link to the original.

## Worked example: RELM-2 — Stock reservation at checkout

| Artifact | State |
|----------|-------|
| Feature issue [#2](https://github.com/spec-kit-relm/product-specs/issues/2) | Gates 1–3 ticked, Gate 4 open |
| [spec.md](specs/002-stock-reservation/spec.md) | **Approved** — 3 user stories, 9 scenario IDs, 4 success criteria |
| [checklists/](specs/002-stock-reservation/checklists/) | requirements, api, ux, qa — ticked by QA; two items accepted by PO |
| [impact.md](specs/002-stock-reservation/impact.md) | inventory-service → orders-service → web-storefront → e2e-tests, flag `checkout.stock-reservation` |
| [contracts.lock.md](specs/002-stock-reservation/contracts.lock.md) | inventory-api 1.1.1, inventory-events 1.1.1, orders-api 1.3.1 — **locked** |

Follow the same feature into
[inventory-service](https://github.com/spec-kit-relm/inventory-service/tree/main/specs/002-stock-reservation),
[orders-service](https://github.com/spec-kit-relm/orders-service/tree/main/specs/002-stock-reservation),
[web-storefront](https://github.com/spec-kit-relm/web-storefront/tree/main/specs/002-stock-reservation) and
[e2e-tests](https://github.com/spec-kit-relm/e2e-tests/tree/main/specs/002-stock-reservation) — each
stopped right before `/speckit.implement`, so you can run it yourself. The full walkthrough is the
[cross-repo playbook](https://github.com/spec-kit-relm/sdd-handbook/blob/main/playbooks/cross-repo-feature.md).

## Rules that apply here

- Company: ORG-1 … ORG-9 (Part A) · Team: PRD-1 … PRD-6 (Part B) · Repository: PS-1 … PS-4 (Part C)
- Full text: [`.specify/memory/constitution.md`](.specify/memory/constitution.md); reasoning:
  [handbook rules](https://github.com/spec-kit-relm/sdd-handbook/tree/main/rules).
