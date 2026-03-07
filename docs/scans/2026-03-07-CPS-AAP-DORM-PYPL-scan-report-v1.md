# EdenFinTech Stock Scan -- 2026-03-07

## Scan Parameters
- Universe: Specific tickers | Focus: CPS, AAP, DORM, PYPL | Stocks scanned: 4
- Date: 2026-03-07
- API: Financial Modeling Prep
- Screening: Phase 1 SKIPPED (user-specified tickers, direct to Phase 2)

## Executive Summary
- 0 stocks survived the full pipeline out of 4 analyzed
- DORM failed on CAGR (9.7%, below 20% minimum). CPS failed on probability (50%, below 60% hard cap). AAP failed on score (6.57, below 45 minimum) with 100% trough downside. PYPL failed the epistemic confidence filter (effective probability 30%, below 60% threshold).
- Finding zero recommendable stocks is a valid outcome. All four are current portfolio holdings -- this scan provides a methodology-consistent health check, not a recommendation to sell.

## Ranked Candidates

*No candidates passed all pipeline filters. See "Rejected at Analysis" below for complete details on each stock.*

---

## Detailed Analysis: Auto Parts Cluster (CPS, AAP, DORM)

### Competitor Comparison

| Metric | CPS | AAP | DORM |
|--------|-----|-----|------|
| Market Cap | $564M | $3.0B | $3.3B |
| Business Type | OEM supplier (sealing, fuel/brake) | Aftermarket retailer | Aftermarket parts manufacturer |
| Revenue (FY2025) | $2.74B | $8.6B | $2.13B |
| Revenue 5yr Trend | Flat ($2.38B->$2.74B) | Declining ($11B->$8.6B) | Growing ($1.09B->$2.13B) |
| Gross Margin (latest) | 11.7% | 43.7% | 41.1% |
| Operating Margin (latest) | 3.9% | 1.9% | 16.8% |
| FCF Margin (latest) | 0.6% | -3.5% | 3.6% |
| Debt | $1,263M | $7,471M | $633M |
| Equity | -$83M (negative) | $2,198M | $1,477M |
| ND/EBITDA | 5.2x | 10.0x | 1.6x |
| ROIC (latest) | 1.6% | -1.4% | 13.0% |
| ROCE (latest) | 9.3% | 1.9% | 17.9% |
| ROIC (5yr median) | ~1.6% | ~0.4% | ~10.6% |
| Shares (5yr change) | +4.8% (16.9M->17.9M) | -6.4% (64M->59.9M) | -4.7% (32.3M->30.8M) |
| SBC % Revenue | <1% | <1% | <1% |
| Current Price | $32.00 | $50.33 | $109.33 |
| 52wk Range | $10.38-$47.98 | $28.89-$70.00 | $106.95-$166.89 |

**Quality Ranking:** DORM > AAP > CPS
**Reasoning:** DORM dominates on every quality metric: strongest balance sheet (ND/EBITDA 1.6x vs 5.2x and 10.0x), highest ROIC (13.0%), best margins (16.8% operating), and only company with consistent FCF generation. AAP has massive scale but severe operational challenges. CPS has negative equity and the weakest profitability.

### Cluster Ranking Record

| Ticker | Survival Quality | Business Quality | Return Quality | Margin Trend Gate | Final Cluster Status |
|--------|------------------|------------------|----------------|-------------------|----------------------|
| DORM | Strong | Strong | Weak | PASS | ELIMINATED |
| AAP | Weak | Weak | Moderate | PASS | ELIMINATED |
| CPS | Weak | Weak | Moderate | PASS | ELIMINATED |

- DORM: Strong on quality but Weak on returns (9.7% CAGR, far below 30% hurdle). Price has not fallen enough to create a deep value entry. Eliminated on CAGR fail.
- AAP: Weak survival quality (ND/EBITDA 10.0x, negative FCF) and weak business quality (margins collapsed). Moderate return potential (34% CAGR) but 100% trough downside produces an uninvestable score. Eliminated.
- CPS: Weak survival quality (negative equity, ND/EBITDA 5.2x) and weak business quality (1.6% ROIC). Moderate return potential (35% CAGR) but negative equity triggers 60% probability ceiling, and balance sheet weakness pushes probability to 50%, below the hard cap. Eliminated.

**Cluster Verdict:** No investable candidates. DORM is the highest-quality business but not a deep value opportunity at current prices. CPS and AAP have deep value characteristics but fail on survivability and floor risk.

### Margin Trend Analysis
- CPS: Gross margins IMPROVING (3.7% -> 11.7% over 5yr). Operating margins IMPROVING (-11.3% -> 3.9%). Not a permanent pass -- trend is positive.
- AAP: Gross margins STABLE at ~44%. Operating margins COLLAPSED (7.4% -> 1.9%) but early signs of inflection under new management. Not a permanent pass yet but trajectory still unclear.
- DORM: All margins IMPROVING. Gross (35.1% -> 41.1%), operating (12.2% -> 16.8%). Clear uptrend.

---

## Detailed Analysis: Fintech Cluster (PYPL)

### PYPL -- PayPal Holdings, Inc.

**Moats:** Moderate -- PayPal has strong brand recognition with 400M+ active accounts and two-sided network effects (PayPal + Venmo ecosystems). Switching costs exist for merchants deeply integrated into checkout flows. However, take rates are compressing as Stripe, Adyen, and Apple Pay commoditize payment processing. The network effect moat is weakening at the margins.

**Management:** Concerning -- Third CEO in 3 years. Enrique Lores (former HP Inc CEO) started March 1, 2026. Alex Chriss (Sept 2023 - Feb 2026) initiated the profitable growth pivot but departed after disappointing Q4 2025 results. Jamie Miller served as interim CEO for one month. The revolving door at the top creates execution uncertainty. Lores has no payments industry background.
- Rating: Concerning
- CEO tenure <1 year ceiling applied (65% max probability)

**Issues & Fixes:** Clear Plan
- Revenue growth deceleration: pivoted from growth-at-all-costs to profitable growth under Chriss; operating margin expanded from 13.9% (2022) to 19.7% (2025)
- eBay deplatforming complete: replaced eBay volume with new merchant wins and Fastlane adoption
- Venmo monetization: revenue growing 20% YoY, path to $2B annual revenue by 2027
- Competitive pressure: investing in Fastlane (51% conversion uplift for accelerated shoppers), expanding beyond branded checkout

**Compensation:** Acceptable -- Non-GAAP operating income and transaction margin dollars drive short-term incentives (redesigned 2024). Long-term incentives tied to relative TSR vs S&P 500. Replaced revenue/margin metrics with profitability focus. SBC declining (5.4% -> 3.0% of revenue).

**Catalysts:**

1. Fastlane checkout adoption -- Timeline: 2026-2027 | Impact: monetizes unbranded checkout, 51% conversion uplift, expanding to UK/Europe via JP Morgan Payments
2. Venmo monetization -- Timeline: 2026-2027 | Impact: $2B annual revenue target by 2027, Pay with Venmo expanding to major retailers, PayPal-Venmo interoperability in 2026
3. Share buyback program -- Timeline: ongoing | Impact: $6B annual pace, reducing share count from 959M toward 880M+, direct EPS accretion
4. PayPal Bank (ILC application) -- Timeline: 2026-2027 | Impact: enables direct lending to small businesses, interest-bearing deposits, new revenue streams

**Catalyst Quality Record:**

| Item | Classification | Specific? | Time-Bound? | Measurable? | Thesis-Linked? |
|------|----------------|-----------|-------------|-------------|----------------|
| Fastlane checkout adoption | VALID_CATALYST | Yes | Yes (2026-2027) | Yes (conversion rates, merchant adoption) | Yes |
| Venmo $2B revenue target | VALID_CATALYST | Yes | Yes (by 2027) | Yes ($2B target) | Yes |
| Share buyback $6B/yr | VALID_CATALYST | Yes | Yes (ongoing) | Yes (share count) | Yes |
| PayPal Bank ILC | SUPPORTING_TAILWIND | Yes | Partial (regulatory timeline uncertain) | Yes | Partial |
| CEO transition to Lores | WATCH_ONLY | Yes | No | No | No |
| German antitrust proceedings | WATCH_ONLY | Yes | No | No | No |

**Issues-And-Fixes Evidence Table:**

| Issue | Management Response | Evidence Of Action | Evidence Of Progress | Open Risk | Evidence Status |
|-------|--------------------|--------------------|---------------------|-----------|-----------------|
| Revenue growth deceleration | Pivot to profitable growth | Cost restructuring, margin focus | Op margin 13.9% -> 19.7% (2022-2025) | Take rate compression ongoing | EARLY_RESULTS_VISIBLE |
| eBay deplatforming | New merchant acquisition | Fastlane launch, Braintree expansion | TPV growing without eBay | Competitive pressure from Stripe/Adyen | PROVEN |
| Venmo losses | Venmo monetization strategy | Pay with Venmo expansion, debit card | Revenue +20% YoY, partnerships with Starbucks/DoorDash | Path to profitability not yet proven | ACTION_UNDERWAY |
| CEO instability | Board appointed Enrique Lores | New CEO started March 2026 | Too early to assess | No payments industry experience | ANNOUNCED_ONLY |
| Class-action lawsuits | Not yet addressed publicly | Lead plaintiff deadline April 2026 | N/A | Financial and reputational risk | ANNOUNCED_ONLY |

**Valuation Model:**

Valuation command: `bash scripts/calc-score.sh valuation 38 18.0 14 880`
```json
{
  "revenue_b": 38.0,
  "fcf_margin_pct": 18.0,
  "fcf_b": 6.84,
  "multiple": 14.0,
  "shares_m": 880.0,
  "target_price": 108.82
}
```

CAGR command: `bash scripts/calc-score.sh cagr 46.97 108.82 2.5`
```json
{
  "current_price": 46.97,
  "target_price": 108.82,
  "years": 2.5,
  "cagr_pct": 39.94,
  "meets_hurdle": true,
  "hurdle": 30
}
```

- Revenue: $33.3B current -> $38B by mid-2028 (~6-7% CAGR, in line with recent trend)
- FCF Margin: 16.7% current (FY2025), 21.3% (FY2024). Normalized at 18% (blending current operational improvements with competitive margin pressure)
- FCF: $38B x 18% = $6.84B
- Multiple: 14x FCF
  - Discount path: Processor baseline 18x (mid-range of 15-20x) -> take rate compression -2x -> regulatory risk (CFPB) -1x -> commoditization headwind -1x -> **14x**
- Shares: 959M current -> 880M by mid-2028 ($6B annual buyback at ~$50 avg = ~120M shares retired over 2.5yr, offset by ~40M SBC issuance)
- **Price Target: $108.82** (39.9% CAGR over 2.5 years)

**Worst Case (Trough-Anchored):**

Floor command: `bash scripts/calc-score.sh floor 21.454 14.2 10 959 46.97`
```json
{
  "revenue_b": 21.454,
  "fcf_margin_pct": 14.2,
  "fcf_b": 3.0465,
  "multiple": 10.0,
  "shares_m": 959.0,
  "current_price": 46.97,
  "floor_price": 31.77,
  "downside_pct": 32.36
}
```

- Calibration rule: `default_min_5y` -- no exceptions triggered (5yr revenue CAGR 9.2%, below 15% threshold; margin gap 2.5 ppt, below 8 ppt threshold)
- Downside normalization: mechanical downside 32.36% / scored downside 32.36%
- TBV cross-check: TBV/share $9.58 -- **TBV flag: floor $31.77 > 2x TBV/share $19.16**. PYPL is asset-light (goodwill $10.9B from acquisitions); FCF-based floor is more appropriate than TBV for processors. Flag noted, not binding.
- Adjustment: None (mechanical floor used as-is)

**Trough Path:**

| Input | Trough Value | Fiscal Year | FMP Data Point |
|-------|-------------|-------------|----------------|
| Revenue | $21.454B | FY2020 | income statement |
| FCF Margin | 14.2% | FY2023 | cashflow ($4.22B FCF) / income ($29.77B rev) |
| FCF Multiple | 10x | -- | Processor 18x minus -2x take rate, -1x regulatory, -1x commoditization, -4x additional trough discount = 10x |
| Shares | 959M | Current | FMP shares outstanding |

**Gut Check:** Implied 14x P/FCF target vs current ~8x trailing P/FCF. Historical PYPL traded at 15-35x P/FCF during 2019-2021. 14x is reasonable for a mature processor with improving margins. 10x trough is harsh but appropriate for a scenario where growth stalls and competitive pressure intensifies.

**Decision Score:**

Score command: `bash scripts/calc-score.sh score 32.36 60 39.94`
```json
{
  "downside_pct": 32.36,
  "adjusted_downside": 37.6,
  "risk_component": 28.08,
  "probability_component": 24.0,
  "return_component": 5.99,
  "total_score": 58.07
}
```

Size command: `bash scripts/calc-score.sh size 58.07 39.94 60 32.36`
```json
{
  "score": 58.07,
  "score_band": "55-64",
  "score_based_max": "6-10%",
  "hard_breakpoint_cap": null,
  "hard_breakpoint_reason": null,
  "final_max_size": "6-10%",
  "investable": true
}
```

Pre-epistemic: Score 58.07, Size 6-10%, Investable

**Probability Banding:**
```
Base rate: credit services turnaround ~80% (4 of 5 cases recovered per sector knowledge)
Precedent: PayPal 2022-present (documented in sector knowledge), AXP 1991-1995
Adjustments: Management Weak (-10% — 3rd CEO in 3yr, Lores has no payments background), Balance sheet Strong (+10% — ND/EBITDA 0.3x, $8B cash, $5.6B FCF), Market Neutral (0%)
Net: 80% - 10% + 10% + 0% = 80% -> 80% band
Ceiling check: CEO tenure <1 year (Enrique Lores started March 1, 2026) -> 65% cap
Final probability: 60% (nearest valid band at or below 65% ceiling)
```

**Epistemic Confidence:** 3/5 raw, adjusted to 1/5 after friction

| # | Question | Answer | Justification | Evidence |
|---|----------|--------|---------------|----------|
| 1 | Operational risk? | No | Dominant risk is legal (active class-action lawsuits filed Feb 2026) and competitive commoditization, not purely operational execution | Gemini search: multiple shareholder class actions, German antitrust proceedings |
| 2 | Regulatory discretion minimal? | No | CFPB expanding oversight of digital wallets; German antitrust proceedings; PayPal Bank ILC will bring banking regulation | Gemini search: CFPB Personal Financial Data Rights Rule 2026-2030; Bundeskartellamt |
| 3 | Historical precedent? | Yes | PayPal 2022-present is a documented turnaround precedent. AXP 1991-1995, COF 2008-2012 are comparable. 4 of 5 credit services turnarounds recovered. | Sector knowledge credit-services.md |
| 4 | Non-binary outcome? | Yes | Gradient outcomes: partial margin recovery, slower Venmo monetization, reduced buyback pace are plausible intermediate outcomes | FMP data: operating margin trajectory 13.9% -> 19.7% shows intermediate states |
| 5 | Macro/geo limited? | Yes | Thesis is primarily company-specific (management execution, product innovation, competitive positioning) | FMP data: revenue growing across different macro environments |

"No" count: 2 -> Raw confidence: 3/5 (multiplier x0.85)

Risk-type friction: Legal/Investigation (active class-action lawsuits) -> -2
Adjusted confidence: max(1, 3 - 2) = 1/5 (multiplier x0.50)

Effective probability: `bash scripts/calc-score.sh effective-prob 60 1`
```json
{
  "base_probability": 60.0,
  "confidence": 1,
  "multiplier": 0.5,
  "effective_probability": 30.0
}
```

**Effective probability 30% < 60% hard cap -> REJECTED**

Reason: epistemic confidence filter (base 60% x 0.50 = 30%, below 60% threshold)

**Human Judgment Flags:**
- The class-action lawsuits triggering Legal/Investigation classification are shareholder suits about disclosure timing (common after any 20% stock drop), NOT fraud investigations or existential legal threats. A human reviewer may judge these differently than a DOJ criminal probe.
- The active litigation override is the binding constraint. Without it, PYPL would still face the CEO tenure ceiling and raw confidence of 3/5 producing a 51% effective probability (also below threshold). The combination of CEO instability + class-action lawsuits creates a confidence death spiral under the methodology.
- PYPL is an existing portfolio holding at ~11-20% weight. This scan suggests the position faces significant epistemic uncertainty but does NOT trigger a sell signal under Step 8 rules (thesis is not broken, forward returns may still exceed thresholds).

**Structural Diagnosis:**
- **Role:** Watchlist (not ready for new capital per methodology, but existing position governed by Step 8 sell rules)
- **What upgrades to 70+ score?** (1) New CEO Lores demonstrates payments-specific strategic vision within first 6 months, removing the tenure ceiling; (2) class-action lawsuits settled or dismissed, removing Legal/Investigation classification; (3) operating margin reaches 22%+ with stable take rates
- **What breaks the thesis?** (1) Lores pivots strategy away from profitable growth (reversing Chriss's work); (2) Take rate compression accelerates beyond 50bps/yr; (3) Fastlane adoption stalls below 10% of eligible merchants; (4) Class-action lawsuits result in material settlement (>$1B)

**Epistemic Input:**
- **Thesis:** PayPal is a dominant digital payments processor with $33B revenue, $5.6B FCF, and improving operating margins (13.9% to 19.7% over 3 years). The turnaround thesis centers on monetizing unbranded checkout via Fastlane, Venmo monetization to $2B revenue, and $6B annual buybacks driving EPS accretion. However, the third CEO change in 3 years and active class-action lawsuits create significant execution and legal uncertainty.
- **Key Risks:**
  - CEO instability (3rd CEO in 3 years, Lores has no payments background)
  - Active class-action lawsuits (shareholder suits, lead plaintiff deadline April 2026)
  - Take rate compression from Stripe, Adyen, Apple Pay
  - CFPB regulatory expansion to digital wallets
  - German antitrust investigation
  - Venmo profitability not yet proven
- **Catalysts:**
  - Fastlane checkout adoption (2026-2027, 51% conversion uplift)
  - Venmo monetization path to $2B revenue (by 2027)
  - Share buyback program $6B/yr (ongoing)
  - PayPal Bank ILC (2026-2027, regulatory approval pending)
- **Moat Summary:** Moderate moat from brand (400M+ users), two-sided network effects (PayPal + Venmo), and merchant switching costs. However, payment processing is commoditizing, and Apple Pay represents a platform-level competitive threat.
- **Dominant Risk Type:** Legal/Investigation (active class-action lawsuits override)

---

## Rejected at Analysis

| Ticker | Failed At | Reason | Score | CAGR | Downside | Prob |
|--------|-----------|--------|-------|------|----------|------|
| DORM | CAGR hurdle | 9.7% CAGR, far below 20% minimum. High-quality business but not beaten down enough for deep value. | N/A | 9.7% | 99.2% | N/A |
| CPS | Probability hard cap | Base probability 50% (sector base 60% minus balance sheet weakness -10%), below 60% hard cap. Negative equity triggers 60% ceiling but probability already at 50%. | 2.76 | 35.1% | 100% (capped) | 50% |
| AAP | Score < 45 | Score 6.57 on 100% trough downside (negative FCF margin at trough). $7.5B debt post-Worldpac with ND/EBITDA 10x creates extreme floor risk despite 34% CAGR potential. | 6.57 | 33.8% | 100% (capped) | 60% |
| PYPL | Epistemic confidence filter | Effective probability 30% (base 60% x 0.50 multiplier). CEO tenure <1yr ceiling caps at 60%, then Legal/Investigation friction (-2) drops confidence to 1/5. | 58.07 (pre-epistemic) | 39.9% | 32.4% | 30% effective |

### Notable Details on Rejections

**DORM ($109.33):** Dorman is the best business in this scan -- 13% ROIC, 17% operating margin, 41% gross margin, low leverage (ND/EBITDA 1.6x), growing revenue at 14% CAGR. The problem is price: at $109, the stock needs to reach ~$131 for 30% CAGR, and the base case only yields 9.7% CAGR over 2 years. This is a quality compounder at fair value, not a deep value turnaround. If DORM were to fall to ~$65-70 (40% decline), it would likely score very well.

**CPS ($32.00):** Margins are improving dramatically (operating margin from -11.3% to +3.9% over 5 years). The turnaround is working operationally. However, negative equity (-$83M) and high leverage (ND/EBITDA 5.2x) create extreme floor risk. The trough-anchored worst case uses FY2021 FCF margin of -9.1%, producing a negative floor price. The probability of 50% reflects the genuine uncertainty about whether this overleveraged OEM supplier can fully recover before the EV transition erodes its addressable market. EV content wins ($298M new business in 2025) are positive but must accelerate. The existing 25% portfolio position is governed by Step 8 sell rules, not this scan.

**AAP ($50.33):** Shane O'Kelly's turnaround plan is concrete and progressing (200bps margin expansion in 2025, return to positive comps, 700 store closures completed, Worldpac sold for $1.5B). However, the debt load post-restructuring is severe ($7.5B, ND/EBITDA 10x), and the trough FCF margin of -3.5% produces a negative floor. The medium-term target of 7% operating margin by ~2028 would transform the investment case, but the methodology correctly captures the extreme downside risk during the transition. The existing 8% position is governed by Step 8 sell rules.

**PYPL ($46.97):** The most analytically interesting case. At 58.07 pre-epistemic score with 40% CAGR and only 32% downside, PYPL would be a solid buy candidate... if not for the CEO instability and legal overhang. The CEO tenure ceiling (65%, rounded to 60% band) is the first binding constraint. The class-action lawsuits trigger Legal/Investigation classification with -2 friction, dropping confidence to 1/5 and effective probability to 30%. This is the methodology working as designed: it penalizes situations where the probability estimate is unreliable. The existing 11-20% position is governed by Step 8 sell rules.

## Portfolio Impact
- Current positions: 10/12 | Available slots: 2
- All four stocks in this scan are existing holdings
- No new positions recommended -- zero candidates survived the full pipeline
- Catalyst concentration: Auto parts theme at ~33% of portfolio (CPS 25% + AAP 8%), unchanged
- Deployment recommendation: **Scenario 1 (Cash Available)** -- no new ideas passing the bar. Hold cash or compare against other opportunities outside this scan. No action on existing positions based on this scan alone.
- **Existing position implications:** This scan highlights significant methodology-consistent risk in CPS (negative equity, 50% probability) and AAP (100% trough downside, extreme leverage). Both merit careful Step 8 monitoring. PYPL faces CEO instability and legal overhang but has the strongest fundamental trajectory. DORM is the healthiest business but was never a deep value play.
- **Key concern:** The auto parts concentration (~33%) faces compounding risks: CPS has structural EV transition exposure, and AAP has extreme leverage. A comprehensive Step 8 review of both positions is recommended.

## Methodology Notes
- Qualitative assessments (moats, management, probability) are LLM estimates -- review critically
- Valuation multiples involve judgment -- verify reasoning matches your own assessment
- Catalyst timelines are estimates based on public information as of scan date
- Step 3 ranking completeness audited: cluster ranking record present, quality ordering documented, no permanent-pass margins found, no backup candidates retained (all eliminated)
- Step 4 catalyst quality audited: PYPL has 3 VALID_CATALYST items, issues-fixes evidence table with management evidence statuses. DORM/CPS/AAP not scored (eliminated at earlier steps)
- Valuation multiples verified: median multiple 14x (PYPL only scored candidate). CPS and AAP not scored. DORM eliminated on CAGR.
- All scoring math computed via calc-score.sh (deterministic, not LLM-generated)
- Epistemic confidence assessed independently -- reviewer never sees analyst probability or score
- PCS answers are evidence-anchored -- each answer cites Gemini search results, FMP data, or sector knowledge
- Risk-type friction applied: PYPL Legal/Investigation -> -2 (active class-action lawsuits override)
- CEO tenure <1 year ceiling applied to PYPL (Enrique Lores started March 1, 2026) -> 65% cap -> 60% band
- Threshold proximity warning: PYPL base probability 60% is AT the 60% hard cap -- borderline case heavily dependent on epistemic confidence
- Downside compliance audited: PYPL floor calc present, no Heroic Optimism flags, TBV cross-check complete (flag noted for asset-light business), trough path verified, calibration rules compliant (default_min_5y)
- CPS and AAP floor calcs produced negative floor prices -> downside capped at 100% for scoring
- Phase 1 screening was skipped (user-specified tickers) -- no Step 2 verification data available
- **Important:** This scan evaluates NEW CAPITAL allocation. Existing positions are governed by Step 8 sell rules, not scan-time scoring. A stock failing this scan does NOT trigger a sell.

---
*Scan completed 2026-03-07 using EdenFinTech deep value turnaround methodology*
