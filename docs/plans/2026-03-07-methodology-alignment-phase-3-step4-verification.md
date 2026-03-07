# Methodology Alignment Phase 3 — Step 4 Verification Harness

Date: 2026-03-07
Phase: 3 (catalyst quality discipline)

## Purpose

Verify Step 4 distinguishes real catalysts from narrative noise and enforces the hard rule: no valid catalyst, no candidate.

## What This Verifies

1. Each scored candidate has a structured `Catalyst Quality Record`.
2. Items are classified as:
- `VALID_CATALYST`
- `SUPPORTING_TAILWIND`
- `WATCH_ONLY`
- `INVALID`
3. At least one `VALID_CATALYST` exists for any stock that survives Step 4.
4. Each candidate has an `Issues-And-Fixes Evidence Table`.
5. Management-response evidence status is explicit:
- `ANNOUNCED_ONLY`
- `ACTION_UNDERWAY`
- `EARLY_RESULTS_VISIBLE`
- `PROVEN`
6. Orchestrator rejects Step 4 non-compliance consistently.

## Case Set

| Case Type | Pattern | Expected |
|-----------|---------|----------|
| Strong catalyst case | Specific, time-bound, measurable operational catalyst | Survives Step 4 with >=1 `VALID_CATALYST` |
| Tailwind-only case | Mostly macro or narrative positives | Rejected as `no_valid_catalyst` |
| New-management-only case | Leadership change with limited execution proof | Mostly `WATCH_ONLY` / `ANNOUNCED_ONLY`; reject unless another valid catalyst exists |
| Mixed case | One real catalyst plus weak supporting points | Survives; weak points tagged `SUPPORTING_TAILWIND` / `INVALID` |

## Compliance Checks

For each candidate that reaches scoring:

1. Catalyst record present and complete.
2. At least one item marked `VALID_CATALYST`.
3. Issues/fixes table present with paired issue-response-evidence fields.
4. Evidence status present on management-driven items.

If any fail:
- move candidate to `Rejected at Analysis` with `step4_non_compliant` or `no_valid_catalyst`.

## Repeatability Procedure

1. Run the same cluster analysis twice using identical cached data.
2. Compare:
- catalyst classifications stable
- `VALID_CATALYST` presence stable
- reject/survive decision stable

## Result Log Template

| Ticker | Valid Catalyst Present | Classification Stable | Issues/Fixes Complete | Step 4 Audit Pass | Notes |
|--------|------------------------|-----------------------|-----------------------|-------------------|-------|
| TICK1 | Yes | Yes | Yes | Yes | |
| TICK2 | No | Yes | Yes | Rejected | `no_valid_catalyst` |

## Pass Criteria

Phase 3 is verified when:

1. Every scored candidate has structured catalyst classification.
2. False-positive catalysts are downgraded to tailwind/watch/invalid.
3. Stocks with no valid catalyst are consistently rejected.
4. Issues-and-fixes sections are evidence-backed, not narrative-only.
5. Orchestrator Step 4 audit rejects incomplete outputs consistently.
