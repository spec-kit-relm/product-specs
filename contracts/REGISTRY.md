# Contract Registry

Every interface between Relm repositories, its single owner, the current released version and its
consumers. Edited only by `@spec-kit-relm/architecture` (PS-3), in the same PR that locks versions
for a feature (PRD-4).

| Contract | Kind | Provider (owner) | File | Current version | Consumers (pinned version) | Last changed by |
|----------|------|------------------|------|-----------------|----------------------------|-----------------|
| inventory-api | OpenAPI 3.1 | inventory-service | [`contracts/inventory-api.yaml`](https://github.com/spec-kit-relm/inventory-service/blob/main/contracts/inventory-api.yaml) | 1.1.1 | orders-service (1.1.1), web-storefront (1.1.1), e2e-tests (1.1.1) | RELM-2 |
| inventory-events | AsyncAPI 3 | inventory-service | [`contracts/inventory-events.yaml`](https://github.com/spec-kit-relm/inventory-service/blob/main/contracts/inventory-events.yaml) | 1.1.1 | — | RELM-2 |
| orders-api | OpenAPI 3.1 | orders-service | [`contracts/orders-api.yaml`](https://github.com/spec-kit-relm/orders-service/blob/main/contracts/orders-api.yaml) | 1.3.1 | web-storefront (1.3.1), e2e-tests (1.3.1) | RELM-2 |

## Rules

- Exactly one provider per contract (ORG-3). A new interface gets a row in the feature PR that
  introduces it.
- "Current version" = latest **tagged** release in the provider (`<contract>-v<version>`).
- A MAJOR release is allowed only when no consumer is pinned to the previous MAJOR (expand →
  migrate → contract).
- Agents: use this table to find providers and consumers during `/speckit.plan` and
  `/speckit.relm.impact`. Never guess an interface's owner.
