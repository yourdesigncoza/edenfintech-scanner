# Methodology Canonical Regression Suite

Date: 2026-03-07
Status: Initial baseline

## Drift Categories

1. `no_drift`: classification unchanged, critical reasons intact
2. `soft_drift`: wording changed, classification intact
3. `material_drift`: classification or critical reasons changed
4. `intentional_drift`: behavior changed by design and documented

## Canonical Cases

| Case ID | Case Type | Pattern | Expected Classification | Critical Reason Guardrail |
|---------|-----------|---------|-------------------------|---------------------------|
| REG-001 | screening | WMT-style quality but expensive | REJECT_AT_SCREEN | Valuation hurdle fails despite quality |
| REG-002 | screening | CPS-style solvency scare but priced in | PASS_TO_ANALYST (borderline) | Solvency borderline explicit, not auto-fail |
| REG-003 | downside | BRBR-style edge case | PASS with calibrated downside path | Downside rule must be deterministic and documented |
| REG-004 | analysis | PYPL-style legal friction case | REJECTED_AT_ANALYSIS or low-confidence cap | Legal/investigation risk constrains confidence |
| REG-005 | cluster | Permanent margin erosion peer | ELIMINATED / PERMANENT_PASS | Step 3 margin gate enforced |
| REG-006 | catalyst | No real catalyst case | REJECTED_AT_ANALYSIS | No valid catalyst hard rule enforced |
| REG-007 | holding-review | Drawdown but thesis intact | HOLD or HOLD_AND_MONITOR | Price decline alone not thesis break |
| REG-008 | holding-review | Rerated, low forward returns | TRIM / REDUCE or EXIT | Sell trigger 1/2 enforcement |

## Review Procedure

Run this after changes to methodology-sensitive files:

- `knowledge/strategy-rules.md`
- `knowledge/scoring-formulas.md`
- `knowledge/valuation-guidelines.md`
- `.claude/agents/screener.md`
- `.claude/agents/analyst.md`
- `.claude/agents/orchestrator.md`
- `.claude/agents/holding-reviewer.md`
- `scripts/calc-score.sh`

Steps:
1. Select impacted canonical cases.
2. Run the relevant workflow(s) on cached data.
3. Compare against expected classification and critical reasons.
4. Record outcome and drift category.
5. If intentional change, log rationale in regression changelog.
