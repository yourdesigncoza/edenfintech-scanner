# Downside Estimation Guardrail — Proposed Solution

Date: 2026-03-06
Status: Proposed (pending approval)

---

## Core Insight

The worst case should use the **exact same 4-input valuation formula** as the base case, but with trough inputs instead of recovery inputs. Not a different model. Not a waterfall of three methods. Same formula, run twice.

```
Base case:  Revenue(recovery) x Margin(normalized) x Multiple(fair) / Shares(adjusted) = Target
Worst case: Revenue(trough)   x Margin(trough)     x Multiple(trough) / Shares(worst)   = Floor
```

The problem isn't the concept — analyst.md already says "What if revenue grows slower? Margins don't recover? Multiple stays low?" The problem is that each trough input is unconstrained. The fix: anchor each trough input to historical data from FMP, the same way the base case anchors recovery inputs to industry baselines and discount schedules.

## Trough Input Anchoring

| Input | Base Case Anchor (existing) | Worst Case Anchor (new) |
|-------|---------------------------|------------------------|
| Revenue | Current + growth rate + catalysts | Lowest annual revenue in 5yr window, or flat if declining |
| FCF Margin | Historical baseline, normalized | Lowest annual FCF margin in 5yr window |
| Multiple | Industry baseline minus discount schedule | Lowest trading multiple in 5-10yr history (P/FCF or EV/FCF from FMP) |
| Shares | Current, adjusted for buybacks/dilution | Current diluted count. No buyback credit. Add dilution if cash < 1yr OpEx |

Every trough input comes from FMP data the analyst already pulls in Step 3. No new API calls. No new concepts.

## Mechanical Floor (calc-score.sh)

New command:
```bash
bash scripts/calc-score.sh floor <trough_revenue_B> <trough_margin_pct> <trough_multiple> <shares_M> <current_price>
```

Returns JSON:
```json
{
  "floor_price": 11.85,
  "downside_pct": 32.4,
  "inputs": {
    "trough_revenue_B": 2.2,
    "trough_margin_pct": 7.0,
    "trough_multiple": 10.0,
    "shares_M": 130.0,
    "current_price": 17.52
  }
}
```

Analyst runs this BEFORE writing any worst-case narrative. It's the starting point, not the conclusion.

## Asymmetric Override Rule

- Analyst can make the floor **worse** (more pessimistic) freely — lawsuits, fraud, covenant risk, event risk all justify a harsher floor. No flag needed.
- Analyst making the floor **better** (more optimistic than mechanical) triggers a **"Heroic Optimism" flag** — must justify why any trough input is better than the historical worst. Same rigor as the heroic assumptions test for the base case.

Heroic Optimism test — flag if ANY trough input is more favorable than the data:
- Revenue assumption above 5yr low
- Margin assumption above 5yr low
- Multiple assumption above historical trough trading multiple
- Shares assumption below current diluted count (assuming buybacks in a worst case)

## Cross-Check: Tangible Book Value

One simple cross-check against tangible book value per share (already in FMP data):
- If mechanical floor > 2x TBV: flag — floor may be too optimistic, stock could trade to asset value
- If TBV is negative: flag — asset backing is gone, downside could be worse than formula suggests
- If mechanical floor < TBV: fine — beaten-down stocks can trade below book

## Show the Trough Path

Mirrors the base case discount path. Every number traces to a specific historical data point:

```
Revenue trough: $2.2B (FY2023 low)
Margin trough: 7% (FY2021 low)
Multiple trough: 10x (2022 trading low, P/FCF)
Shares: 130M (current diluted, no buyback credit)
-> Floor: $11.85 = 32% downside
TBV cross-check: $8.50/share — floor is 1.4x TBV (OK)
```

Two analysts pulling the same FMP data arrive at the same trough inputs. Variance shrinks from narrative-driven (~30pp) to judgment-on-event-risk (~5-10pp).

## What This Fixes

The BRBR problem: both analysts would start from the same mechanical floor. The standalone analyst's 12% downside would trigger a heroic optimism flag. The sector analyst's 42% would be checked against the mechanical floor and TBV. Variance drops from 30pp to the range of legitimate judgment on event risk.

## Reference Files

- Problem analysis: `docs/plans/2026-03-06-downside-estimation-guardrail.md`
- Gemini analysis: `docs/plans/2026-03-06-downside-guardrail-gemini-analysis.md`
- GPT operational spec: `docs/plans/2026-03-06-downside-guardrail-chatgpt.md`
- Three-way comparison: `docs/plans/2026-03-06-downside-guardrail-three-way-comparison.md`
