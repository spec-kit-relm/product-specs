# Impact Map: Stock reservation at checkout

**Feature ID**: RELM-2 | **Product spec**: [spec.md](./spec.md) | **Owner**: tech lead (`@spec-kit-relm/architecture`)

## Participating repositories

| Repository | Team | Role in this feature | Stories / scenarios | Slice size (dev-days) | Owner (human) |
|------------|------|----------------------|---------------------|-----------------------|---------------|
| inventory-service | backend | **provider**: Inventory API (reservations), inventory events | US1 (AS1–AS4), US2/AS1 (commit), US3/AS1 | 5 | backend feature owner A |
| orders-service | backend | **consumer** of Inventory API · **provider**: Orders API | US2 (AS1–AS3) | 3 | backend feature owner B |
| web-storefront | frontend | **consumer** of Inventory API and Orders API | US1 (AS1–AS3), US2 (AS2, AS3), US3/AS2 | 4 | frontend feature owner |
| e2e-tests | qa | **verification** of all scenarios against locked versions | all P1 + US3 | 3 | QA automation owner |

Reviewers: two other backend engineers review inventory/orders plans and code; QA spec partner
reviews all `tasks.md` for scenario coverage.

## Interfaces

| Interface | Provider (owner) | Consumers | Change | Contract file | Target version |
|-----------|------------------|-----------|--------|---------------|----------------|
| Inventory API — reservations (`POST /reservations`, `GET /reservations/{id}`, `POST /reservations/{id}/commit`) | inventory-service | orders-service, web-storefront, e2e-tests | additive | `inventory-service/contracts/inventory-api.yaml` | 1.1.1 |
| Inventory events — `inventory.reservation.expired`, `inventory.reservation.committed` | inventory-service | (analytics; no Relm service consumes them in RELM-2) | additive | `inventory-service/contracts/inventory-events.yaml` | 1.1.1 |
| Orders API — `POST /orders` accepts `reservationId`; new problem type `reservation-expired` | orders-service | web-storefront, e2e-tests | additive | `orders-service/contracts/orders-api.yaml` | 1.3.1 |

## Rollout order (ORG-7)

1. **inventory-service** — deploy reservation endpoints + expiry worker. Additive, unused until step 3.
2. **orders-service** — deploy `reservationId` support (optional field; orders without it behave as today).
3. **web-storefront** — deploy with flag `checkout.stock-reservation` **off**.
4. **e2e-tests** — `@smoke` + `@relm-2` green in staging with the flag on for test carts.
5. Enable `checkout.stock-reservation` for 5 % → 50 % → 100 % of carts, watching SC-002 and SC-004 dashboards for 24 h at each step.

## Rollback order

1. Turn `checkout.stock-reservation` **off** (immediate; carts fall back to today's flow).
2. Roll back web-storefront if needed.
3. Roll back orders-service (orders without `reservationId` keep working).
4. Roll back inventory-service last; active holds expire naturally within 15 minutes.

## Risks & open questions

- Expiry worker lag under load could break SC-003 — owner: inventory owner — mitigation: load test P1 in staging (BE-5).
- Holding stock may lower conversion (SC-004) — owner: PO — mitigation: 5 % step with conversion dashboard before 50 %.
- No open questions (all resolved in Clarifications 2026-11-17).
