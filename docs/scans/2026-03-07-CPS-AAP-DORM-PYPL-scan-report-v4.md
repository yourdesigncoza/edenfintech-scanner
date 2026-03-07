# EdenFinTech Stock Scan -- 2026-03-07 (v4)

## Scan Parameters
- Universe: Specific tickers | Focus: CPS, AAP, DORM, PYPL | Stocks scanned: 4
- Date: 2026-03-07
- API: Financial Modeling Prep

## Executive Summary
- 0 stocks survived analysis out of 4
- DORM rejected at screening (only 34.5% off ATH, needs 60%+)
- CPS rejected at analysis (negative equity from operating deterioration caps probability at 50%, below 60% hard breakpoint)
- AAP rejected at analysis (trough FCF margins negative, floor price below zero, 100% scored downside, uninvestable score of 7.65)
- PYPL rejected at analysis (active securities fraud litigation forces Legal/Investigation risk type with -2 friction, effective probability 42% < 60% threshold)
- **Finding zero recommendable stocks is a valid outcome. Patience is an edge.**

## Ranked Candidates

*None. All four candidates were rejected. See rejection details below.*

## Portfolio Impact
- Current positions: 10/12 | Available slots: 2
- CPS (~25%), AAP (~8%), PYPL (~11-20%) are ALL existing holdings
- Auto parts concentration: ~33% of portfolio (CPS + AAP)
- This scan evaluates new capital allocation only. Existing positions are governed by Step 8 sell rules, not this scan's rejection criteria. Failing a new-capital scan does NOT trigger a sell.
- Deployment recommendation: Scenario 1 (cash available for 2 slots) -- no candidates meet investment criteria. Hold cash or seek opportunities in other sectors.

## Rejected at Screening

| Ticker | Failed At | Reason |
|--------|-----------|--------|
| DORM | Step 1 (broken chart) | Only 34.5% off ATH ($166.89 ATH Sep 2025, $109.33 current). Needs 60%+ decline. Rough CAGR estimate ~10% at current price -- well below 30% hurdle. |

## Rejected at Analysis

| Ticker | Failed At | Reason |
|--------|-----------|--------|
| CPS | Probability hard breakpoint | Negative equity (-$83.5M FY2025) from operating deterioration (5 consecutive years of net losses, not spinoff leverage). Probability ceiling: 60% (negative equity). Analyst assessment: 50% band (below ceiling). Below 60% hard breakpoint = size 0%. |
| AAP | Score / extreme downside | Trough FCF margins negative from 5yr FMP history (min: -3.5% FY2025). Floor calc: revenue $8.6B x -3.5% margin x 8x / 60.6M shares = -$39.74 floor price. Downside capped at 100%. Score: 7.65. Far below 45 investability threshold. |
| PYPL | Epistemic confidence filter | Pre-epistemic score 54.84 at 60% probability (CEO <1yr ceiling caps at 65%, banded to 60%). Active class-action securities fraud lawsuits (class period Feb 2025 - Feb 2026) trigger active litigation override, forcing Legal/Investigation risk type. PCS: raw 4/5 (1 "No"), friction -2, adjusted 2/5. Effective probability: 60% x 0.70 = 42%, below 60% threshold. |

### Detailed Rejection Analysis

#### CPS -- Cooper-Standard Holdings ($32.00, -77.9% off ATH)

**Step 2 Check Record:**

| Check | Verdict | Evidence | Threshold / Rule | Flag |
|-------|---------|----------|------------------|------|
| Solvency | BORDERLINE_PASS | Cash $198M, current debt $105M, LT debt $1.09B, FCF $16M, debt/FCF 73x. Cash covers current debt 1.9x. -77.9% off ATH prices in risk. | Priced-in risk + plausible survival | solvency_borderline |
| Dilution | PASS | SBC $9-15M (0.3-0.6% of revenue). Shares flat at ~17.9M. Rev/share CAGR +2.9%. | SBC <5%, rev/share improving | -- |
| Revenue | BORDERLINE_PASS | Revenue flat at ~$2.7B (5yr range $2.3-2.8B). No growth, but margin recovery is the thesis, not revenue growth. | Flat but catalyst-dependent | growth_borderline |
| ROIC | BORDERLINE_PASS | Median ROIC 1.6% (5yr: -12.2%, -7.5%, 3.6%, 4.4%, 1.6%). Recovering from deep negative but still below 6% threshold. Cyclical OEM supplier. | Below 6% but recovering, cyclical exception plausible | roic_borderline |
| Valuation | PASS | Rough CAGR ~42% at 5% FCF margin recovery, 12x multiple. But 5% margin is unprecedented for CPS in recent history. | CAGR passes hurdle but margin assumption is heroic | valuation_borderline |

**Why it fails:**
- **Negative equity**: -$83.5M (FY2025) from cumulative operating losses. This is genuine operating deterioration, NOT spinoff leverage. The 60% probability ceiling applies.
- **ROIC**: Median 1.6% -- capital destruction, not creation. Recent improvement (3.6% in FY2023, 4.4% in FY2024) is modest.
- **FCF margin reality**: Best 5yr FCF margin was 1.3% (FY2023). Achieving 5% needed for base case would be unprecedented. FY2025 FCF of $16M on $2.7B revenue = 0.6% margin.
- **Floor calc**: Trough revenue $2.33B x trough margin -9.1% x 8x / 18M shares = -$94.22. Downside capped at 100%.
- **Probability assessment**: Base rate ~60% for auto parts turnarounds, but negative equity + near-zero FCF margins + ROIC below cost of capital --> 50% band, below 60% hard breakpoint.
- **Score**: 3.93 (100% downside, 50% probability). Size: 0%.

**What would change this:** Sustained FCF margin recovery to 3%+ for at least 2 consecutive years, AND equity turning positive. Likely 2+ years away.

**Current Holding Overlay:**
- Holding status: Existing position (~25% weight, avg cost ~$14)
- New capital decision: DO NOT ADD
- Existing position action: HOLD (governed by Step 8, not this scan)
- Note: CPS holding review from 2026-03-07 showed forward CAGR 69% from $32 cost basis. The new-capital rejection does not affect the existing position.

#### AAP -- Advance Auto Parts ($50.33, -79.2% off ATH)

**Step 2 Check Record:**

| Check | Verdict | Evidence | Threshold / Rule | Flag |
|-------|---------|----------|------------------|------|
| Solvency | BORDERLINE_PASS | Cash $3.12B, current debt $435M, LT debt $5.22B, FCF -$298M. Cash covers current debt 7.2x. -79.2% off ATH. Negative FCF but strong cash position from Worldpac sale proceeds. | Negative FCF but substantial cash buffer | solvency_borderline |
| Dilution | PASS | SBC $36M (0.4% of revenue). Shares ~60M, modest decline from buybacks. | SBC well below 5% | -- |
| Revenue | BORDERLINE_PASS | Revenue declining: $11B (FY2021) to $8.6B (FY2025). Sold Worldpac division (explains some decline). New CEO Shane O'Kelly executing turnaround. | Declining but catalyst (CEO turnaround) identified | growth_borderline |
| ROIC | BORDERLINE_PASS | Median ROIC 0.4% (5yr: 8.9%, 6.1%, 0.4%, -8.9%, -1.4%). Severe deterioration from strong historical levels. | Below 6%, not yet recovering | roic_borderline |
| Valuation | BORDERLINE_PASS | Rough CAGR 10-41% depending on margin recovery assumptions. At historical 6% FCF margins + $9.5B revenue: 41%. At current margins: 10%. | Wide range, margin-dependent | valuation_borderline |

**Why it fails:**
- **Trough FCF margins are negative**: FY2024 -1.1%, FY2025 -3.5%. This is the trough anchor for worst-case floor.
- **Floor calc**: Revenue $8.6B x -3.5% margin x 8x / 60.6M shares = -$39.74 floor. Equity floor below zero --> scored downside capped at 100%.
- **Score**: 7.65 (100% downside, 60% probability, 41% CAGR). Score < 45 = size 0%.
- **Margin collapse**: Operating margins crashed from 7.5% (FY2021) to 1.9% (FY2025). FCF margins even worse due to high capex.
- **Revenue decline**: -21.8% from peak ($11B to $8.6B), partly from Worldpac divestiture.

**What would change this:** Clear evidence of FCF margin recovery to 3%+ (which would bring floor price to ~$28, downside ~44%, and potentially investable score). New CEO needs 2-3 quarters of margin execution proof. Watch FY2026 Q1/Q2 results.

**Current Holding Overlay:**
- Holding status: Existing position (~8% weight, avg cost ~$40.61)
- New capital decision: DO NOT ADD
- Existing position action: HOLD_AND_MONITOR (governed by Step 8)
- Note: Position is near breakeven. Monitor for margin improvement signals from new management.

#### PYPL -- PayPal Holdings ($46.97, -84.8% off ATH)

**Step 2 Check Record:**

| Check | Verdict | Evidence | Threshold / Rule | Flag |
|-------|---------|----------|------------------|------|
| Solvency | PASS | Cash $8.05B, LT debt $9.99B, FCF $5.56B. Debt/FCF 1.8x. Low solvency risk. | Strong cash flow and coverage | -- |
| Dilution | PASS | SBC $1.0B (3.0% of revenue). Aggressive buybacks: shares 1,174M to 959M (5yr), -18.3%. Rev/share CAGR +12.6%. | SBC offset by buybacks, strong per-share growth | -- |
| Revenue | PASS | Revenue growing: $25.4B (FY2021) to $33.3B (FY2025), 7% CAGR. Consistent growth. | Clear growth trend | -- |
| ROIC | PASS | Median ROIC 12.5% (5yr: 12.6%, 8.2%, 11.7%, 12.5%, 16.2%). Improving trend. Well above 6% threshold. | Strong and improving | -- |
| Valuation | BORDERLINE_PASS | Rough CAGR ~22-36% depending on multiple (15-18x). At 18x: 35.6% CAGR. Requires multiple expansion from current compressed ~9x. | Multiple-dependent, borderline hurdle | valuation_borderline |

**Base Case Valuation:**
- Revenue: $36B (growth from $33.3B, ~4% annual growth)
- FCF margin: 17% (FY2025 level, sustainable)
- FCF multiple: 18x (credit services baseline, adjusted for quality)
  - Discount path: Baseline 18-20x --> CEO uncertainty -2x --> competitive pressure -1x --> **18x** (net: modest discount)
- Shares: 940M (continued buyback program)
- **Target price: $117.19** (35.63% CAGR over 3yr)
- Valuation calc: `calc-score.sh valuation 36 17.0 18 940` --> $117.19
- CAGR calc: `calc-score.sh cagr 46.97 117.19 3` --> 35.63%

**Worst Case (Trough-Anchored):**
- Floor calc: `calc-score.sh floor 25.371 14.2 8 968 46.97` --> $29.77 (36.62% downside)
- Trough path:

| Input | Trough Value | Fiscal Year | FMP Data Point |
|-------|-------------|-------------|----------------|
| Revenue | $25.4B | FY2021 | income statement, lowest 5yr TTM |
| FCF Margin | 14.2% | FY2023 | cashflow $4.22B / income $29.77B |
| FCF Multiple | 8x | -- | Credit services 18x minus: -3x competitive pressure, -3x CEO/litigation, -2x volume decline risk, -2x margin compression risk = 8x |
| Shares | 968M | Current | FY2025 diluted, no buyback credit in worst case |

- TBV cross-check: Total Assets $80.2B - Total Liabilities $59.9B - Goodwill $10.9B - Intangibles $0.2B = TBV $9.2B. TBV/share = $9.2B / 968M = $9.50. Floor $29.77 > 2x TBV $19.00 --> **TBV flag: floor $29.77 > 2x TBV/share $9.50 -- flagged but PYPL is asset-light (tech platform), floor above TBV is expected.**
- Calibration rule: `default_min_5y` (no exception triggered for revenue or margin)

**Probability Assessment:**
- Base rate: Credit services turnaround ~80% (sector knowledge)
- Precedent: American Express 1991-95 (strategic refocus), Capital One 2008-12 (credit cycle recovery)
- Adjustments: Management Weak (-10%, brand new CEO with no fintech background), Balance sheet Strong (+10%, $8B cash, 1.8x debt/FCF), Market conditions Neutral (0%, e-commerce growth stable)
- Net: 80% + (-10% + 10% + 0%) = 80% --> 80% band
- Ceiling check: CEO tenure <1yr caps at 65%. Revenue has NOT declined 3+ consecutive years, so 65% decline ceiling does not apply.
- Final probability: **60%** (65% ceiling, banded to 60%)

**Pre-Epistemic Score:**
- `calc-score.sh score 36.62 60 35.63` --> **54.84**
- `calc-score.sh size 54.84 35.63 60 36.62` --> 6-10% (score band 55-64 after rounding)

**Epistemic Confidence Assessment:**

| # | Question | Answer | Justification | Evidence |
|---|----------|--------|---------------|----------|
| 1 | Operational risk? | **No** | Dominant risk is active securities fraud litigation and CEO instability (2nd CEO change in 3 years), not operational execution. | Gemini search: multiple class-action lawsuits filed (Goodman v. PayPal, N.D. Cal.), CEO Chriss departed Feb 2026 |
| 2 | Regulatory discretion minimal? | **Yes** | Payment processing is well-regulated but stable. No SEC investigation or regulatory enforcement action identified. | Gemini search: no regulatory actions beyond standard compliance |
| 3 | Historical precedent? | **Yes** | Credit services turnaround base rate ~80%. AmEx 1991-95, Capital One 2008-12, PYPL itself recovered from eBay spinoff uncertainty 2015-17. | Sector knowledge financial-services/precedents.md: 4 of 5 credit services precedents recovered |
| 4 | Non-binary outcome? | **Yes** | Gradient of outcomes: partial margin recovery, slower growth, Venmo monetization, status quo. Multiple business lines reduce binary risk. | FMP data: $33B+ revenue across PayPal, Venmo, Braintree, Xoom |
| 5 | Macro/geo limited? | **Yes** | Primarily company-specific thesis. Global diversification across 200+ markets. | FMP profile: operates in ~200 markets, ~100 currencies |

- **"No" count:** 1 --> **Raw confidence: 4/5**
- **Dominant Risk Type:** Legal/Investigation (active litigation override -- class-action securities fraud lawsuits)
- **Risk-type friction:** Legal/Investigation --> -2 (raw 4/5 --> adjusted 2/5)
- Note: Q1="No" partially captures the litigation risk, but the active litigation override rule is explicit: "Active litigation = binary outcome risk that supersedes operational concerns." Friction -2 is the floor for Legal/Investigation.
- **Adjusted confidence:** max(1, 4-2) = **2/5**
- **Multiplier:** x0.70
- **Effective probability:** 60% x 0.70 = **42%**
- **Threshold proximity warning:** Base probability AT the 60% hard cap -- review for threshold anchoring. The 60% base probability is itself a ceiling-constrained value (CEO tenure <1yr caps at 65%, banded to 60%).

**Post-Epistemic Score:**
- `calc-score.sh score 36.62 42 35.63 2` --> effective prob 29.4% (42% x 0.70 applied internally)
- Wait -- the effective prob calculation was already done: 60% x 0.70 = 42%. The score uses 42% as the probability input.
- Corrected: `calc-score.sh score 36.62 42 35.63` --> **42.60**
- Size: 0% (effective probability 42% < 60% hard breakpoint, score 42.60 < 45)
- Confidence cap: 5% (confidence 2/5)

**Human Judgment Flags:**
- Enrique Lores (ex-HP CEO, 30+ years tech) -- track record at HP was cost-cutting focus, not growth. Fintech domain expertise unclear. He served on PYPL board since ~2021 and was board chair, so has institutional knowledge but no operating fintech experience.
- Class-action lawsuit outcomes and potential settlement amounts are unknowable from public data. Lead plaintiff deadline April 20, 2026.
- Whether Lores will retain or rebuild PayPal's product leadership team is not yet observable.

**Probability Sensitivity (pre-epistemic, for context):**

| Probability | Score | Size Band |
|-------------|-------|-----------|
| 55% | 52.84 | 0% -- fails hard cap |
| 60% | 54.84 | 6-10% |
| 65% | 56.84 | 6-10% |
| 70% | 58.84 | 6-10% |
| 75% | 60.84 | 6-10% |

*Note: All scores above assume pre-epistemic probability. After epistemic friction (confidence 2/5, multiplier 0.70), effective probability falls below 60% at any base probability below 86% -- which is above the maximum 80% band. PYPL cannot pass the epistemic filter with its current risk profile.*

**What would change this:**
1. **Lawsuit settlement or dismissal** removing the litigation overhang and the Legal/Investigation risk classification
2. **Lores demonstrating fintech strategic vision** -- expect H2 2026 at earliest for credible evidence
3. **6+ months of CEO tenure** to lift the 65% probability ceiling (September 2026)
4. Re-evaluate Q4 2026 at earliest, when all three conditions could plausibly be partially met

**Current Holding Overlay:**
- Holding status: Existing position (~11-20% weight, avg cost $41.10)
- New capital decision: DO NOT ADD
- Existing position action: HOLD_AND_MONITOR (governed by Step 8)
- Step 8 review from 2026-03-07 rated PYPL as HOLD_AND_MONITOR with mid-2026 deadline for Lores to show credible strategy.
- Note: Stock near mechanical floor ($29.77). Current price $46.97 vs avg cost $41.10 -- modest gain. Forward CAGR depends heavily on CEO execution and litigation resolution.

## Methodology Notes
- Qualitative assessments (moats, management, probability) are LLM estimates -- review critically
- Valuation multiples involve judgment -- verify reasoning matches your own assessment
- Catalyst timelines are estimates based on public information as of scan date
- All scoring math computed via calc-score.sh (deterministic, not LLM-generated)
- Epistemic confidence assessed independently -- reviewer never sees analyst probability or score
- PCS answers are evidence-anchored -- each answer cites a source or declares NO_EVIDENCE
- Risk-type friction applied: PYPL classified Legal/Investigation per active litigation override (friction -2)
- Threshold proximity warning: PYPL base probability 60% is AT the 60% hard cap
- Active litigation override rule: class-action lawsuits force Legal/Investigation risk classification regardless of other factors
- CPS floor calc: `calc-score.sh floor 2.330 -9.1 8 18 32` --> -$94.22, downside capped at 100%
- AAP floor calc: `calc-score.sh floor 8.601 -3.5 8 60.6 50.33` --> -$39.74, downside capped at 100%
- PYPL floor calc: `calc-score.sh floor 25.371 14.2 8 968 46.97` --> $29.77, downside 36.62%
- Downside compliance audited for PYPL: floor calc present, trough path verified, TBV cross-check complete (flagged: floor > 2x TBV, acceptable for asset-light tech platform), calibration rules default_min_5y applied
- CPS and AAP: downside compliance moot -- negative trough margins produce negative floor prices, capped at 100% downside mechanically
- Sector knowledge verified fresh: Consumer Cyclical (hydrated 2026-03-07), Financial Services (hydrated 2026-03-07)
- Auto parts turnaround base rate: ~60% (sector knowledge: 2 of 5 successful, 2 partial, 1 failed)
- Credit services turnaround base rate: ~80% (sector knowledge: 4 of 5 recovered)
- This is the fourth analysis of these tickers on 2026-03-07. All four analyses produced zero survivors, confirming methodology consistency.

---
*Scan completed 2026-03-07 using EdenFinTech deep value turnaround methodology*
