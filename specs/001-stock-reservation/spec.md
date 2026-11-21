# Feature Specification: Stock reservation at checkout

**Feature Branch**: `001-stock-reservation`

**Created**: 2026-11-16

**Status**: Approved

**Input**: User description: "RELM-1 stock-reservation: Shoppers sometimes pay for items that sold out while they were checking out. When checkout starts, hold the items for a limited time so they cannot be sold to someone else, show the shopper how long the hold lasts, and release holds that are not used."

## Clarifications

### Session 2026-11-17

- Q: How long is an item held? → A: 15 minutes from the start of checkout, fixed for this release (no extension).
- Q: What happens if only part of the cart is available? → A: Nothing is held; the shopper sees which items are short and can adjust quantities, then try again.
- Q: Does refreshing or reopening checkout create a new hold? → A: No. The same hold and remaining time are shown until it expires or the order is placed.
- Q: Can a shopper have more than one active hold? → A: One active hold per cart. Starting checkout again with a changed cart replaces the previous hold.
- Q: How quickly must expired holds become sellable again? → A: Within 60 seconds of expiry.
- Q: Are logged-out shoppers included? → A: Yes; holds belong to the cart, not the account.
- Q: What if the shopper places the order twice (double click, network retry)? → A: Exactly one order is created and the shopper sees the same confirmation.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Hold items when checkout starts (Priority: P1)

A shopper who starts checkout gets the cart's items held for 15 minutes and can see how much time
is left, so they are not surprised by "sold out" after paying.

**Why this priority**: This is the core of the feature: without a hold, overselling continues.

**Independent Test**: Start checkout with an in-stock cart and verify that the items are held, the
remaining time is shown, and another shopper cannot buy the held units.

**Acceptance Scenarios**:

1. **Given** a cart with 2 units of an item that has 5 available, **When** the shopper starts checkout, **Then** 2 units are held for that cart and checkout shows the hold expiring in 15 minutes.
2. **Given** a cart with 2 units of an item that has only 1 available, **When** the shopper starts checkout, **Then** nothing is held and the shopper is told only 1 unit is available and can change the quantity.
3. **Given** an active hold for the cart, **When** the shopper reloads or reopens checkout, **Then** the same hold and the correct remaining time are shown and no additional units are held.
4. **Given** 1 available unit held by shopper A, **When** shopper B starts checkout for the same item, **Then** shopper B is told the item is not available.

---

### User Story 2 - Place the order against the hold (Priority: P1)

A shopper with an active hold places the order and the held units become theirs; retries never
create a second order.

**Why this priority**: The hold only has value if placing the order uses it; duplicate orders are
a top support complaint.

**Independent Test**: With an active hold, place the order (twice in quick succession) and verify
exactly one confirmed order and that the held units are no longer available to anyone.

**Acceptance Scenarios**:

1. **Given** an active hold, **When** the shopper places the order, **Then** the order is confirmed and the held units are permanently taken from available stock.
2. **Given** an active hold, **When** the order is submitted twice within seconds, **Then** exactly one order exists and both submissions show the same confirmation.
3. **Given** a hold that has expired, **When** the shopper places the order, **Then** the order is not placed, the shopper is told the hold expired, and is offered to start checkout again.

---

### User Story 3 - Release holds that are not used (Priority: P2)

Holds that are not turned into orders are released automatically so other shoppers can buy the
items.

**Why this priority**: Prevents stock from being locked by abandoned checkouts; important but the
feature delivers value without fast release.

**Independent Test**: Start checkout, wait for the hold to expire without ordering, and verify the
units are available again within 60 seconds.

**Acceptance Scenarios**:

1. **Given** a hold that is not used for 15 minutes, **When** it expires, **Then** the held units are available to other shoppers within 60 seconds.
2. **Given** a shopper who left checkout and comes back after the hold expired, **When** checkout is shown, **Then** the shopper sees that the hold expired and can start checkout again.

---

### Edge Cases

- The hold expires while the order is being submitted: the order is either fully placed (hold still valid at the moment of placement) or rejected with the "hold expired" message — never placed without stock.
- The shopper changes the cart in another tab during checkout: the next "start checkout" replaces the hold; placing an order with an outdated cart is rejected and checkout reloads.
- Stock is corrected downwards by a warehouse adjustment while units are held: existing holds stay valid; new holds see the corrected availability.
- The shopper's connection drops after submitting the order: re-submitting shows the original confirmation (see US2 scenario 2).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST hold all cart items at checkout start, or none of them if any item is short.
- **FR-002**: A hold MUST last 15 minutes from creation and MUST NOT be extended in this release.
- **FR-003**: Held units MUST NOT be available to any other cart.
- **FR-004**: The system MUST show the shopper the hold's remaining time on every checkout view.
- **FR-005**: A cart MUST have at most one active hold; a new checkout start with a changed cart replaces it.
- **FR-006**: Placing an order MUST convert the hold into a permanent stock deduction.
- **FR-007**: Repeated submissions of the same order MUST result in exactly one order.
- **FR-008**: Placing an order with an expired hold MUST be rejected with an explanation and a way to start again.
- **FR-009**: Expired holds MUST release their units within 60 seconds of expiry.
- **FR-010**: The feature MUST be switchable on/off per percentage of shoppers.

### Key Entities *(include if feature involves data)*

- **Hold (reservation)**: units of one or more items set aside for one cart; has a creation time, an expiry time, and a state (active, converted, expired, replaced).
- **Cart**: the shopper's items and quantities; owns at most one active hold.
- **Order**: the shopper's confirmed purchase; references the hold it converted.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Zero oversold orders (order confirmed but stock unavailable) in the 30 days after full rollout (baseline: 41 per month).
- **SC-002**: 95 % of checkout starts show the hold and remaining time within 1 second.
- **SC-003**: 99 % of expired holds are released within 60 seconds of expiry.
- **SC-004**: Checkout conversion does not drop more than 1 percentage point versus the 4 weeks before rollout.

## Assumptions

- Out of scope for this release: extending holds, per-item hold times, holds for logged-in wish lists, and holds in the mobile app.
- Payment authorization time is under 30 seconds in 99 % of cases, well inside the 15-minute hold.
- Stock adjustments by the warehouse continue to work as today.

---

## Relm Traceability *(mandatory — ORG-1, PRD-1, QA-2)*

**Feature ID**: RELM-1
**Central spec**: this file (product-level spec)
**Repository role**: product
**Contracts provided**: none (see `impact.md` for interface owners)
**Contracts consumed**: none
**Product stories covered**: all

**Status lifecycle**: Draft → In Review → Approved → Implemented → Released

### Scenario IDs
Scenarios are referenced as `RELM-1/US<k>/AS<m>`, e.g. `RELM-1/US2/AS2` = "submitted twice →
exactly one order". Every automated test that verifies a scenario starts its title with this ID.

| Scenario ID | Short name | Priority | Verified in |
|-------------|-----------|----------|-------------|
| RELM-1/US1/AS1 | hold on checkout start | P1 | inventory-service (provider), web-storefront (UI), e2e-tests |
| RELM-1/US1/AS2 | partial availability → no hold | P1 | inventory-service, web-storefront, e2e-tests |
| RELM-1/US1/AS3 | reload shows same hold | P1 | inventory-service, web-storefront, e2e-tests |
| RELM-1/US1/AS4 | held units unavailable to others | P1 | inventory-service, e2e-tests |
| RELM-1/US2/AS1 | order converts hold | P1 | orders-service, inventory-service, e2e-tests |
| RELM-1/US2/AS2 | double submit → one order | P1 | orders-service, web-storefront, e2e-tests |
| RELM-1/US2/AS3 | expired hold rejected | P1 | orders-service, web-storefront, e2e-tests |
| RELM-1/US3/AS1 | expiry releases units ≤ 60 s | P2 | inventory-service, e2e-tests (API level) |
| RELM-1/US3/AS2 | expired state on return | P2 | web-storefront, e2e-tests |
