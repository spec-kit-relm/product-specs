# Contract Lock: Stock reservation at checkout

**Feature ID**: RELM-1 | **Locked on**: 2026-11-19 | **Approved in**: inventory-service contract PR (`001-stock-reservation-contract`), orders-service contract PR (`001-stock-reservation-contract`)

Service plans for this feature reference ONLY the versions below (PRD-4). Changing a row needs a
PR in `product-specs` approved by the provider and every consumer listed.

| Contract | Provider repository | Version | Source (tag / commit) | Consumers | Status |
|----------|---------------------|---------|-----------------------|-----------|--------|
| inventory-api | inventory-service | 1.1.0 | `inventory-api-v1.1.0` | orders-service, web-storefront, e2e-tests | locked |
| inventory-events | inventory-service | 1.1.0 | `inventory-events-v1.1.0` | — (published for analytics) | locked |
| orders-api | orders-service | 1.3.0 | `orders-api-v1.3.0` | web-storefront, e2e-tests | locked |
