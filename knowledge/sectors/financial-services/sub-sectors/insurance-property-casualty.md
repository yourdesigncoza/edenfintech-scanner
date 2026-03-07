---
sector: Financials
industry_group: Insurance
industry: Property & Casualty Insurance
fmp_industry: "Insurance - Property & Casualty"
hydrated: 2026-03-07
version: 1
epistemic_stability: 3
suggested_pcs_friction: 0
typical_valuation: "P/BV + Combined Ratio"
fcf_multiple_baseline: "10-15x"
---

# Insurance - Property & Casualty

## Overview

Property and casualty (P&C) insurance companies provide coverage for property damage (homeowners, commercial property), liability, auto, workers compensation, and specialty lines. Key players: Chubb, Progressive, Travelers, Allstate, Hartford Financial. Revenue = net earned premiums + investment income. Profitability is measured by combined ratio (loss ratio + expense ratio): below 100% indicates underwriting profit.

P&C operates in hard/soft market cycles (5-8 year duration): soft markets see premium rate declines and competitive pressure; hard markets follow catastrophe losses or capacity withdrawal, enabling rate increases. The industry requires significant capital (reserves for claims) and is regulated at the state level (rate filing, surplus requirements, claims handling standards).

Key dynamics: climate change is increasing catastrophe losses and reshaping risk models; reinsurance costs are rising; auto insurance has seen elevated claims severity from inflation and repair costs.

## Key Metrics & KPIs

| Metric | What It Measures | Healthy Range | Red Flag |
|--------|-----------------|---------------|----------|
| Combined Ratio | Underwriting profitability | 90-100% | >105% sustained |
| Loss Ratio | Claims as % of premiums | 55-70% | >75% |
| Expense Ratio | Operating efficiency | 25-35% | >40% |
| Net Premium Written Growth | Revenue trajectory | 5-10% | Negative signals market share loss |
| Reserve Development | Prior-year reserve accuracy | Favorable or flat | Adverse >3% of reserves |
| Catastrophe Loss Ratio | Event risk exposure | <5% of premium (normal year) | >15% in single year |
| ROE | Profitability | 10-15% | <8% |
| Book Value per Share Growth | Equity compounding | 5-10% | Declining |
| Investment Income Yield | Portfolio return | 3-5% | <2.5% |
| Retention Ratio | Policy renewals | >85% | <80% |

## Valuation Approach

- **Primary:** P/BV (1.0-2.0x for quality underwriters like CB, PGR) and combined ratio analysis. P/E (10-15x).
- **FCF applicability:** Partially applicable -- use 10-15x operating earnings. Insurance "FCF" is complex due to reserve movements.
- **Common pitfalls:** Ignoring catastrophe exposure when valuing at peak-cycle multiples; confusing reserve releases with sustainable earnings.

## Turnaround Precedents

| Company | Period | Situation | Actions Taken | Outcome | Timeline | Stock Recovery |
|---------|--------|-----------|--------------|---------|----------|----------------|
| AIG (P&C segment) | 2005-2010 | Accounting scandal (2005), $1.6B SEC settlement, loss of AAA rating, GFC investment losses | Bid-rigging settlement, management overhaul, balance sheet de-risking | Full recovery of P&C operations | ~5 years | P&C franchise preserved through restructuring |
| Allstate | 2010-2014 | Elevated catastrophe losses, homeowners combined ratio >120%, strategic review | Exited unprofitable geographies, raised rates, improved cat risk management | Full recovery | ~4 years | Stock from $25 to $70 |
| Reliance Insurance | 2001 | Reserve deficiency, insolvency | Failed | Liquidated by Pennsylvania Insurance Dept | Fatal | Total loss |

**Pattern:** P&C turnarounds involve underwriting discipline restoration: rate increases, exiting unprofitable lines/geographies, improving catastrophe risk management. 2 of 3 recovered. The Reliance failure involved systemic under-reserving that masked insolvency. Base rate: ~67%.

## Risk Profile

- **Default risk type:** Operational (underwriting discipline) + Catastrophe
- **Cyclicality:** Moderate (hard/soft cycle, but investment income stabilizes)
- **Regulatory discretion:** Moderate (state rate filing, surplus requirements)
- **Binary trigger frequency:** Rare -- catastrophe losses can be large but reinsurance provides buffer

### Kill Factors

1. **Reserve deficiency >25% of equity** -- Signals systemic under-reserving. Example: Reliance Insurance 2001.
2. **Single catastrophe loss exceeding reinsurance capacity + surplus** -- Immediate solvency threat.

### Friction Factors

1. **Combined ratio >105% for 2+ years** -- friction: -1, rationale: indicates poor underwriting discipline or adverse mix.
2. **Elevated catastrophe exposure in coastal/wildfire zones** -- friction: -1, rationale: climate risk increasing frequency and severity.

## Epistemic Profile

**Epistemic stability:** 3/5 -- Underwriting results are moderately predictable; catastrophe risk introduces tail uncertainty.
**Suggested PCS friction:** 0 -- Risk is primarily operational (underwriting), well within modelable range.

```json
{
  "sector": "Financials",
  "sub_sector": "Insurance - Property & Casualty",
  "cyclicality": "moderate",
  "regulatory_discretion": "moderate",
  "binary_risk_level": "low",
  "macro_dependency": "low",
  "precedent_strength": "moderate",
  "typical_valuation_method": "P/BV + Combined Ratio",
  "fcf_multiple_baseline": "10-15x",
  "epistemic_stability_score": 3,
  "suggested_pcs_friction": 0,
  "suggested_position_cap": "none"
}
```
