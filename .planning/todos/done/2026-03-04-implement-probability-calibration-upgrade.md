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

2. **Base-rate anchoring with adjustment steps** — analyst must READ base rate from sector hydration Q6 turnaround precedents (dependency: sector researcher must produce this data). Analyst must NOT invent base rates. Then show documented adjustments to reach final band. If no sector knowledge exists or no precedents found, default to 50% band (conservative).

3. **Mandatory precedent naming** — analyst must cite closest historical turnaround case before assigning probability band. Grounds reasoning in real history rather than narrative logic.

4. **Decomposition as reasoning scaffold** — analyst must list sub-factors (management execution, balance sheet survival, market conditions) assessed on a Likert scale (Strong / Neutral / Weak). Do NOT multiply sub-factors (correlation trap). Sub-factor assessments feed into adjustments via fixed modifiers defined in scoring-formulas.md (not LLM-chosen percentages):
   - Strong = +10% adjustment
   - Neutral = 0%
   - Weak = -10% adjustment

Output format in analyst report should look like:
```
Sector base rate: ~60% (3 of 5 similar turnarounds succeeded)
Closest precedent: Synovus (2009-2013) — successful, 4yr timeline
Sub-factors:
  Management execution: Strong (+10%)
  Balance sheet survival: Strong (+10%)
  Market conditions: Weak (-10%)
Net adjustment: +10% → next band up
Final probability band: 70%
```

Dependencies:
- Sector researcher (TODO 1 / Phase A.5) must produce base rate data in Q6 output
- If no sector knowledge available, analyst defaults to 50% band

Changes needed in: analyst agent (probability assignment section), scoring-formulas.md (document banding requirement + Likert modifier table), orchestrator (validate probability is a valid band value), sector researcher (ensure Q6 outputs turnaround success count).
