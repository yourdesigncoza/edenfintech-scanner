---
sector: Financials
industry_group: Capital Markets
industry: Investment Banking & Brokerage
fmp_industry: "Investment - Banking & Investment Services"
hydrated: 2026-03-07
version: 1
epistemic_stability: 3
suggested_pcs_friction: -1
typical_valuation: "P/TBV + P/E"
fcf_multiple_baseline: "10-15x for independent advisors"
---

# Investment Banking & Services

## Overview

This sub-sector covers firms focused on investment banking advisory, brokerage services, and financial intermediation that are not primarily bank-affiliated or asset managers. Includes independent advisory firms (Lazard, Evercore, Moelis), financial holding companies (Brookfield), and multi-service financial firms.

Revenue is highly cyclical, driven by M&A deal volumes, IPO/capital markets activity, and restructuring mandates. During downturns, restructuring revenue provides a partial offset to advisory declines. The model is talent-intensive with high compensation ratios (55-65%).

Note: This sub-sector has limited NYSE representation in FMP data (primarily preferred shares of Brookfield Finance). Most independent investment banks trade on Nasdaq. For scan purposes, overlap with Capital Markets sub-sector is significant.

## Key Metrics & KPIs

| Metric | What It Measures | Healthy Range | Red Flag |
|--------|-----------------|---------------|----------|
| Advisory Revenue Growth | Deal activity | Cyclical, >5% normalized | Down >30% (cycle trough) |
| Compensation Ratio | Cost discipline | 55-65% | >70% |
| Pre-Tax Margin | Profitability | 15-25% | <10% |
| Revenue Diversification | Advisory vs capital markets vs restructuring | Balanced | >80% single-source |
| Managing Director Retention | Talent health | >90% | <85% signals talent drain |

## Valuation Approach

- **Primary:** P/E (10-18x) for independent advisors; P/TBV for bank-affiliated.
- **FCF:** Semi-applicable for asset-light independents. 10-15x normalized FCF.

## Turnaround Precedents

CONFIRMED_ABSENCE for independent advisory firms -- these are asset-light, low-leverage businesses that rarely face fundamental distress. They downsize in downturns and re-hire in upturns. The primary risk is talent departure during lean periods.

For bank-affiliated investment banking, see Capital Markets and Diversified Banks sub-sector files (Lehman Brothers 2008, Bear Stearns 2008, MF Global 2011 are covered there).

## Risk Profile

- **Default risk type:** Cyclical
- **Cyclicality:** High (deal volumes)
- **Regulatory discretion:** Moderate (SEC, FINRA)
- **Binary trigger frequency:** Very rare for independent advisors; historical for bank-affiliated (Lehman, Bear Stearns)

### Kill Factors

1. **Mass managing director departures (>30% in a year)** -- For talent-driven businesses, this IS the business dissolving.

### Friction Factors

1. **M&A volume down >40%** -- friction: -1, rationale: cyclical, typically recovers within 2 years.

## Epistemic Profile

**Epistemic stability:** 3/5 -- Cyclical revenue is the main uncertainty; business model fundamentals are straightforward.
**Suggested PCS friction:** -1 -- Cyclical/macro dependency.

```json
{
  "sector": "Financials",
  "sub_sector": "Investment Banking & Services",
  "cyclicality": "high",
  "regulatory_discretion": "moderate",
  "binary_risk_level": "low",
  "macro_dependency": "high",
  "precedent_strength": "weak",
  "typical_valuation_method": "P/E",
  "fcf_multiple_baseline": "10-15x",
  "epistemic_stability_score": 3,
  "suggested_pcs_friction": -1,
  "suggested_position_cap": "none"
}
```
