---
phase: 01-calculator
plan: 01
subsystem: calculator
tags: [bash, python3, deterministic-math, floor-price, downside]

# Dependency graph
requires: []
provides:
  - "calc-score.sh floor command: mechanical worst-case floor price from trough inputs"
  - "Downside percentage calculation from current price vs floor price"
affects: [02-knowledge-files, 03-agent-integration]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "floor command mirrors valuation command structure (same 4-input formula + downside calc)"
    - "validate_pct for margin (warns on decimal-looking values), validate_number for other inputs"

key-files:
  created: []
  modified:
    - scripts/calc-score.sh

key-decisions:
  - "Reused exact valuation formula for floor price (revenue * margin * multiple * 1000 / shares) to minimize new concepts"
  - "current_price must be positive (division-by-zero guard), negative floor prices allowed (worst case scenario)"
  - "Negative downside_pct means floor is above current price (upside scenario) -- valid output, not an error"

patterns-established:
  - "Floor command: 5 args (revenue_b, margin_pct, multiple, shares_m, current_price) returning JSON with all inputs echoed plus fcf_b, floor_price, downside_pct"

requirements-completed: [CALC-01, CALC-02, CALC-03]

# Metrics
duration: 2min
completed: 2026-03-06
---

# Phase 1 Plan 1: Implement floor command Summary

**Deterministic floor price calculator using trough inputs (same 4-input valuation formula) with downside percentage from current price**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-06T18:05:22Z
- **Completed:** 2026-03-06T18:07:23Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Floor command computes worst-case price from trough revenue, margin, multiple, and share count
- Downside percentage derived mechanically: same stock + same trough inputs = same downside every time
- 10-point validation battery passes: reproducibility, negative margin, upside scenario, large values, decimal warnings, non-numeric, negative shares/price, help text, cross-check with valuation
- floor_price exactly matches valuation target_price for same 4 inputs (formula parity confirmed)

## Task Commits

Each task was committed atomically:

1. **Task 1: Implement floor command in calc-score.sh** - `2e8daf7` (feat)
2. **Task 2: Reproducibility and edge case validation** - no code changes (validation-only task, all 10 checks passed)

## Files Created/Modified
- `scripts/calc-score.sh` - Added floor command (help text, case block with 5-arg validation and python3 computation)

## Decisions Made
- Reused exact valuation formula for floor price computation -- minimizes new concepts, guarantees formula parity
- current_price validated as positive (prevents division by zero), but negative floor prices are valid output (worst case with negative margin)
- Negative downside_pct is valid output (means floor is above current price -- upside scenario)

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- floor command ready for use by analyst agents (Phase 3)
- Knowledge files can reference `calc-score.sh floor` with working examples (Phase 2)
- No blockers or concerns

---
*Phase: 01-calculator*
*Completed: 2026-03-06*
