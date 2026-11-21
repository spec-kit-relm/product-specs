# API Requirements Checklist: Stock reservation at checkout

**Purpose**: Are the requirements complete enough for providers to write contracts? (QA-1)
**Created**: 2026-11-17 · **Feature**: [spec.md](../spec.md)

## Completeness

- [x] CHK001 Is the behavior for a partially available cart defined (all-or-nothing)? [Spec §FR-001, RELM-1/US1/AS2]
- [x] CHK002 Is the hold duration and whether it can be extended specified? [Spec §FR-002]
- [x] CHK003 Is the result of repeated order submissions specified? [Spec §FR-007, RELM-1/US2/AS2]
- [x] CHK004 Is the response to an expired hold at order time defined from the shopper's view? [Spec §FR-008, RELM-1/US2/AS3]
- [x] CHK005 Is the maximum time to release an expired hold quantified? [Spec §FR-009, SC-003]

## Clarity & consistency

- [x] CHK006 Is "one active hold per cart" consistent with reopening checkout in another tab? [Spec §FR-005, Edge Cases]
- [x] CHK007 Is the expiry-during-submission race resolved unambiguously? [Spec §Edge Cases]
- [ ] CHK008 Is behavior defined when a warehouse adjustment makes a held unit physically unavailable? [Spec §Edge Cases] — *accepted by PO in review: holds stay valid; handled by existing back-order process*

## Notes

- Items are ticked by humans only. CHK008 accepted with reason in the Gate 1 PR thread.
