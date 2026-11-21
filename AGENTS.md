# AGENTS.md — product-specs

Product-level specification hub for Relm (Spec Kit project, kind **product**). Owned by
`@spec-kit-relm/architecture` with product owners and QA. It holds **what and why** for
cross-repository features — product specs, checklists, impact maps, contract locks, and the
contract registry. It holds **no code and no implementation plans** (constitution PS-1).

## Commands
| Purpose | Command |
|---------|---------|
| Lint specs (same as CI) | `python ../speckit-platform/scripts/relm_sdd.py spec-lint --kind product` |
| Constitution drift check | `python ../speckit-platform/scripts/relm_sdd.py constitution-check --platform ../speckit-platform` |
| Agent files check | `python ../speckit-platform/scripts/relm_sdd.py agent-files-check` |
| Clone all sibling repos | `bash workspace/clone-all.sh` |

Run `spec-lint --kind product` before proposing a commit.

## Layout
```text
specs/NNN-short-name/          one product feature (NNN = Feature issue number)
  spec.md                      user stories, Given/When/Then, success criteria — no technology
  checklists/*.md              requirement-quality checklists (QA-owned, ticked by humans only)
  impact.md                    repos, roles, interface owners, slices, rollout/rollback order
  contracts.lock.md            contract versions this feature is built against
contracts/REGISTRY.md          every interface: owner, current version, consumers
workspace/                     repositories.yml, relm.code-workspace, clone-all.sh
```

## Spec Kit in this repository
- Kind: `product` — presets `relm-org` + `relm-product`; extension `relm`.
- Commands used here: `/speckit.specify`, `/speckit.clarify`, `/speckit.checklist`,
  `/speckit.relm.impact`. **Not** used here: `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`.
- Start every feature with `/speckit.specify RELM-<n> <short-name>: <problem statement>`, where `n`
  is the Feature issue number. The wrapper passes `--number <n>` → `specs/NNN-short-name/`.
- After Gate 1, each participating repository runs `/speckit.relm.handoff RELM-<n>` and reads this
  repository as `../product-specs`.

## Conventions
- Specs describe users, behavior and outcomes. Never name services, endpoints, schemas,
  frameworks or storage (PRD-2). Interface details belong to provider repos' contracts.
- Keep the **Scenario IDs** table in `spec.md` in sync with the acceptance scenarios — other repos
  and test titles reference these IDs.
- Use `[NEEDS CLARIFICATION: question]` freely while `**Status**: Draft`; none may remain at `Approved`.
- `impact.md` slice sizes over 5 dev-days mean the feature must be split (PRD-5).
- Record every clarification answer under `## Clarifications` with the session date.

## Do not
- Tick checklist items `[x]` — humans only (QA-1).
- Edit `contracts/REGISTRY.md` or a `contracts.lock.md` row unless asked by the tech lead (PS-3).
- Write to sibling repositories. Read them for context only.
- Edit Parts A/B of `.specify/memory/constitution.md`.

## Gotchas
- The Feature issue number, not Spec Kit's next sequential number, decides `NNN`. If a directory
  was created with the wrong number, rename it before the first PR.
- Repo-local features also get a Feature issue here (for the number) but no `specs/` directory.
