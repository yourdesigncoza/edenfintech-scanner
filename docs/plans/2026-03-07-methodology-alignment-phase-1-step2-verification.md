# Methodology Alignment Phase 1 — Step 2 Verification Harness

Date: 2026-03-07
Phase: 1 (Step 2 first-filter hardening)

## Purpose

Validate that Step 2 first-filter outputs are repeatable, auditable, and mapped to explicit check-level evidence.

## What This Verifies

1. Every Step 2 stock emits all five checks with:
- `verdict` (`PASS` / `BORDERLINE_PASS` / `FAIL`)
- `evidence`
- `threshold_or_rule`
- `flag` (or `—`)
2. Final stock outcome is explicit:
- `PASS_TO_ANALYST`
- `REJECT_AT_SCREEN`
3. Notable rejection reason traces to an explicit failed check.
4. Borderline cases carry correct flags into analyst handoff.

## Deterministic Helper Sanity Checks

Run once before case validation:

```bash
bash scripts/calc-score.sh rev-share-trend 1200 1180 1220 1260 1320 100 101 102 103 104
bash scripts/calc-score.sh median 4.1 8.9 6.0 2.3 7.4
bash scripts/calc-score.sh solvency-snapshot 750 420 980 160
bash scripts/calc-score.sh rough-hurdle 15.25 2.4 11 16 120 3
```

Expected:
- JSON output for all four commands
- No shell errors

## Case Set

Use a fixed, small set to test repeatability.

| Case Type | Candidate Pattern | Expected Step 2 Result |
|-----------|-------------------|------------------------|
| Clean pass | Healthy solvency, acceptable dilution, growth/catalyst, ROIC >= 6%, valuation >= 30% CAGR | `PASS_TO_ANALYST` with mostly `PASS` |
| Dilution fail | SBC > 5% + weak rev/share trend or debt-service issuance | `REJECT_AT_SCREEN` with `Dilution = FAIL` |
| Valuation fail | Rough CAGR clearly < 25% | `REJECT_AT_SCREEN` with `Valuation = FAIL` |
| Solvency borderline | Survival uncertain but risk appears priced in | `PASS_TO_ANALYST` + `solvency_borderline` |
| Cyclical ROIC exception | Weak median ROIC but recoverable up-cycle economics | `PASS_TO_ANALYST` + `roic_borderline` or `PASS` |

## Repeatability Procedure

For each case:

1. Run screener pass with identical cached data (same date, no `--fresh`).
2. Record full Step 2 check table.
3. Re-run immediately with same inputs.
4. Compare:
- check verdicts unchanged
- threshold/rule wording equivalent
- final stock outcome unchanged

## Result Log Template

| Ticker | Run 1 Outcome | Run 2 Outcome | Check-Level Match | Borderline Flags Match | Notes |
|--------|----------------|----------------|-------------------|------------------------|-------|
| TICK1 | PASS_TO_ANALYST | PASS_TO_ANALYST | Yes | Yes | |
| TICK2 | REJECT_AT_SCREEN | REJECT_AT_SCREEN | Yes | N/A | |

## Pass Criteria

Phase 1 Step 2 hardening is verified when:

1. All sampled stocks include five explicit check rows.
2. All rejection reasons map to a specific `FAIL` check.
3. Repeat runs with same data produce identical Step 2 outcomes.
4. Borderline flags are preserved in orchestrator handoff.
