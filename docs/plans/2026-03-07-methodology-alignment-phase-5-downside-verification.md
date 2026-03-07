# Methodology Alignment Phase 5 — Downside Calibration Verification

Date: 2026-03-07
Phase: 5 (downside calibration)

## Purpose

Verify calibrated downside remains deterministic and auditable while reducing known edge-case distortions.

## Approved Calibration Rules

1. `growth_revenue_bound_70pct_current`
2. `margin_outlier_adjustment_second_lowest`
3. `combined` (both rules triggered)

Anything else is non-compliant.

## Deterministic Command Checks

```bash
bash scripts/calc-score.sh revenue-floor 8.7 4.1 17
bash scripts/calc-score.sh margin-floor -9 2 4 3 5
```

Expected:
- JSON output
- clear `rule` and `triggered` fields

## Case Types

| Case Type | Pattern | Expected Rule Behavior |
|-----------|---------|------------------------|
| Growth scale edge case | High 5y growth, very low early revenue minimum | `growth_revenue_bound_70pct_current` may trigger |
| Margin anomaly case | One severe margin outlier year | `margin_outlier_adjustment_second_lowest` may trigger |
| Stable mature business | No clear outliers | default minimum-anchor rule |
| Cyclical business | Troughs plausible across history | default or justified exception only |

## Audit Checks

For each candidate:

1. Floor command present.
2. Trough path complete.
3. Calibration rule named.
4. If exception used:
- trigger condition documented
- helper output shown
- rule is approved

Fail any -> `downside non-compliant`.

## Repeatability Procedure

1. Run same candidate with same cached data twice.
2. Confirm:
- selected calibration rule unchanged
- floor/downside direction unchanged
- compliance status unchanged

## Pass Criteria

Phase 5 is verified when:

1. Exceptions are deterministic and auditable.
2. Unapproved downside adjustments are rejected.
3. Default minimum-anchor behavior still works when no trigger exists.
4. Repeat runs with same data keep same calibration path.
