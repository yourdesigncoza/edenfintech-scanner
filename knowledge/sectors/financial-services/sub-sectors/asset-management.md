---
sector: Financials
industry_group: Capital Markets
industry: Asset Management & Custody Banks
fmp_industry: "Asset Management"
hydrated: 2026-03-07
version: 1
epistemic_stability: 3
suggested_pcs_friction: 0
typical_valuation: "P/E + P/AUM"
fcf_multiple_baseline: "12-18x (traditional), 15-25x (alternatives)"
---

# Asset Management

## Overview

Asset management firms manage investment portfolios on behalf of institutional and retail clients, earning fees based on assets under management (AUM). The industry segments into: (a) traditional/active managers (T. Rowe Price, Franklin Templeton -- fee pressure from passive), (b) passive/index providers (BlackRock via iShares -- scale winners), and (c) alternative managers (Blackstone, KKR, Apollo -- private equity, credit, real estate -- higher fees, longer lock-ups).

Revenue = management fees (typically 0.3-1.5% of AUM depending on strategy) + performance/incentive fees (typically 20% of profits above hurdle for alternatives) + carried interest. The secular shift from active to passive has compressed fees for traditional managers while alternatives have seen sustained AUM growth. Capital intensity is low; the primary asset is talent.

Key dynamics: BlackRock ($11.6T AUM) and Vanguard dominate passive/index; Blackstone ($1.1T AUM), Apollo, KKR dominate alternatives. Traditional active managers face existential pressure from fee compression and outflows.

## Key Metrics & KPIs

| Metric | What It Measures | Healthy Range | Red Flag |
|--------|-----------------|---------------|----------|
| AUM Growth | Scale of business | 5-15% YoY | Negative AUM growth (net outflows + market depreciation) |
| Net Flows | Organic growth (excluding market appreciation) | Positive | Net outflows for 3+ consecutive quarters |
| Fee Rate (bps on AUM) | Revenue quality | 15-30bps (passive), 50-100bps (active), 100-150bps (alternatives) | Declining >5bps/yr |
| Operating Margin | Profitability | 30-45% | <25% for traditional; <35% for alternatives |
| Performance Fee % of Revenue | Revenue volatility | <30% for traditional, 30-50% for alternatives | >60% signals excessive dependency on carry |
| Fund Performance vs Benchmark | Client retention driver | Above median/benchmark | Below benchmark 3+ years -> redemption risk |
| FRE (Fee-Related Earnings) Margin | Recurring profitability (alternatives) | 50-60% | <40% |
| Fundraising (alternatives) | Growth pipeline | Strong vintage years | Declining fund sizes |
| Distributable Earnings per Share | Cash flow to shareholders | Growing | Declining |
| Employee Count Growth | Cost trajectory | Modest | >10% YoY without proportional AUM growth |

## Valuation Approach

- **Primary method:** P/E for traditional (10-15x), P/FRE for alternatives (20-30x), P/AUM as cross-check
- **Secondary method:** P/FCF works for capital-light managers (12-18x traditional, 15-25x alternatives)
- **Common pitfalls:** Conflating management fees (recurring) with performance fees (volatile); applying alt manager multiples to traditional managers facing outflows.

### EdenFinTech FCF Multiple Baseline

12-15x for traditional active managers (fee pressure discount). 18-22x for alternative managers with strong fundraising. Apply valuation-guidelines.md discount schedule.

## Turnaround Precedents

| Company | Period | Situation | Actions Taken | Outcome | Timeline | Stock Recovery |
|---------|--------|-----------|--------------|---------|----------|----------------|
| Franklin Templeton | 2015-2020 | Persistent outflows ($30B+/yr), underperformance in key strategies, stock -50% | Acquired Legg Mason (2020) for $4.5B, diversified into alternatives and fixed income | Partial recovery -- outflows slowed | ~5 years | Stock stabilized but underperformed sector |
| Invesco | 2018-2022 | AUM decline, OppenheimerFunds integration challenges, elevated leverage | Cost cuts, integration completion, ETF growth (QQQ franchise) | Partial recovery | ~4 years | Stock from $15 to $20 (choppy) |
| T. Rowe Price | 2022-2024 | AUM decline from market losses, net outflows, stock -45% from peak | Maintained investment in capabilities, launched alternatives/retirement products | Partial recovery, outflows moderating | ~2 years | Stock from $95 to $110 range |

**Pattern:** Traditional asset management turnarounds are difficult because the core problem (fee compression from passive) is structural. M&A is the typical response but integration is risky. 1 of 3 achieved strong recovery; alternatives exposure is the key differentiator. Base rate: ~40% for traditional managers, ~70% for alternative managers.

## Risk Profile

- **Default risk type:** Operational / Structural (secular disruption from passive)
- **Cyclicality:** Moderate-High (AUM drops with markets, but fee revenue partially buffers)
- **Regulatory discretion:** Moderate (SEC Investment Advisers Act, DOL fiduciary rule)
- **Binary trigger frequency:** Rare -- asset managers rarely face existential risk (they don't hold principal risk)

### Kill Factors

1. **Net outflows exceeding 10% of AUM annually for 3+ years** -- Signals permanent franchise erosion. Example: Legg Mason pre-acquisition.
2. **Fund fraud or misvaluation scandal** -- Destroys trust permanently. Example: Woodford Investment Management (UK, 2019).

### Friction Factors

1. **Fee compression >10bps/yr** -- friction: -1, rationale: structural but gradual.
2. **Key portfolio manager departures** -- friction: -1, rationale: concentrated talent risk, especially for star-manager firms.

## Epistemic Profile

**Epistemic stability:** 3/5 -- Traditional managers face structural uncertainty (passive disruption); alternatives are more predictable with locked-up capital.
**Suggested PCS friction:** 0 -- Risk is primarily operational/competitive, not regulatory or binary.

```json
{
  "sector": "Financials",
  "sub_sector": "Asset Management",
  "cyclicality": "moderate",
  "regulatory_discretion": "moderate",
  "binary_risk_level": "low",
  "macro_dependency": "moderate",
  "precedent_strength": "moderate",
  "typical_valuation_method": "P/E, P/FRE",
  "fcf_multiple_baseline": "12-18x traditional, 18-22x alternatives",
  "epistemic_stability_score": 3,
  "suggested_pcs_friction": 0,
  "suggested_position_cap": "none"
}
```
