# QA Checklist: Stock reservation at checkout

**Purpose**: Are the scenarios testable and traceable? (QA-1, QA-2, QA-3)
**Created**: 2026-11-17 · **Feature**: [spec.md](../spec.md)

- [x] CHK001 Does every acceptance scenario have a stable ID (`RELM-2/US<k>/AS<m>`)? [Spec §Relm Traceability]
- [x] CHK002 Is every P1 scenario independently testable with synthetic data? [Spec §User Stories]
- [x] CHK003 Is the 15-minute expiry testable without waiting 15 minutes (configurable TTL in test environments)? [Spec §FR-002 → inventory-service plan]
- [x] CHK004 Is the 60-second release requirement measurable in staging? [Spec §SC-003]
- [x] CHK005 Is it clear which repositories verify each scenario? [Spec §Scenario IDs table]
- [x] CHK006 Are contract versions for E2E defined before E2E planning? [contracts.lock.md]
- [ ] CHK007 Is a load profile for SC-002 (1 s at p95) defined? — *accepted: inventory-service plan defines it (BE-5)*
