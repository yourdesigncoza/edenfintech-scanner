# Downside Estimation Guardrail

## What This Is

A deterministic guardrail for the worst-case downside estimation in the EdenFinTech stock scanning pipeline. Anchors the heaviest-weighted scoring input (45%) to historical financial data, eliminating LLM variance that currently produces wildly different scores for the same stock on the same day.

## Core Value

Same stock + same data = same downside estimate. Reproducibility over precision.

## Requirements

### Validated

(None yet -- ship to validate)

### Active

- [ ] `calc-score.sh floor` command computes mechanical floor price from trough inputs
- [ ] Analyst agent uses trough-anchored 4-input formula (same as base case, with historical lows)
- [ ] Analyst shows "trough path" tracing each input to FMP historical data
- [ ] Asymmetric override: pessimism free, optimism flagged ("Heroic Optimism" test)
- [ ] TBV cross-check flags when floor > 2x tangible book value or TBV is negative
- [ ] Orchestrator audits downside methodology compliance before ranking
- [ ] Strategy rules document the trough-anchored worst case specification
- [ ] Valuation guidelines document the Heroic Optimism test and TBV cross-check
- [ ] Scoring formulas document the downside anchoring requirement

### Out of Scope

- EV-based valuation overhaul -- Gemini suggested shifting to Enterprise Value math, but the existing P/FCF formula already captures leverage through the multiple and FCF. Too large a refactor for this change.
- No-growth perpetuity floor -- Doesn't work well for turnaround stocks that often trade below perpetuity value already (market prices in risk).
- Cross-scan consistency tracking -- Important but separate initiative. This guardrail reduces variance; tracking it is a different feature.
- Automated trough input lookup -- The analyst manually identifies trough inputs from FMP data already fetched in Step 3. Automating the lookup is a future enhancement.

## Context

**The problem (evidence):**
- BRBR standalone scan: 12% downside, score 68.47. BRBR sector scan (same day): 42% downside, score 51.53. A 17-point gap from downside alone.
- SAM went from "buy at 66.86" to "reject at screening" in 24 hours on identical FMP data.
- Three-scan comparison report (data/result/2026-03-06-three-scan-comparison-analysis.md) identifies LLM variance as the pipeline's biggest vulnerability.

**Why it exists:**
Every other scoring input has structural constraints -- probability is banded (50/60/70/80) with base-rate anchoring, ceilings, PCS friction, and epistemic review. CAGR is computed mechanically via calc-score.sh with a momentum gate. Downside (45% weight) has: "Every investment needs a downside estimate." That's the entire spec.

**External analysis:**
- Gemini analysis: `docs/plans/2026-03-06-downside-guardrail-gemini-analysis.md`
- GPT operational spec: `docs/plans/2026-03-06-downside-guardrail-chatgpt.md`
- Three-way comparison: `docs/plans/2026-03-06-downside-guardrail-three-way-comparison.md`

**The insight:** The worst case should use the exact same 4-input valuation formula as the base case, but with trough inputs anchored to historical data. Not a different model -- same formula, run twice.

## Constraints

- **Existing architecture**: Must work within the current agent pipeline (analyst.md, orchestrator.md, calc-score.sh). No new agents or scripts beyond extending calc-score.sh.
- **FMP data**: Trough inputs must come from data already fetched in Step 3 (income, balance, cashflow, ratios, metrics, price-history). No new API calls.
- **Simplicity principle**: "An investable idea should be obvious." Applies to the guardrail itself -- it must be simple enough for the analyst agent to follow consistently.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Same formula for base and worst case | Minimizes new concepts, mirrors existing structure | -- Pending |
| Asymmetric override (pessimism free, optimism flagged) | Prevents optimism bias while allowing legitimate event-risk adjustments | -- Pending |
| TBV as sole cross-check (not multiple methods) | Simplest meaningful cross-check, already in FMP data | -- Pending |
| Skip EV-based math | Existing P/FCF captures leverage through multiple and FCF; EV overhaul is too large | -- Pending |

---
*Last updated: 2026-03-06 after initialization*
