# Requirements: Downside Estimation Guardrail

**Defined:** 2026-03-06
**Core Value:** Same stock + same data = same downside estimate. Reproducibility over precision.

## v1 Requirements

Requirements for this implementation. Each maps to roadmap phases.

### Calculator

- [x] **CALC-01**: `calc-score.sh floor` command accepts trough revenue, margin, multiple, shares, and current price -- returns floor price and downside %
- [x] **CALC-02**: `calc-score.sh floor` returns structured JSON matching existing calc-score.sh output patterns
- [x] **CALC-03**: `calc-score.sh floor` validates inputs and handles edge cases (zero margin, negative values)

### Analyst Agent

- [ ] **ANLST-01**: Analyst identifies trough inputs from 5yr FMP historical data already fetched in Step 3
- [ ] **ANLST-02**: Analyst runs `calc-score.sh floor` before writing worst-case narrative -- mechanical floor is the starting point
- [ ] **ANLST-03**: Analyst shows "trough path" tracing each input to a specific historical data point and fiscal year
- [ ] **ANLST-04**: Asymmetric override -- analyst can freely make floor harsher (event risk), but making it more optimistic triggers "Heroic Optimism" flag
- [ ] **ANLST-05**: Analyst cross-checks floor against tangible book value per share from FMP balance sheet

### Orchestrator Agent

- [ ] **ORCH-01**: Orchestrator audits that each scored candidate has a trough path with anchored inputs
- [ ] **ORCH-02**: Orchestrator rejects candidates where downside methodology is non-compliant (missing floor calc, unresolved heroic optimism flag, skipped TBV cross-check)

### Knowledge Files

- [ ] **KNOW-01**: strategy-rules.md documents the trough-anchored worst case specification with input anchoring table and asymmetric override rule
- [ ] **KNOW-02**: valuation-guidelines.md documents the Heroic Optimism test and TBV cross-check
- [ ] **KNOW-03**: scoring-formulas.md documents the downside anchoring requirement
- [ ] **KNOW-04**: CLAUDE.md references the new `floor` command

## v2 Requirements

Deferred to future work. Tracked but not in current scope.

- **AUTO-01**: Automated trough input lookup from cached FMP data (currently manual identification by analyst)
- **CROSS-01**: Cross-scan consistency tracking -- flag when same stock produces materially different downside across scans
- **EV-01**: EV-based worst case math (subtract net debt, divide by shares) for highly leveraged candidates

## Out of Scope

| Feature | Reason |
|---------|--------|
| EV-based valuation overhaul | Existing P/FCF captures leverage through multiple and FCF; too large a refactor |
| No-growth perpetuity floor | Doesn't work for turnaround stocks that trade below perpetuity value |
| Multiple floor methods (waterfall) | Overengineering -- same 4-input formula with trough inputs is simpler and consistent |
| Fully mechanical downside (no analyst judgment) | Turnarounds involve idiosyncratic risks (lawsuits, fraud) that history can't see |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| CALC-01 | Phase 1 | Complete |
| CALC-02 | Phase 1 | Complete |
| CALC-03 | Phase 1 | Complete |
| KNOW-01 | Phase 2 | Pending |
| KNOW-02 | Phase 2 | Pending |
| KNOW-03 | Phase 2 | Pending |
| KNOW-04 | Phase 2 | Pending |
| ANLST-01 | Phase 3 | Pending |
| ANLST-02 | Phase 3 | Pending |
| ANLST-03 | Phase 3 | Pending |
| ANLST-04 | Phase 3 | Pending |
| ANLST-05 | Phase 3 | Pending |
| ORCH-01 | Phase 3 | Pending |
| ORCH-02 | Phase 3 | Pending |

**Coverage:**
- v1 requirements: 14 total
- Mapped to phases: 14
- Unmapped: 0

---
*Requirements defined: 2026-03-06*
*Last updated: 2026-03-06 after Phase 1 completion*
