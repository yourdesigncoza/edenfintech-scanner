# Methodology Alignment Phase 6 — Regression Harness Verification

Date: 2026-03-07
Phase: 6 (methodology drift protection)

## Purpose

Verify the regression harness exists, is usable, and covers full lifecycle behaviors (new ideas + monitoring).

## Required Artifacts

1. Regression case template:
- `docs/regression/methodology-regression-template.md`
2. Canonical suite:
- `docs/regression/methodology-canonical-suite.md`
3. Baseline changelog:
- `docs/regression/methodology-regression-changelog.md`

## Coverage Check

Canonical suite must include cases for:
- screening behavior
- Step 3 peer ranking
- Step 4 catalyst quality
- downside calibration
- holding-review / sell logic

## Procedure Check

Confirm suite doc specifies:
1. trigger files that require regression rerun
2. drift categories (`no_drift`, `soft_drift`, `material_drift`, `intentional_drift`)
3. how to log intentional behavior changes

## Pass Criteria

Phase 6 is verified when:
1. All required artifacts exist.
2. Initial canonical case set is populated.
3. Drift categories are explicitly defined.
4. Baseline change logging is operational.
