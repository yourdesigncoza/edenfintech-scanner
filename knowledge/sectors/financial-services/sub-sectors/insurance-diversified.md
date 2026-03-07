---
sector: Financials
industry_group: Insurance
industry: Multi-line Insurance
fmp_industry: "Insurance - Diversified"
hydrated: 2026-03-07
version: 1
epistemic_stability: 3
suggested_pcs_friction: 0
typical_valuation: "P/BV + P/E"
fcf_multiple_baseline: "10-15x"
---

# Insurance - Diversified

## Overview

Diversified (multi-line) insurance companies operate across multiple insurance segments: property & casualty, life, health, and/or reinsurance. Key players include Berkshire Hathaway, AIG, and Allianz. Revenue comes from underwriting profit (premiums collected minus claims paid, measured by combined ratio) and investment income (float invested in bonds, equities, alternatives).

The business model is capital-intensive and heavily regulated at the state level (NAIC standards, risk-based capital requirements). Competitive advantages come from underwriting discipline, investment management capability, and scale (reinsurance purchasing power). Barriers to entry include regulatory licensing, capital requirements, and the difficulty of building actuarial expertise.

## Key Metrics & KPIs

| Metric | What It Measures | Healthy Range | Red Flag |
|--------|-----------------|---------------|----------|
| Combined Ratio | Underwriting profitability | <100% (profit) | >105% sustained signals poor underwriting |
| Investment Income Yield | Portfolio return | 3-5% | <2% signals conservative positioning or losses |
| Book Value per Share Growth | Equity compounding | 5-10% CAGR | Declining BV signals value destruction |
| ROE | Overall profitability | 10-15% | <8% |
| Reserve Development | Prior-year reserve adequacy | Favorable or neutral | Adverse development >3% of reserves |
| Premium Growth | Revenue trajectory | 3-8% | Negative (shrinking book) |
| Risk-Based Capital Ratio | Regulatory solvency | >300% company action level | <200% triggers regulatory action |
| Float Growth | Investment base | Growing | Shrinking signals underwriting contraction |
| Net Investment Income | Earnings stability | Growing | Declining (signals portfolio issues) |
| Loss Ratio | Claims as % of premiums | 55-70% | >75% sustained |

## Valuation Approach

- **Primary:** P/BV (1.0-2.0x for quality; <1.0x for distressed) and P/E (10-14x)
- **FCF applicability:** Partially applicable. Insurance "FCF" can be approximated by operating earnings minus required capital build. Use 10-15x normalized earnings.
- **Common pitfalls:** Ignoring reserve adequacy (under-reserving inflates current earnings); confusing float growth with profitability.

## Turnaround Precedents

| Company | Period | Situation | Actions Taken | Outcome | Timeline | Stock Recovery |
|---------|--------|-----------|--------------|---------|----------|----------------|
| AIG | 2008-2018 | $185B government bailout, CDS portfolio losses, stock -97%, government took 92% equity stake | Sold non-core businesses (AIA, ILFC), repaid government $182.3B (profit for taxpayers), restructured around core P&C and Life | Full recovery of operations; stock recovered modestly | ~10 years | Stock from $7 (adj) to $60+ by 2018, but far below pre-crisis levels |
| Hartford Financial | 2008-2013 | $3.4B TARP, significant investment losses, variable annuity hedging failures | Exited life insurance/annuities entirely, became pure P&C company | Successful transformation | ~5 years | Stock from $5 to $30+ by 2013 |

**Pattern:** Diversified insurance turnarounds involve simplification -- shedding non-core or toxic business lines to focus on core underwriting competency. AIG took a decade. 2 of 2 cases recovered, but AIG's stock never returned to pre-crisis levels. Base rate: ~70%, but timeline is long (5-10 years).

## Risk Profile

- **Default risk type:** Operational (underwriting) + Financial (investment portfolio)
- **Cyclicality:** Moderate (P&C has hard/soft market cycles; investment income rate-dependent)
- **Regulatory discretion:** Moderate (state-based regulation, NAIC, Federal Insurance Office has monitoring role only)
- **Binary trigger frequency:** Rare for large diversified insurers

### Kill Factors

1. **Reserve deficiency >20% of equity** -- Signals systematic under-reserving; erosion of capital.
2. **Catastrophe concentration exceeding reinsurance capacity** -- Single event loss that breaches capital.
3. **Derivative/structured product exposure (AIG-style)** -- Non-insurance financial products creating tail risk.

### Friction Factors

1. **Combined ratio >105% for 2+ years** -- friction: -1, rationale: signals underwriting discipline breakdown.
2. **Adverse reserve development** -- friction: -1, rationale: indicates past earnings were overstated.

## Epistemic Profile

**Epistemic stability:** 3/5 -- Underwriting results are moderately predictable for disciplined insurers; investment portfolio adds rate sensitivity.
**Suggested PCS friction:** 0 -- Risk is primarily operational (underwriting discipline).

```json
{
  "sector": "Financials",
  "sub_sector": "Insurance - Diversified",
  "cyclicality": "moderate",
  "regulatory_discretion": "moderate",
  "binary_risk_level": "low",
  "macro_dependency": "moderate",
  "precedent_strength": "moderate",
  "typical_valuation_method": "P/BV",
  "fcf_multiple_baseline": "10-15x",
  "epistemic_stability_score": 3,
  "suggested_pcs_friction": 0,
  "suggested_position_cap": "none"
}
```
