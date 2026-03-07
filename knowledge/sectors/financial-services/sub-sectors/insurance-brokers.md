---
sector: Financials
industry_group: Insurance
industry: Insurance Brokers
fmp_industry: "Insurance - Brokers"
hydrated: 2026-03-07
version: 1
epistemic_stability: 4
suggested_pcs_friction: 0
typical_valuation: "EV/EBITDA + P/E"
fcf_multiple_baseline: "18-25x"
---

# Insurance Brokers

## Overview

Insurance brokers act as intermediaries between insurance buyers and carriers, earning commissions and fees for placing coverage. Key players: Marsh McLennan (MMC), Aon (AON), Arthur J. Gallagher (AJG), Brown & Brown (BRO). This is one of the highest-quality business models in financial services: capital-light, recurring revenue (~85-90% retention rates), EBITDA margins of 25-35%, and low cyclicality.

Revenue growth is driven by organic growth (rate increases flow through as higher commissions), M&A (aggressive acquirers like AJG and BRO do 20-50 acquisitions per year), and expansion into consulting/risk advisory. The big 3 (MMC, AON, AJG) dominate large commercial accounts; BRO and smaller brokers serve mid-market.

Competitive dynamics favor scale: larger brokers get better access to specialty markets, data analytics capabilities, and client relationships. Barriers to entry are moderate (state licensing) but franchise stickiness is very high due to client switching costs.

## Key Metrics & KPIs

| Metric | What It Measures | Healthy Range | Red Flag |
|--------|-----------------|---------------|----------|
| Organic Revenue Growth | Core business expansion | 5-10% | <3% for 2+ years |
| EBITDA Margin | Operating efficiency | 28-35% | <25% |
| Revenue Retention Rate | Client stickiness | 90-95% | <85% |
| FCF Conversion | Cash quality | >80% | <70% |
| Acquisition Spending / Revenue | M&A intensity | 5-15% | >20% without margin expansion |
| Debt/EBITDA | Leverage from M&A | 2-3x | >4x |
| ROIC | Capital allocation quality | >15% | <10% |
| Revenue per Employee | Productivity | Growing | Declining |
| Adjusted EPS Growth | Shareholder return | 10-15% | <5% |
| Integration Success (acquired revenue retention) | M&A quality | >90% | <80% signals acquisition value destruction |

## Valuation Approach

- **Primary:** EV/EBITDA (15-22x) and P/E (20-30x). Premium for quality and predictability.
- **FCF works well:** Capital-light, clean cash flows. 18-25x P/FCF is typical.
- **Common pitfalls:** Ignoring M&A-driven leverage; applying industrial multiples to this asset-light model.

### EdenFinTech FCF Multiple Baseline

18-22x FCF baseline. These trade at premium multiples justified by recurring revenue, high retention, and consistent growth. Apply discount schedule from valuation-guidelines.md only for leverage or organic growth concerns.

## Turnaround Precedents

| Company | Period | Situation | Actions Taken | Outcome | Timeline | Stock Recovery |
|---------|--------|-----------|--------------|---------|----------|----------------|
| Marsh McLennan | 2004-2008 | Spitzer bid-rigging investigation, CEO resigned, $850M settlement, stock -50% | New management (Brian Duperreault), eliminated contingent commissions, rebuilt compliance | Full recovery | ~4 years | Stock from $24 to $30+ by 2007 |

**Pattern:** Insurance broker distress is rare -- only the Spitzer investigation (2004) caused fundamental disruption. Recovery was swift once legal overhang cleared. CONFIRMED_ABSENCE for bankruptcies in this sub-sector. Base rate: high (~90%+ for reputational/legal issues), as the underlying business model is extremely durable.

## Risk Profile

- **Default risk type:** Operational (reputation, compliance)
- **Cyclicality:** Low -- premiums may soften in soft markets but commission revenue is sticky
- **Regulatory discretion:** Low (state licensing, minimal federal oversight)
- **Binary trigger frequency:** Very rare

### Kill Factors

1. **Industry-wide regulatory ban on commission-based model** -- Would destroy the revenue model. No precedent; highly unlikely.

### Friction Factors

1. **Post-M&A leverage >4x EBITDA** -- friction: -1, rationale: temporary but creates financial risk.
2. **Spitzer-type bid-rigging investigation** -- friction: -1, rationale: reputational damage is temporary for established brokers.

## Epistemic Profile

**Epistemic stability:** 4/5 -- Highly predictable business with recurring revenue, high retention, and limited regulatory/macro exposure.
**Suggested PCS friction:** 0 -- Risk is primarily operational. This is among the most modelable sub-sectors in financial services.

```json
{
  "sector": "Financials",
  "sub_sector": "Insurance Brokers",
  "cyclicality": "low",
  "regulatory_discretion": "minimal",
  "binary_risk_level": "low",
  "macro_dependency": "low",
  "precedent_strength": "moderate",
  "typical_valuation_method": "EV/EBITDA",
  "fcf_multiple_baseline": "18-22x",
  "epistemic_stability_score": 4,
  "suggested_pcs_friction": 0,
  "suggested_position_cap": "none"
}
```
