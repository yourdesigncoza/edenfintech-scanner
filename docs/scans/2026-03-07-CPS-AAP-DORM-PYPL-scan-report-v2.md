# EdenFinTech Stock Scan -- 2026-03-07

## Scan Parameters
- Universe: Specific Tickers | Focus: CPS, AAP, DORM, PYPL | Stocks scanned: 4
- Date: 2026-03-07
- API: Financial Modeling Prep

## Executive Summary
- 0 stocks survived full analysis out of 4 scanned
- 2 stocks failed the broken chart test (CPS, DORM -- not sufficiently beaten down)
- 2 stocks passed screening but failed at analysis (AAP -- 100% downside kills score; PYPL -- epistemic confidence filter eliminates effective probability)
- **No recommendable candidates from this scan. All four existing holdings face material challenges for new capital deployment.**

## Ranked Candidates

**None.** No stock achieved a passing score after full analysis. Finding zero recommendable stocks is a valid outcome -- patience is an edge.

## Rejected at Screening

| Ticker | Failed At | Reason |
|--------|-----------|--------|
| CPS | Broken Chart Test | Only 32.1% off ATH ($47.12) at $32.00. Needs 60%+ decline. Stock has recovered significantly from ~$14 entry -- turnaround CAGR opportunity largely consumed by price appreciation. |
| DORM | Broken Chart Test | Only 34.3% off ATH ($166.34) at $109.33. Needs 60%+ decline. Not a broken chart -- stock is modestly discounted, not distressed. Estimated CAGR ~10% at current price. |

## Rejected at Analysis

### PYPL -- PayPal Holdings, Inc. ($46.97)
**Rejection Reason:** Epistemic confidence filter (base 60% x 0.70 = 42%, below 60% threshold)

- **Thesis:** PayPal is 84.8% off ATH with a new CEO (Enrique Lores, started March 1, 2026) pivoting to AI/agentic commerce. Revenue growing (5% YoY), FCF strong ($5.6B FY2025), aggressive buybacks reducing share count. The turnaround requires successful strategic pivot under 3rd CEO in ~18 months while defending against active securities fraud lawsuits.
- **Valuation:** Revenue $37B x FCF margin 18% x 15x / 900M shares = $111 (33.2% CAGR over 3yr)
  - Discount path: Baseline 15-20x payment processors -> 15x (CEO risk, legal uncertainty, competitive pressure from Apple Pay/Stripe)
- **Worst Case Floor:** Revenue $25.4B x FCF margin 14.1% x 8x / 959M shares = $29.88 (36.4% downside)
  - Trough path:
    - Revenue: $25.4B (FY2021, lowest in 5yr FMP data)
    - FCF Margin: 14.1% (FY2023, lowest in 5yr FMP data)
    - FCF Multiple: 8x (baseline 15x, -3x legal uncertainty, -2x CEO instability, -2x competitive erosion)
    - Shares: 959M (FY2025 actual, no buyback credit for trough)
  - TBV cross-check: TBV/share = $9.58 (FY2025). Floor $29.88 > 2x TBV ($19.16) -- flagged. Justified: payment processor value is in network/intangibles, not tangible assets. TBV is structurally low for asset-light fintech.
- **Moats:** Two-sided network (merchants + consumers), Venmo user base, Braintree processing infrastructure. Moats are real but eroding -- Apple Pay, Stripe, and embedded finance are taking share. Not a wide moat.
- **Catalysts:**
  - Cymbio acquisition (agentic commerce platform, closing H1 2026)
  - AI-powered merchant checkout optimization
  - Aggressive buyback ($6.05B FY2025, ~6.5% of shares annually)
  - Lores strategic plan articulation (expected mid-2026)
- **Management:** Enrique Lores (CEO since March 1, 2026). B-grade. Previously HP CEO where he managed the HP/HPE breakup -- execution-focused but not fintech native. Board cited "insufficient pace of execution" under prior CEO Chriss. Interim CEO Miller admitted to "too optimistic" timeline. Lores has been on PayPal board since 2021 and board chair since July 2024, so has institutional knowledge.
- **Pre-Epistemic Score:** 54.63 | **Suggested size (pre-epistemic):** 3-6%
- **Decision Score:** Downside 36.4% (adj 43.0) x 0.45 = 25.65 + Probability 60% x 0.40 = 24.00 + CAGR 33.2% x 0.15 = 4.98 = **54.63**
  - Ceiling: CEO <1yr tenure -> capped at 65% (analyst assigned 60%, below ceiling)
- **Epistemic Confidence:** 2/5 (raw 4/5 with 1 "No", Legal/Investigation friction -2)
  - Q1 Operational risk: **No** -- Active securities fraud lawsuits dominate risk profile. 3 law firms filed class actions alleging false revenue growth projections (Feb 2025 - Feb 2026). Evidence: Kirby McInerney LLP filing, deadline April 20, 2026.
  - Q2 Regulatory discretion: **Yes** -- Payment processor regulation is largely predictable. Evidence: FMP sector classification, CFPB oversight is established.
  - Q3 Historical precedent: **Yes** -- PayPal itself documented in sector knowledge; Square/Block turnaround comparable. Evidence: credit-services sector hydration (base rate ~80%).
  - Q4 Non-binary outcome: **Yes** -- Gradient of outcomes from margin normalization to full re-acceleration. Evidence: Revenue growing 5% YoY, FCF $5.6B positive.
  - Q5 Macro/geo limited: **Yes** -- Primarily US-centric, limited FX materiality. Evidence: FMP profile.
  - Risk-type friction: Legal/Investigation -> -2 (raw 4/5 -> adjusted 2/5). Active class action lawsuits force Legal risk classification.
  - Effective probability: 60% x 0.70 = **42%** -- FAILS 60% hard cap
  - Confidence cap: 5% (confidence 2/5)
  - **Threshold proximity warning**: base probability 60% is AT the 60% hard cap -- review for threshold anchoring
- **Probability Sensitivity (pre-epistemic, for reference):**

| Probability | Score | Size Band |
|-------------|-------|-----------|
| 55% | 52.63 | 0% -- fails hard cap |
| 60% | 54.63 | 3-6% |
| 65% | 56.63 | 6-10% |
| 70% | 58.63 | 6-10% |
| 75% | 60.63 | 6-10% |

Note: All bands are moot with confidence 2/5 (multiplier 0.70) -- even at 80% base, effective probability = 56%, still failing the 60% hard cap.

- **Structural Diagnosis:**
  - **Role:** Watchlist (not investable at current confidence level)
  - **What upgrades to 70+ score?** Lawsuits dismissed or settled without material damage + Lores demonstrates credible strategy with measurable TPV growth over 2-3 quarters + probability moves to 70% band with resolved legal overhang allowing confidence to rise to 4/5
  - **What breaks the thesis?** Lawsuit settlement exceeding $2B + continued CEO turnover + TPV share loss to Apple Pay/Stripe accelerates + FCF margin compression below 14%

### AAP -- Advance Auto Parts, Inc. ($50.33)
**Rejection Reason:** Score below 45 threshold (6.87) due to 100% downside from negative FCF trough floor

- **Thesis:** AAP is 79.2% off ATH in the midst of a CEO-led turnaround under Shane O'Kelly (HD Supply veteran). FY2025 showed positive comp sales for the first time in 3 years and 200+ bps margin expansion. Supply chain consolidation is underway. However, negative trough FCF margin means the worst-case floor is below zero.
- **Valuation:** Revenue $9.5B x FCF margin 6% x 18x / 60M shares = $171 (35.8% CAGR over 4yr)
  - Discount path: Baseline 18-25x aftermarket auto parts -> 18x (negative recent FCF history, heavy debt, turnaround execution risk)
- **Worst Case Floor:** Revenue $8.6B x FCF margin -3.4% x 10x / 60M shares = -$48.73 (downside capped at 100%)
  - Trough path:
    - Revenue: $8.6B (FY2025, lowest in 5yr FMP data)
    - FCF Margin: -3.4% (FY2025, lowest in 5yr FMP data)
    - FCF Multiple: 10x (aftermarket baseline 18x, -4x negative FCF history, -2x debt load, -2x execution risk)
    - Shares: 60M (FY2025 actual)
  - Heroic Optimism: N/A -- floor uses mechanical minimum-anchor inputs
  - TBV cross-check: TBV/share = $20.00 (FY2025). Floor is negative, far below TBV.
- **Moats:** Brand recognition (Advance Auto Parts, Carquest), 4,800+ store network, distribution infrastructure. Narrow moat -- O'Reilly and AutoZone have demonstrated superior execution and scale advantages.
- **Catalysts:**
  - Positive comparable sales growth (FY2025 Q4: +1.1%)
  - Supply chain consolidation (distribution center optimization, strategic store closures)
  - 200+ bps adjusted operating margin expansion in FY2025
  - 2026 guidance highlighting "continued progress on strategic plan"
- **Management:** Shane O'Kelly (CEO since Sep 2023, ~2.5yr tenure). B+ grade. Former HD Supply CEO with turnaround track record. Board brought him in specifically for operational reset. Early results are encouraging (positive comps, margin expansion).
- **Pre-Epistemic Score:** 6.87 | Effective probability: 60%
- **Decision Score:** Downside 100% (adj 150.0) x 0.45 = -22.50 + Probability 60% x 0.40 = 24.00 + CAGR 35.8% x 0.15 = 5.37 = **6.87**
- **Epistemic Confidence:** 5/5 (0 "No" answers, Operational risk type, friction 0)
  - Q1 Operational risk: **Yes** -- Primarily supply chain and execution risk. Evidence: Supply chain consolidation plan, store optimization.
  - Q2 Regulatory discretion: **Yes** -- Auto parts retail has minimal regulatory exposure. Evidence: Industry structure.
  - Q3 Historical precedent: **Yes** -- O'Reilly, AutoZone turnarounds; sector base rate ~60%. Evidence: auto-parts sector hydration.
  - Q4 Non-binary outcome: **Yes** -- Gradient from partial to full margin recovery. Evidence: FY2025 showing incremental improvement.
  - Q5 Macro/geo limited: **Yes** -- Aftermarket auto parts are recession-resistant. Evidence: Industry dynamics, sector knowledge.
  - Effective probability: 60% x 1.00 = **60%** -- passes hard cap
- **Why Rejected Despite Strong Confidence:** The mechanical floor produces a negative price because AAP's trough FCF margin is -3.4% (FY2025). With 100% downside, the scoring formula's adjusted downside is 150%, generating a deeply negative risk component (-22.50). No reasonable probability or CAGR can overcome this math. The stock's operational turnaround is real but the floor methodology correctly identifies extreme tail risk from heavy debt ($7.6B invested capital) combined with negative cash generation.
- **Structural Diagnosis:**
  - **Role:** Watchlist (score 6.87 -- catastrophically low due to downside math)
  - **What upgrades to 70+ score?** FCF margin turning sustainably positive (3%+) for 2+ consecutive quarters. This would mechanically fix the floor, reducing downside to ~50-60% range and lifting score to 35-45 range. Needs margin > 5% and reduced debt to score above 45.
  - **What breaks the thesis?** Continued negative FCF through FY2026 + market share losses to O'Reilly/AutoZone + inability to refinance debt at reasonable rates + supply chain consolidation fails to deliver cost savings

## Portfolio Impact
- Current positions: 10/12 | Available slots: 2
- 3 of 4 scanned tickers are existing holdings (CPS ~25%, AAP ~8%, PYPL ~11-20%)
- DORM is not currently in the portfolio

### Position-Specific Impact

**CPS** (~25% weight at ~$14 cost, now $32):
- Stock has appreciated ~129% from entry. Only 32.1% off ATH -- no longer a broken chart.
- Forward CAGR compressed significantly. Step 8 review should evaluate profit-taking given the $193 target in current-portfolio.md appears stale (per previous holding review, refreshed target is ~$92).
- Auto parts theme concentration is ~33% (CPS + AAP). Reducing CPS exposure would improve diversification.

**AAP** (~8% weight at ~$40.61 cost, now $50.33):
- Position is up ~24% from cost. Small position appropriate for risk profile.
- Turnaround showing early positive signals but mechanical floor is negative.
- Not recommending additional capital. Existing position governed by Step 8 sell rules.
- Watch: FCF margin trajectory is the single most important metric. Positive FCF = thesis intact.

**PYPL** (~11-20% weight at $41.10 cost, now $46.97):
- Position is up ~14% from cost. Near mechanical floor ($29.88).
- Maximum epistemic uncertainty from lawsuits + CEO instability.
- Not recommending additional capital. Step 8 deadline: mid-2026 for Lores to show credible strategy.
- Watch: Lawsuit resolution timeline and Q2 2026 earnings for Lores impact.

### Deployment Recommendation
**No new capital to any of these four tickers.** The 2 available portfolio slots should seek opportunities from full NYSE scans or sector-focused scans in sectors with lower current concentration. Auto parts theme is already at ~33% of portfolio -- approaching the 50% single-theme cap.

## Methodology Notes
- Qualitative assessments (moats, management, probability) are LLM estimates -- review critically
- Valuation multiples involve judgment -- verify reasoning matches your own assessment
- Catalyst timelines are estimates based on public information as of scan date
- CPS and DORM eliminated at broken chart test (Step 1) -- did not receive full analysis
- AAP and PYPL received full analysis (Steps 2-6)
- All scoring math computed via calc-score.sh (deterministic, not LLM-generated)
- Epistemic confidence assessed independently for both analyzed candidates
- PYPL: Legal/Investigation risk-type friction (-2) reduced confidence from 4/5 to 2/5, eliminating effective probability
- AAP: Operational risk type, no friction, 5/5 confidence -- but irrelevant given negative floor
- PYPL base probability AT the 60% hard cap -- threshold proximity warning flagged for potential anchoring bias
- Downside compliance: AAP floor uses mechanical minimum-anchor (negative FCF margin trough produces negative floor); PYPL floor uses 5yr trough inputs with stress multiple
- TBV cross-check: PYPL floor > 2x TBV (justified for asset-light fintech); AAP floor negative (below TBV)
- Scan produced 0 investable candidates -- valid outcome per methodology ("patience is an edge")

---
*Scan completed 2026-03-07 using EdenFinTech deep value turnaround methodology*
