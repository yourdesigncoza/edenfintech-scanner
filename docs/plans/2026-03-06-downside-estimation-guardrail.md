# Downside Estimation Guardrail — Discussion Notes

Date: 2026-03-06
Status: Under review (design not started)

## The Problem

Downside estimation is the **heaviest-weighted input** in the scoring formula (45%) but has **zero structural constraints**. The analyst invents a worst-case scenario from scratch each time, producing wildly different scores for the same stock.

### Evidence: BRBR — Same Stock, Same Day, Same Data

| Metric | Standalone Scan | Sector Scan |
|--------|----------------|-------------|
| Score | 68.47 (pre-epistemic) | 51.53 |
| Revenue target | $3.07B | $2.8B |
| FCF margin | 10% | 10% |
| FCF multiple | 16x | 20x |
| Shares | 115M | 127M |
| Price target | $42.71 | $44.09 |
| CAGR | 34.6% | 36% |
| **Downside** | **12%** | **42%** |
| Base probability | 60% | 60% |
| Effective probability | 30% | 30% |
| Final verdict | Rejected (epistemic) | Rejected (epistemic) |

The **17-point score gap** (68.47 vs 51.53) is almost entirely driven by the downside estimate (12% vs 42%). Without the lawsuit blocking both, one scan recommends buying, the other says borderline watchlist.

### Evidence: PYPL — A Better Approach (By Accident)

PYPL's analyst anchored the worst case to PayPal's **historical trough multiple** (8x — the lowest PYPL has ever traded at), producing a defensible 23.6% downside. But nothing in the methodology *required* this approach.

### Evidence: Three-Scan Comparison Report

`data/result/2026-03-06-three-scan-comparison-analysis.md` (line 140):

> "The biggest concern across all three scans isn't Gemini vs Perplexity — it's **analyst LLM variability**."

SAM went from "buy at 66.86" to "reject at screening" in 24 hours on identical data. BRBR confidence swung 3/5 -> 4/5 -> 1/5 across three scans.

## The Gap in the Methodology

| Scoring Input | Weight | Constraints |
|---------------|--------|------------|
| Probability (base) | 40% | Banded (50/60/70/80). Base-rate anchored. Likert modifiers (+/-10%). Ceilings. PCS friction. Epistemic review. |
| CAGR | 15% | Computed mechanically via calc-score.sh. Momentum gate for borderline cases. |
| **Downside** | **45%** | "Every investment needs a downside estimate." That's the entire spec. |

The 45%-weighted input has the least structure.

### What strategy-rules.md says (the entire guidance):

> **Reasonable Worst Case (Required)**
> - Every investment needs a downside estimate
> - Goal: asymmetry — limited downside vs. large upside

### What valuation-guidelines.md provides for the base case (but NOT worst case):

- Industry baseline multiples
- Discount schedule with fixed ranges
- Consistency rule (no multiple may deviate >5x from scan median)
- Heroic assumptions test
- "Show the discount path" requirement

## How Downside Is Done Elsewhere

1. **Sell-side analysts** — subjective bull/base/bear cases. Same variance problem we have.
2. **Value investors** (Buffett school) — margin of safety from intrinsic value. Don't compute a floor.
3. **Quant funds** — VaR, max drawdown, beta. Backward-looking, mechanical, but situation-blind.
4. **Distressed/turnaround investors** — liquidation value or tangible book value as hard floor. Mechanical and repeatable.

## Possible Direction

Mirror the base-case valuation structure for the worst case:

- **Anchor to data**: historical trough multiples/margins from FMP data (like PYPL's analyst did)
- **Discount path**: require "show the discount path" for worst case, not just base case
- **Consistency rule**: worst-case multiples can't deviate wildly within a scan
- **Heroic pessimism test**: inverse of the heroic assumptions test — flag if worst case assumes conditions worse than any historical period

The analyst still writes the narrative, but the floor price comes from a formula, not imagination. If they want to deviate, they must justify why.

## Reference Files

- Standalone BRBR scan: `docs/scans/2026-03-06-BRBR-scan-report.md`
- Sector scan (includes BRBR): in `data/scans/2026-03-06-consumer-defensive-scan-report.md`
- PYPL scan: `docs/scans/2026-03-06-PYPL-scan-report.md`
- Three-scan comparison: `data/result/2026-03-06-three-scan-comparison-analysis.md`
- Strategy rules: `knowledge/strategy-rules.md` (lines 130-132)
- Scoring formulas: `knowledge/scoring-formulas.md` (line 9)
- Valuation guidelines: `knowledge/valuation-guidelines.md`
