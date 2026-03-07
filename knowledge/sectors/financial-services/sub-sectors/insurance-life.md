---
sector: Financials
industry_group: Insurance
industry: Life & Health Insurance
fmp_industry: "Insurance - Life"
hydrated: 2026-03-07
version: 1
epistemic_stability: 3
suggested_pcs_friction: -1
typical_valuation: "P/BV + Embedded Value + P/E"
fcf_multiple_baseline: "8-12x"
---

# Insurance - Life

## Overview

Life insurance companies provide life, annuity, disability, and supplemental health products. Revenue comes from premium income, investment income on reserves, and fee income from variable annuities/asset management. Key players: Aflac (supplemental), MetLife, Prudential Financial, Principal Financial, Lincoln National.

The business model is capital-intensive with very long-duration liabilities (policies can span decades). Profitability depends heavily on investment income (life insurers are among the largest fixed-income investors) and actuarial accuracy (mortality/morbidity assumptions). Interest rate sensitivity is extreme: low rates compress investment income and inflate reserve liabilities (lower discount rates -> higher present value of future claims).

Post-2008, many life insurers have de-risked by exiting variable annuities with guaranteed benefits, which had created outsized balance sheet risk. The sector has seen significant M&A as scale enables cost sharing and investment diversification.

## Key Metrics & KPIs

| Metric | What It Measures | Healthy Range | Red Flag |
|--------|-----------------|---------------|----------|
| ROE | Profitability | 10-15% | <8% |
| Book Value per Share Growth | Equity compounding | 5-8% CAGR | Declining |
| RBC Ratio (Risk-Based Capital) | Regulatory solvency | >300% | <200% triggers regulatory action |
| Investment Portfolio Yield | Income on reserves | 3.5-5.0% | <3% in prolonged low-rate environment |
| Credit Losses on Portfolio | Investment risk | <0.1% of portfolio | >0.5% signals concentrated risk |
| Premium Growth | Revenue trajectory | 2-5% | Negative for 2+ years |
| Surrender Rate | Policy retention | <5% annually | >10% signals customer dissatisfaction |
| Variable Annuity Guarantee Exposure | Tail risk | Declining/managed | Growing guarantees in volatile markets |
| Adjusted Operating Earnings | Core profitability | Growing | Declining 3+ years |
| Debt/Capital | Leverage | <30% | >40% |

## Valuation Approach

- **Primary:** P/BV (0.5-1.5x) and P/E (7-12x) for traditional life. Embedded value analysis for more sophisticated assessment.
- **Why complex:** Life insurer "earnings" are sensitive to actuarial assumptions, reserve releases, and investment portfolio marks. GAAP earnings can be misleading.
- **FCF applicability:** Limited -- capital requirements constrain distributable cash. Use 8-12x operating earnings as proxy.
- **Common pitfalls:** Ignoring unrealized losses on bond portfolios (similar to SVB issue); applying pre-rate-hike multiples.

## Turnaround Precedents

| Company | Period | Situation | Actions Taken | Outcome | Timeline | Stock Recovery |
|---------|--------|-----------|--------------|---------|----------|----------------|
| MetLife | 2008-2013 | Stock -70%, variable annuity losses, $3.4B AIG-related exposure fears | Exited banking (no longer TBTF), de-risked VA book, cost restructuring | Full recovery | ~5 years | Stock from $12 to $50+ |
| Hartford Financial | 2008-2013 | $3.4B TARP, VA hedging failures, near-insolvency | Exited life insurance entirely, became P&C-only | Successful transformation | ~5 years | Stock from $5 to $30+ |
| Lincoln National | 2008-2012 | Stock -90%, $950M TARP, VA exposure concerns | Improved hedging, diversified into retirement plan services, repaid TARP | Full recovery | ~4 years | Stock from $5 to $28 by 2013 |
| Conseco | 1997-2002 | Overleveraged from Green Tree Financial acquisition, $6.5B in long-term care losses | Attempted restructuring, failed | Chapter 11 bankruptcy (Dec 2002) | Fatal | Stock went to $0 |

**Pattern:** Life insurance turnarounds hinge on de-risking the balance sheet (exiting VA guarantees, reducing leverage). 3 of 4 cases recovered; the failure (Conseco) involved overleveraged acquisition of a structurally flawed business. Base rate: ~75% when distress is rate/market-driven; lower when leverage + structural product issues combine.

## Risk Profile

- **Default risk type:** Financial (investment portfolio + long-duration liabilities)
- **Cyclicality:** High (interest rate sensitivity is the dominant factor)
- **Regulatory discretion:** Moderate (state guaranty associations, NAIC)
- **Binary trigger frequency:** Rare -- state guaranty funds provide backstop; main risk is VA guarantee blow-ups

### Kill Factors

1. **RBC ratio <150%** -- Triggers regulatory control level; company loses ability to write new business.
2. **Portfolio credit losses >2% in a year** -- Indicates concentrated/mismanaged investment portfolio. Example: Executive Life 1991 (junk bond portfolio collapsed).
3. **Long-term care reserve deficiency** -- LTC reserves are notoriously under-estimated; large deficiency can be fatal. Example: Genworth, Conseco.

### Friction Factors

1. **Variable annuity guarantee exposure >50% of equity** -- friction: -1, rationale: tail risk in equity market decline.
2. **Prolonged low interest rate environment** -- friction: -1, rationale: compresses investment income and inflates reserve liabilities.

## Epistemic Profile

**Epistemic stability:** 3/5 -- Long-duration liabilities create inherent uncertainty. Investment portfolio health is assessable but actuarial assumptions are opaque.
**Suggested PCS friction:** -1 -- Interest rate dependency and long-duration liability uncertainty make outcomes harder to model.

```json
{
  "sector": "Financials",
  "sub_sector": "Insurance - Life",
  "cyclicality": "high",
  "regulatory_discretion": "moderate",
  "binary_risk_level": "moderate",
  "macro_dependency": "high",
  "precedent_strength": "strong",
  "typical_valuation_method": "P/BV + Embedded Value",
  "fcf_multiple_baseline": "8-12x",
  "epistemic_stability_score": 3,
  "suggested_pcs_friction": -1,
  "suggested_position_cap": "none"
}
```
