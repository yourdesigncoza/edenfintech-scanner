# Roadmap: Downside Estimation Guardrail

## Overview

Anchor the worst-case downside estimation (45% of score weight) to historical FMP data using the same 4-input valuation formula with trough inputs. Three phases: build the calculator, update knowledge files, then wire agents to use both. Eliminates the LLM variance that produces 17-point score gaps for the same stock on the same day.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

- [x] **Phase 1: Calculator** - Add `floor` command to calc-score.sh for mechanical worst-case floor price
- [ ] **Phase 2: Knowledge Files** - Document trough-anchored worst case spec across strategy-rules, valuation-guidelines, scoring-formulas, and CLAUDE.md
- [ ] **Phase 3: Agent Integration** - Wire analyst structured worst-case process and orchestrator compliance audit

## Phase Details

### Phase 1: Calculator
**Goal**: A deterministic floor price calculator exists and produces reproducible results from trough inputs
**Depends on**: Nothing (first phase)
**Requirements**: CALC-01, CALC-02, CALC-03
**Success Criteria** (what must be TRUE):
  1. Running `calc-score.sh floor 2.2 7.0 10 130 17.52` returns valid JSON with floor_price and downside_pct
  2. Running the same command twice produces identical output
  3. Edge cases (zero margin, missing args, negative values) return sensible results or clear errors, never crash
**Plans**: 1 plan

Plans:
- [x] 01-01: Implement floor command in calc-score.sh (help text, command logic, edge case handling, tests)

### Phase 2: Knowledge Files
**Goal**: All knowledge files consistently document the trough-anchored worst case specification so agents have a single source of truth
**Depends on**: Nothing (parallel with Phase 1)
**Requirements**: KNOW-01, KNOW-02, KNOW-03, KNOW-04
**Success Criteria** (what must be TRUE):
  1. strategy-rules.md contains the trough input anchoring table, asymmetric override rule, and trough path format
  2. valuation-guidelines.md contains the Heroic Optimism test and TBV cross-check specification
  3. scoring-formulas.md references downside anchoring and the floor command as the mechanical starting point
  4. CLAUDE.md documents the `floor` command with usage example
**Plans**: TBD

Plans:
- [ ] 02-01: Update strategy-rules.md, valuation-guidelines.md, scoring-formulas.md, and CLAUDE.md with worst-case specification

### Phase 3: Agent Integration
**Goal**: The analyst agent produces trough-anchored worst cases and the orchestrator rejects non-compliant candidates
**Depends on**: Phase 1 (analyst needs floor command), Phase 2 (analyst references knowledge file specs)
**Requirements**: ANLST-01, ANLST-02, ANLST-03, ANLST-04, ANLST-05, ORCH-01, ORCH-02
**Success Criteria** (what must be TRUE):
  1. Analyst agent instructions specify the 5-step structured worst-case process (identify trough inputs, run floor calc, TBV cross-check, analyst adjustment, show trough path)
  2. Analyst instructions require running `calc-score.sh floor` before writing any worst-case narrative
  3. Orchestrator has a downside consistency audit step that rejects candidates missing floor calc, unresolved heroic optimism flags, or skipped TBV cross-check
  4. End-to-end test with BRBR and PYPL trough inputs produces reproducible, reasonable floor prices
**Plans**: TBD

Plans:
- [ ] 03-01: Update analyst.md structured worst-case process and orchestrator.md downside audit
- [ ] 03-02: End-to-end verification with BRBR and PYPL test cases

## Progress

**Execution Order:**
Phases 1 and 2 can execute in parallel. Phase 3 depends on both.

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Calculator | 1/1 | Complete | 2026-03-06 |
| 2. Knowledge Files | 0/1 | Not started | - |
| 3. Agent Integration | 0/2 | Not started | - |
