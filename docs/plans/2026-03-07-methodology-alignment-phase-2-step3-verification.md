# Methodology Alignment Phase 2 — Step 3 Verification Harness

Date: 2026-03-07
Phase: 2 (peer-ranking auditability)

## Purpose

Verify Step 3 competitor comparison is auditable, method-ordered, and consistent with EdenFinTech ranking logic.

## What This Verifies

1. Every analyzed cluster contains a `Cluster Ranking Record`.
2. Ranking dimensions are separated:
- `Survival Quality`
- `Business Quality`
- `Return Quality`
3. Margin erosion gate is explicit:
- long-term erosion -> `PERMANENT_PASS`
4. Non-winner retention is explicit and rare:
- no earlier-step failure
- materially higher return potential
- limited alternatives
5. Orchestrator applies Step 3 completeness audit and flags non-compliance.

## Required Cluster Outputs

Each cluster must include:

1. Competitor comparison table.
2. Quality ordering rationale.
3. Cluster ranking table with:
- `Margin Trend Gate` (`PASS` / `PERMANENT_PASS`)
- `Final Cluster Status` (`CLEAR_WINNER`, `CONDITIONAL_WINNER`, `LOWER_PRIORITY`, `ELIMINATED`)
4. Cluster verdict (winner / backup / eliminated).
5. If backup retained: explicit "Why kept despite lower quality" block.

## Case Set

| Case Type | Pattern | Expected |
|-----------|---------|----------|
| Clear balance-sheet winner | One name clearly strongest survival profile | `CLEAR_WINNER` aligned to survival-first ordering |
| Quality vs upside split | Best business not highest upside | `CONDITIONAL_WINNER` or clear rationale for ordering tradeoff |
| Margin erosion elimination | One name with 5+ year margin decay | `PERMANENT_PASS` + `ELIMINATED` |
| Backup justified | Non-winner retained due to materially higher returns and limited alternatives | Explicit keep rationale present |

## Repeatability Check

For each case:

1. Run analysis on same cached data.
2. Re-run immediately.
3. Compare:
- winner status unchanged
- permanent-pass decisions unchanged
- backup keep logic unchanged

## Result Log Template

| Cluster | Winner Stable | Permanent-Pass Stable | Backup Rule Applied Correctly | Step 3 Audit Pass | Notes |
|---------|----------------|-----------------------|-------------------------------|-------------------|-------|
| Auto Parts A | Yes | Yes | Yes | Yes | |
| Cluster B | Yes | N/A | N/A | Yes | |

## Pass Criteria

Phase 2 is verified when:

1. All tested clusters emit complete ranking records.
2. Survival-first ranking order is visible in rationale.
3. Margin-erosion candidates are consistently `PERMANENT_PASS`.
4. Backup candidates are retained only with method-consistent justification.
5. Orchestrator flags incomplete Step 3 outputs as `step3_non_compliant`.
