---
sector: Financials
industry_group: Consumer Finance
industry: Thrifts & Mortgage Finance
fmp_industry: "Financial - Mortgages"
hydrated: 2026-03-07
version: 1
epistemic_stability: 2
suggested_pcs_friction: -1
typical_valuation: "P/E + P/BV"
fcf_multiple_baseline: "8-14x (highly cyclical)"
---

# Mortgage Finance

## Overview

Mortgage finance companies originate, service, and securitize residential mortgage loans. Revenue comes from gain-on-sale margins (spread on originating and selling loans), servicing fees (25-40bps annually on serviced portfolio), and net interest income on retained loans. Key players: Rocket Companies (RKT), United Wholesale Mortgage (UWM), PennyMac Financial (PFSI), loanDepot (LDI).

Business model is extremely cyclical: origination volumes swing 50-70% based on mortgage rates (volumes surged in 2020-2021 at sub-3% rates, collapsed 2022-2023 at 7%+ rates). Gain-on-sale margins compress when volumes drop due to fixed cost leverage and competition. Servicing income provides a partial hedge (servicing values rise when rates rise), but the offset is imperfect.

Capital intensity is moderate (warehouse lending lines required). Regulatory oversight comes from CFPB (mortgage lending rules, QM standards), Fannie Mae/Freddie Mac (GSE eligibility requirements), and state regulators. The sector is heavily dependent on housing market health and government policy (GSE conservatorship, FHA/VA programs).

## Key Metrics & KPIs

| Metric | What It Measures | Healthy Range | Red Flag |
|--------|-----------------|---------------|----------|
| Origination Volume | Business activity level | Varies with rates | Down >40% YoY signals distress |
| Gain-on-Sale Margin | Origination profitability | 1.5-3.0% | <1.0% signals commodity competition |
| Servicing Portfolio Size | Recurring revenue base | Growing | Declining (indicates MSR sales for liquidity) |
| MSR Fair Value / Equity | Asset concentration | <150% | >200% signals concentrated MSR risk |
| Delinquency Rate (30+ days) | Servicing portfolio credit quality | <3% | >5% signals stress |
| Operating Margin | Overall profitability | 15-30% (normal rates) | Negative in rate spikes |
| Market Share | Competitive position | Stable/growing | Declining signals competitive weakness |
| Recapture Rate | Refinance retention | 50-70% | <30% signals weak customer relationships |
| Warehouse Capacity Utilization | Liquidity headroom | 40-70% | >90% signals liquidity constraint |
| Tangible Book Value per Share | Equity floor | Stable/growing | Declining (MSR impairments or losses) |

## Valuation Approach

- **Primary:** P/E (8-14x normalized earnings) and P/BV (0.8-2.0x)
- **Why semi-applicable FCF:** Mortgage companies can use FCF model, but earnings are so cyclical that "normalized" assumptions are critical. Use through-the-cycle average earnings or servicing-only earnings as floor.
- **Common pitfalls:** Valuing at peak earnings multiples (2020-2021 origination boom was anomalous); ignoring MSR valuation sensitivity to rate assumptions.

### EdenFinTech FCF Multiple Baseline

8-12x normalized FCF. Apply heavy cyclical discount per valuation-guidelines.md (-3x to -5x from any starting point if in origination downturn).

## Turnaround Precedents

| Company | Period | Situation | Actions Taken | Outcome | Timeline | Stock Recovery |
|---------|--------|-----------|--------------|---------|----------|----------------|
| loanDepot | 2022-2024 | Revenue -65% from peak, operating losses >$500M cumulative, stock -90% from IPO | Headcount cuts 50%+, cost restructuring, focus on servicing, Vision 2025 plan | Partial -- still unprofitable, survival uncertain | Ongoing | Stock from $30 IPO to ~$2 |
| PennyMac | 2018-2020 | Margin compression in 2018 rising rate environment | Expanded servicing portfolio, diversified into correspondent lending | Full recovery when rates dropped | ~2 years | Stock doubled by 2020 |
| Countrywide Financial | 2007-2008 | Subprime collapse, liquidity crisis, stock -90% | Attempted to raise capital, failed | Acquired by Bank of America for $4B (2008). Shareholders lost ~95% | Fatal | Near-total loss |

**Pattern:** Mortgage finance turnarounds depend entirely on rate cycle. If rates normalize, survivors recover. If the company was the source of credit problems (Countrywide), recovery is impossible. 1 of 3 achieved full recovery; 1 ongoing; 1 fatal. Base rate: ~50%, heavily rate-dependent.

## Risk Profile

- **Default risk type:** Cyclical / Macro
- **Cyclicality:** Extreme -- the most cyclical sub-sector in Financial Services
- **Regulatory discretion:** Moderate (CFPB, GSE requirements)
- **Binary trigger frequency:** Occasional -- liquidity crises during rate spikes can force distressed sales

### Kill Factors

1. **Warehouse line termination** -- Without warehouse funding, originations stop immediately. Binary.
2. **GSE eligibility revocation** -- Cannot sell conforming loans; business model breaks.
3. **Fraud/misrepresentation in originations** -- Triggers buyback demands that can exceed equity. Example: Countrywide.

### Friction Factors

1. **Mortgage rates >7%** -- friction: -1, rationale: severely depresses origination volumes and margins.
2. **MSR concentration >200% of equity** -- friction: -1, rationale: interest rate sensitivity amplifies equity volatility.

## Epistemic Profile

**Epistemic stability:** 2/5 -- Extreme rate sensitivity makes earnings nearly unpredictable year-to-year. Thesis depends heavily on rate forecast, which is inherently uncertain.
**Suggested PCS friction:** -1 -- Macro/cyclical dependency is the dominant risk, and it is hard to model with confidence.

```json
{
  "sector": "Financials",
  "sub_sector": "Mortgage Finance",
  "cyclicality": "extreme",
  "regulatory_discretion": "moderate",
  "binary_risk_level": "moderate",
  "macro_dependency": "high",
  "precedent_strength": "weak",
  "typical_valuation_method": "P/E (normalized)",
  "fcf_multiple_baseline": "8-12x",
  "epistemic_stability_score": 2,
  "suggested_pcs_friction": -1,
  "suggested_position_cap": "8%"
}
```
