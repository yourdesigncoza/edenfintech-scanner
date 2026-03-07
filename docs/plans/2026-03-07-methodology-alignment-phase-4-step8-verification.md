# Methodology Alignment Phase 4 — Step 8 Verification Harness

Date: 2026-03-07
Phase: 4 (monitoring and sell-discipline workflow)

## Purpose

Verify existing holdings can be reviewed with a repeatable Step 8 process that is thesis-centered and forward-return aware.

## What This Verifies

1. `/review-holding` workflow runs independently of new-idea scan flow.
2. Holding review includes:
- thesis-integrity checklist (5 items)
- catalyst tracking table
- management consistency check
- margin/competitor drift check
- forward-return refresh
- explicit sell-trigger statuses (1/2/3)
3. Final verdict is one of:
- `HOLD`
- `HOLD_AND_MONITOR`
- `ADD_CANDIDATE`
- `TRIM / REDUCE`
- `EXIT`

## Required Test Cases

| Case Type | Pattern | Expected Verdict Direction |
|-----------|---------|----------------------------|
| Drawdown but thesis intact | Price down, catalysts still on track | HOLD / HOLD_AND_MONITOR |
| Rerated with low forward returns | Large move up, forward CAGR now weak | TRIM / REDUCE or EXIT |
| Slower thesis, not broken | Catalyst delays but business still viable | HOLD_AND_MONITOR |
| Thesis break | Business evidence contradicts thesis | EXIT |

## Command Sanity Checks

```bash
bash scripts/calc-score.sh forward-return 42.1 8.7 18 16 980 3
bash scripts/calc-score.sh cagr 42.1 65 3
```

Expected:
- JSON output
- no shell errors

## Repeatability Procedure

1. Run review for same holding twice on cached data.
2. Compare:
- thesis status stable
- sell-trigger statuses stable
- verdict stable

## Result Log Template

| Ticker | Thesis Status Stable | Trigger Status Stable | Verdict Stable | Notes |
|--------|----------------------|-----------------------|----------------|-------|
| TICK1 | Yes | Yes | Yes | |
| TICK2 | Yes | Yes | No | Explain changed assumption |

## Pass Criteria

Phase 4 is verified when:

1. Reviews are produced with full Step 8 structure.
2. Sell-trigger statuses are explicit and evidence-backed.
3. Verdicts map to thesis status and refreshed forward return.
4. Repeat runs with same inputs are directionally stable.
