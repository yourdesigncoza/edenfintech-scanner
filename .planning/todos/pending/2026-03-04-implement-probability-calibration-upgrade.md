---
created: 2026-03-04T11:18:25.930Z
title: Implement probability calibration upgrade
area: tooling
files:
  - agents/analyst.md
  - agents/orchestrator.md
  - knowledge/scoring-formulas.md
  - knowledge/strategy-rules.md
---

## Problem

Probability estimates are the weakest variable in the scoring formula (40% weight). The base estimate is unanchored — the analyst produces a single number with no structured reasoning trail. Two runs of the same stock can produce different probabilities. LLMs tend toward middle-of-range estimates and can be influenced by narrative quality rather than actual likelihood. A 10-point probability swing shifts the score by 4 points — enough to jump a position-sizing band.

The PCS layer controls gaming but does NOT control calibration. The starting probability has no objective anchor.

## Solution

Four changes, in priority order:

1. **Probability banding** — force analyst to use 50/60/70/80 bands only, eliminating fake precision (67% vs 72% is meaningless). Stabilizes repeat runs.

2. **Base-rate anchoring with adjustment steps** — analyst must start from sector hydration Q6 turnaround precedent base rate (e.g., "3 of 5 similar turnarounds succeeded = ~60%"), then show documented adjustments (+/- for specific factors) to reach final band. Source rates from sector knowledge, NOT invented tables.

3. **Mandatory precedent naming** — analyst must cite closest historical turnaround case before assigning probability band. Grounds reasoning in real history rather than narrative logic.

4. **Decomposition as reasoning scaffold** — analyst must list sub-factors (management execution, balance sheet survival, market conditions) with individual assessments. Do NOT multiply sub-factors (correlation trap — correlated factors produce systematically low numbers). Use as reasoning documentation only.

Output format in analyst report should look like:
```
Sector base rate: ~60% (3 of 5 similar turnarounds succeeded)
Closest precedent: Synovus (2009-2013) — successful, 4yr timeline
Sub-factors: Management ✓ | Balance sheet ✓ | Market conditions ✗
Adjustments: +10% strong balance sheet, -10% regulatory risk
Final probability band: 60%
```

Changes needed in: analyst agent (probability assignment section), scoring-formulas.md (document banding requirement), orchestrator (consistency check that probability is a valid band value).
