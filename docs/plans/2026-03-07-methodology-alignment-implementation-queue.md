# Methodology Alignment Implementation Queue

Date: 2026-03-07
Source inputs:
- `docs/scans/2026-03-07-CPS-AAP-DORM-scan-report.md`
- `docs/scans/review/2026-03-07-CPS-holding-review.md`

## Priority 1 — Enforce Deterministic Math In Output

Status: patched in prompt layer

Problem:
- reports still used narrative math where calculator JSON should have been authoritative

Required behavior:
- valuation, CAGR, floor, score, and size commands must appear with JSON output
- hurdle and score logic must use exact calculator values, not rounded prose values

Files:
- `.claude/agents/analyst.md`
- `.claude/agents/orchestrator.md`
- `.claude/agents/holding-reviewer.md`

## Priority 2 — Eliminate Post-Hoc Probability Overrides

Status: patched in prompt + audit layer

Problem:
- analyst probability narrative can drift after banding via override-style prose

Required behavior:
- final probability must match base rate + modifiers + nearest band + ceiling path
- post-hoc override language is non-compliant

Files:
- `.claude/agents/analyst.md`
- `.claude/agents/orchestrator.md`

## Priority 3 — Normalize Extreme Downside Reporting

Status: patched in prompt + audit layer

Problem:
- mechanical downside above 100% was shown narratively while score silently used 100%

Required behavior:
- show mechanical downside and scored downside separately
- explicitly state cap at 100% when equity floor is below zero

Files:
- `.claude/agents/analyst.md`
- `.claude/agents/orchestrator.md`

## Priority 4 — Keep Structured Fields Pure

Status: patched in prompt + audit layer

Problem:
- reasons were embedded inside enum cells in ranking tables

Required behavior:
- enum cells contain only enum values
- explanations live outside the table

Files:
- `.claude/agents/analyst.md`
- `.claude/agents/orchestrator.md`

## Priority 5 — Tighten Step 8 Review Format

Status: partially patched

Problem:
- holding review omitted calculator JSON and full catalyst implication structure

Required behavior:
- calculator-backed forward return
- catalyst table includes verdict/implication
- sell triggers reported as explicit yes/no with evidence

Files:
- `.claude/agents/holding-reviewer.md`

## Priority 6 — Add Existing-Holding Overlay In Scan Reports

Status: not yet patched

Problem:
- current holdings inside scan clusters blend Step 3-6 new-buy logic with Step 8 monitoring logic

Required behavior:
- if scanned ticker is already in `current-portfolio.md`, include a dedicated `Current Holding Overlay`
- separate `new buy decision` from `existing hold decision`

Files:
- `.claude/agents/analyst.md`
- `.claude/agents/orchestrator.md`

## Priority 7 — Fill Regression Baselines From Real Runs

Status: not yet executed

Use current artifacts to seed the harness:
- `CPS/AAP/DORM` scan -> Phase 2, 3, 5 baselines
- `CPS` holding review -> Phase 4 baseline

Files to update:
- `docs/plans/2026-03-07-methodology-alignment-phase-2-step3-verification.md`
- `docs/plans/2026-03-07-methodology-alignment-phase-3-step4-verification.md`
- `docs/plans/2026-03-07-methodology-alignment-phase-4-step8-verification.md`
- `docs/plans/2026-03-07-methodology-alignment-phase-5-downside-verification.md`
- `docs/regression/methodology-canonical-suite.md`

## Recommended Next Execution Order

1. Re-run `/scan-stocks CPS AAP DORM`
2. Re-run `/review-holding CPS`
3. Compare outputs against this queue
4. Log results into verification docs
5. Patch any remaining format drift
