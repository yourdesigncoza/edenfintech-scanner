---
sector: Financials
industry_group: Banks
industry: Diversified Banks
fmp_industry: "Banks - Diversified"
hydrated: 2026-03-07
version: 1
epistemic_stability: 3
suggested_pcs_friction: -1
typical_valuation: "P/TBV + P/E"
fcf_multiple_baseline: "N/A -- FCF multiples do not apply to banks"
---

# Diversified Banks

## Overview

Diversified banks are large financial institutions that operate across multiple business lines: retail banking (deposits, consumer loans, mortgages), commercial/corporate banking (business lending, treasury services), investment banking (advisory, underwriting), trading, wealth management, and sometimes insurance. Revenue comes primarily from net interest income (NII -- the spread between lending rates and deposit costs, typically 50-60% of revenue) and non-interest income (trading, advisory fees, wealth management, 40-50%).

These institutions are heavily regulated, capital-intensive, and operate with significant leverage (assets/equity ratios of 10-12x). They are required to maintain minimum capital ratios (CET1 >4.5% regulatory minimum, but practically >10% to pass stress tests) and submit to Federal Reserve stress testing (CCAR/DFAST) annually. The "too big to fail" designation (GSIB surcharge) adds an extra capital buffer requirement.

Competitive dynamics favor scale: the top 4 US banks (JPM, BAC, WFC, C) hold ~40% of US deposits. Network effects exist in payments (JPM processes $10T+ annually) and wealth management (scale enables lower fees). Barriers to entry are extreme due to regulatory requirements, capital needs, and the difficulty of building deposit franchises.

## Key Metrics & KPIs

| Metric | What It Measures | Healthy Range | Red Flag |
|--------|-----------------|---------------|----------|
| CET1 Ratio | Core equity capital adequacy | >10% (>12% for GSIB) | <8% triggers regulatory action |
| Net Interest Margin (NIM) | Spread on earning assets | 2.5-3.5% | <2.0% signals margin compression |
| Return on Tangible Equity (ROTCE) | Profitability on tangible capital | 12-18% | <10% suggests P/TBV should be <1.0x |
| Efficiency Ratio | Non-interest expense / revenue | 55-65% | >70% signals cost bloat |
| Net Charge-Off Rate (NCO) | Annual credit losses / avg loans | 0.3-0.8% | >1.5% signals portfolio stress |
| Non-Performing Loans (NPL) | Impaired loans / total loans | <1% | >3% is elevated; >5% is crisis |
| Loan Loss Reserve / NPL | Coverage ratio for bad loans | >100% | <80% suggests under-reserving |
| Deposit Cost | Average rate paid on deposits | Varies with rates | Rising faster than loan yields |
| Tier 1 Leverage Ratio | Tier 1 capital / total assets | >5% | <4% triggers regulatory concern |
| Non-Interest Income % | Revenue diversification | 35-50% | <25% signals rate dependency |
| Loan-to-Deposit Ratio | Balance sheet funding stability | 70-90% | >100% signals funding stress |
| Tangible Book Value Growth | Equity compounding | 5-10% CAGR | Declining TBV is value destruction |
| PPNR (Pre-Provision Net Revenue) | Earnings power before credit costs | Growing | Declining signals operational weakness |
| Common Dividend Payout Ratio | Capital return sustainability | 30-50% | >70% may constrain capital build |

## Valuation Approach

- **Primary method:** P/TBV (Price to Tangible Book Value) -- the standard bank valuation metric. Premium banks (JPM) trade 1.5-2.5x P/TBV; average banks 1.0-1.5x; distressed banks <1.0x.
- **Secondary method:** P/E and P/PPNR -- earnings-based multiples. Large banks typically trade 9-16x P/E.
- **Why NOT FCF multiples:** Banks' operations and financing are intertwined (deposits are both liabilities and raw materials). Loan originations are operating activities, not capex. Regulatory capital requirements constrain distributable cash. FCF is volatile and misleading for banks.
- **Typical multiple range:**
  - JPM: 1.5-2.5x P/TBV, 10-16x P/E (franchise premium)
  - BAC: 1.0-1.8x P/TBV, 9-14x P/E
  - WFC: 1.0-1.6x P/TBV, 9-13x P/E (asset cap discount)
  - C: 0.8-1.3x P/TBV, 8-12x P/E (restructuring discount)
- **Common pitfalls:**
  - Applying FCF multiples to banks -- structurally invalid
  - Ignoring CET1 constraints when estimating upside
  - Assuming P/TBV <1.0x automatically means "cheap" -- may reflect poor ROTCE
  - US banking sector median P/TBV was ~1.39x as of Feb 2026

### EdenFinTech FCF Multiple Baseline

**FCF model does NOT apply to diversified banks.** Analysts must use P/TBV and P/E instead. The 4-input model (Revenue x FCF Margin x Multiple / Shares) produces meaningless results for banks because bank "revenue" includes provision expense, "FCF margin" is not a meaningful concept, and banks are valued on equity, not enterprise value.

For scan compatibility, if the screener passes a bank through, the analyst should: (1) use PPNR as the "revenue equivalent," (2) apply a P/PPNR multiple of 4-6x as the "valuation input," and (3) note the methodology override clearly.

## Turnaround Precedents

| Company | Period | Situation | Actions Taken | Outcome | Timeline | Stock Recovery |
|---------|--------|-----------|--------------|---------|----------|----------------|
| Citigroup | 2008-2013 | Insolvent Nov 2008, stock <$1, losing $8-11M/day, $45B TARP + $306B asset guarantee, 75,000 job cuts | Govt took 36% equity stake, split into Citicorp + Citi Holdings, restricted dividends | Full recovery. Treasury recouped $12B profit by Jan 2011 | ~5 years | Stock from <$1 (2009) to $50+ by 2014 (adj for 1:10 reverse split) |
| Bank of America | 2008-2014 | $45B TARP, Merrill Lynch acquisition ($15.3B Q4 loss), SEC charges, $16.65B DOJ settlement, stock -63% in 2008 | Repaid TARP Dec 2009, de-risked balance sheet, $76.1B in total legal settlements | Full recovery | ~6 years | Stock from ~$3 (2009) to $17 by 2014 |
| Wells Fargo | 2016-present | Fake accounts scandal (3.5M unauthorized accounts), $3B DOJ/SEC settlement, Fed asset cap imposed Feb 2018, serial consent orders | CEO replacements (Stumpf -> Sloan -> Scharf), operational overhaul, still under asset cap as of 2026 | Partial recovery -- operational improvement under Scharf but asset cap remains | 8+ years (ongoing) | Stock from $44 (2018) to $80 (2026), but underperformed peers |

**Pattern:** Diversified bank turnarounds require 4-6+ years and massive capital/legal remediation. Government intervention (TARP) was necessary in 2008-2009 cases. Regulatory consent orders can last a decade (WFC). 2 of 3 achieved full recoveries; WFC is partial/ongoing. Base rate: ~67-75% recovery over 5+ year horizons, but the timeline is long and the path is painful. Analyst should anchor base probability at 60% for distressed diversified banks given the complexity and regulatory overlay.

## Risk Profile

- **Default risk type:** Financial / Regulatory (dual risk -- credit losses AND regulatory enforcement)
- **Cyclicality:** High -- NIM compresses in low-rate environments; credit losses spike in recessions
- **Regulatory discretion:** High -- Fed, OCC, FDIC, CFPB all have supervisory authority; stress test results can force capital plan changes; consent orders can restrict business activities for years
- **Macro sensitivity:**
  - Interest rates: HIGH (direct NIM impact; +100bps can add $2-4B in NII for large banks)
  - Credit cycle: HIGH (provision expense swings dramatically)
  - Unemployment: HIGH (drives consumer and commercial loan losses)
  - Yield curve: HIGH (inverted curve compresses NIM)
  - Housing market: MODERATE-HIGH (mortgage exposure)
- **Binary trigger frequency:** Occasional -- bank runs (SVB 2023), regulatory seizure rare for large banks post-Dodd-Frank

### Kill Factors (hard reject -- maps to enrichment override triggers)

1. **CET1 <6% with no credible recapitalization plan** -- Below regulatory minimums with no path to compliance means dividend suspension, asset sales, or dilutive equity raise. Historical: Citigroup 2008 required government equity injection.
2. **Active FDIC receivership or bank run** -- Once deposit flight begins, the timeline to failure is days, not months. Historical: SVB collapsed in 48 hours (March 2023).
3. **Criminal fraud charges against institution** -- Not individuals, but institutional fraud findings. Would destroy franchise value. Historical: Wirecard (non-US example).
4. **Regulatory prohibition on core business activity** -- If the Fed or OCC bars a bank from a major business line (not just an asset cap). Would fundamentally impair earning power.

### Friction Factors (PCS modifiers -- reduce confidence, don't kill thesis)

1. **Fed asset cap** -- suggested friction: -1, rationale: constrains revenue growth but bank can still improve profitability. WFC has operated under asset cap since 2018 and stock has still appreciated.
2. **Multiple active consent orders** -- suggested friction: -1 to -2, rationale: signals systemic operational/compliance issues. Citigroup has had overlapping consent orders since 2020; $75M OCC fine in 2024 for slow remediation.
3. **NPL ratio 2-5%** -- suggested friction: -1, rationale: elevated but not crisis level. Requires close monitoring of trend direction.
4. **Inverted yield curve** -- suggested friction: -1, rationale: temporary NIM pressure but historically mean-reverts within 12-18 months.

## Thesis-Breaking Patterns

- **Failure mode 1: Credit cycle blowup** -- Concentrated exposure to deteriorating loan category (CRE, subprime, leveraged lending) causes provision spike that wipes out earnings. Gradual then sudden. Examples: BAC/Merrill 2008, Citigroup CDO losses 2007-2008.
- **Failure mode 2: Regulatory death spiral** -- Cascading consent orders that restrict business activities, force divestitures, and erode franchise value. Gradual over years. Examples: WFC post-2016 (ongoing), Deutsche Bank 2014-2019.
- **Failure mode 3: Bank run / liquidity crisis** -- Deposit flight triggered by credit concerns or social media panic. Binary (days). Examples: SVB 2023, Continental Illinois 1984.
- **Failure mode 4: Trading blowup** -- Outsized proprietary trading loss or counterparty failure. Binary. Examples: JPM "London Whale" $6.2B loss 2012 (survivable), Lehman Brothers 2008 (fatal).

## Evidence Requirements

### Must-Have Data Points

| Data Point | Where to Find It | Why It Matters |
|-----------|-----------------|----------------|
| CET1 Ratio | 10-K Item 8 (Capital section), FMP Key Metrics, Fed Y-9C filings | Regulatory floor; below 8% is danger zone |
| Net Interest Margin (NIM) | 10-K, FMP ratios, earnings releases | Primary earnings driver; trend matters more than level |
| NPL Ratio | 10-K Item 7 (Credit Quality), FDIC Call Reports | Direct measure of loan book health |
| Provision for Credit Losses | FMP income statement, 10-Q | Forward-looking indicator of expected credit deterioration |
| ROTCE | Earnings releases, calculate from FMP data (net income / avg tangible equity) | Links to P/TBV; ROTCE > cost of equity justifies P/TBV > 1.0x |
| Efficiency Ratio | Earnings releases, FMP income statement | Operational efficiency; >70% is problematic |
| Tangible Book Value per Share | FMP balance sheet, calculate (equity - goodwill - intangibles) / shares | Core valuation anchor |
| Stress Test Results (CCAR) | Federal Reserve website (annual, published June) | Reveals downside capital adequacy under adverse scenarios |
| Consent Orders / MRAs | FDIC, OCC, Fed enforcement action databases | Material regulatory overhang |
| Net Interest Income Sensitivity | 10-K Item 7A, earnings call transcripts | How much NII changes with rate moves |

### Red Flags If Missing

- If a bank does not disclose CRE concentration by property type, analyst cannot assess concentrated risk
- If stress test results show CET1 falling below 4.5% in severely adverse scenario, thesis is materially weakened
- If consent order details are sealed, assume worst case for friction assessment

## Epistemic Profile

| PCS Question | Typical Answer | Rationale |
|-------------|---------------|-----------|
| Q1: Operational risk? | No | Risk is primarily credit cycle + regulatory, not operational execution |
| Q2: Regulatory minimal? | No | Fed, OCC, FDIC, CFPB all have discretionary supervisory authority; stress tests add uncertainty |
| Q3: Historical precedent? | Yes | Strong precedent base: C, BAC, WFC turnarounds are well-documented |
| Q4: Non-binary outcome? | Mostly Yes | Gradient outcomes for large banks (too big to fail provides floor); but pre-TBTF banks faced binary risk |
| Q5: Macro/geo limited? | No | Heavily exposed to rates, credit cycle, and domestic macro |

**Epistemic stability:** 3/5 -- Diversified banks have extensive disclosure and regulatory oversight, but credit cycle uncertainty and regulatory discretion reduce predictability. The "too big to fail" backstop improves outcomes but introduces moral hazard complexity.

**Suggested PCS friction:** -1 -- Regulatory discretion is high (stress tests, consent orders, asset caps), and credit cycle exposure introduces macro dependency. For banks under active consent orders, -2 is appropriate.

```json
{
  "sector": "Financials",
  "sub_sector": "Diversified Banks",
  "cyclicality": "high",
  "regulatory_discretion": "high",
  "binary_risk_level": "moderate",
  "macro_dependency": "high",
  "precedent_strength": "strong",
  "typical_valuation_method": "P/TBV",
  "fcf_multiple_baseline": "N/A",
  "epistemic_stability_score": 3,
  "suggested_pcs_friction": -1,
  "suggested_position_cap": "none"
}
```
