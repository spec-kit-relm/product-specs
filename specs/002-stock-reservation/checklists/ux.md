# UX Requirements Checklist: Stock reservation at checkout

**Purpose**: Are the shopper-facing requirements complete? (QA-1, FE-2)
**Created**: 2026-11-17 · **Feature**: [spec.md](../spec.md)

- [x] CHK001 Is it specified where and how the remaining hold time is shown? [Spec §FR-004, RELM-2/US1/AS1]
- [x] CHK002 Is the message for "only N available" specified, including how to adjust quantity? [RELM-2/US1/AS2]
- [x] CHK003 Is the expired-hold state on return specified, including the way to start again? [RELM-2/US3/AS2]
- [x] CHK004 Is the double-submit experience specified (same confirmation)? [RELM-2/US2/AS2]
- [x] CHK005 Are accessibility expectations for a live countdown stated (announcements not every second)? [Assumption → FE-1, recorded in web-storefront plan]
- [x] CHK006 Is behavior with the feature flag off specified (today's checkout)? [Spec §FR-010]
