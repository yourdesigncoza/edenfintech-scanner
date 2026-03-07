---
sector: Financials
industry_group: Capital Markets
industry: Investment Banking & Brokerage
fmp_industry: "Financial - Capital Markets"
hydrated: 2026-03-07
version: 1
epistemic_stability: 3
suggested_pcs_friction: -1
typical_valuation: "P/TBV + P/E"
fcf_multiple_baseline: "N/A for bank-affiliated; 12-18x for asset-light brokers"
---

# Capital Markets

## Overview

Capital markets firms provide investment banking (M&A advisory, debt/equity underwriting), sales and trading (FICC, equities), wealth management, and prime brokerage services. Major players include Goldman Sachs, Morgan Stanley, Charles Schwab, and Raymond James. Revenue is highly cyclical, driven by deal volumes, trading activity, and asset values. Compensation ratios are high (45-55% of revenue), reflecting the talent-intensive model.

The industry bifurcates into: (a) bank-affiliated capital markets (GS, MS -- full balance sheet, proprietary capital, subject to bank regulation) and (b) asset-light platforms (SCHW, RJF -- primarily wealth management and brokerage, less trading risk). Post-Volcker Rule, proprietary trading is restricted for bank-affiliated firms, shifting revenue toward fee-based advisory and wealth management.

## Key Metrics & KPIs

| Metric | What It Measures | Healthy Range | Red Flag |
|--------|-----------------|---------------|----------|
| ROTCE | Return on tangible equity | 12-20% | <10% for bank-affiliated |
| Compensation Ratio | Comp expense / net revenue | 45-55% | >60% signals poor operating leverage |
| IB Revenue Growth | Advisory + underwriting fees | Cyclical but >5% normalized | Declining 2+ consecutive years |
| AUM Growth (wealth) | Client asset base | 5-15% YoY | Net outflows for 2+ quarters |
| Trading VaR | Risk-taking level | Stable/declining | Sudden spike signals concentrated bets |
| CET1 Ratio (bank-affiliated) | Regulatory capital | >12% (GSIB) | <10% |
| Pre-Tax Margin | Profitability | 25-35% (asset-light), 20-30% (bank) | <15% |
| Fee-Based Revenue % | Revenue quality | Rising toward 50%+ | <30% signals trading dependency |
| Efficiency Ratio | Cost discipline | 60-75% | >80% |
| Net New Assets (wealth) | Organic growth | Positive, growing | Negative for 2+ quarters |

## Valuation Approach

- **Primary method:** P/TBV for bank-affiliated (GS 1.2-2.0x, MS 1.5-2.5x); P/E for asset-light (SCHW 18-25x, RJF 12-16x)
- **Why NOT FCF:** Bank-affiliated firms face same FCF challenges as banks. Asset-light firms (SCHW) can use P/FCF (15-20x).
- **Common pitfalls:** Applying peak-cycle multiples to cyclical trough earnings; ignoring comp ratio flexibility.

## Turnaround Precedents

| Company | Period | Situation | Actions Taken | Outcome | Timeline | Stock Recovery |
|---------|--------|-----------|--------------|---------|----------|----------------|
| Morgan Stanley | 2008-2012 | FICC losses, Mitsubishi $9B injection, stock -70% | Shifted to wealth management (Smith Barney JV -> full ownership), de-risked trading | Full recovery, became wealth-led model | ~4 years | $8 to $20+ by 2013 |
| Goldman Sachs | 2011-2016 | FICC revenue halved, ROE <10%, regulatory pressure | Marcus consumer bank launch, expanded asset management, tech investment | Partial -- Marcus later scaled back; wealth management grew | ~5 years | Choppy recovery |
| Charles Schwab | 2022-2024 | TD Ameritrade integration, deposit outflows to money markets, stock -35% | Completed integration, managed deposit transition, cost synergies | Recovery in progress | ~2 years | Stock from $48 to $95 |

**Pattern:** Capital markets turnarounds involve pivoting from volatile trading to fee-based revenue (wealth, advisory). 2 of 3 achieved strong recovery. Base rate: ~67%.

## Risk Profile

- **Default risk type:** Cyclical / Financial
- **Cyclicality:** High (IB and trading revenue swing 30-50% peak to trough)
- **Regulatory discretion:** High for bank-affiliated (Fed, SEC, FINRA); Moderate for asset-light
- **Binary trigger frequency:** Rare post-Dodd-Frank for survivors; historical: Lehman 2008, Bear Stearns 2008, MF Global 2011

### Kill Factors

1. **Massive trading loss (>20% of equity)** -- Fatal for firms with concentrated risk. Example: Archegos cost Credit Suisse $5.5B (2021), contributing to its acquisition by UBS.
2. **Prime brokerage client contagion** -- Counterparty failure cascading through the system. Example: LTCM 1998 required consortium bailout.

### Friction Factors

1. **IB revenue down >30% YoY** -- friction: -1, rationale: cyclical, typically recovers within 2 years.
2. **Client asset outflows** -- friction: -1, rationale: signals competitive/reputational issue.

## Evidence Requirements

### Must-Have Data Points

| Data Point | Where to Find It | Why It Matters |
|-----------|-----------------|----------------|
| ROTCE | Earnings releases, FMP data | Links directly to P/TBV valuation |
| IB revenue by segment | 10-K, earnings supplements | Cycle position assessment |
| AUM/net new assets | Earnings releases | Organic growth health |
| VaR/trading risk metrics | 10-K Item 7A | Risk-taking level |
| CET1 (bank-affiliated) | 10-K, regulatory filings | Capital adequacy |

## Epistemic Profile

| PCS Question | Typical Answer | Rationale |
|-------------|---------------|-----------|
| Q1: Operational risk? | Mostly Yes (for asset-light); No (bank-affiliated -- financial risk dominates) | |
| Q2: Regulatory minimal? | No (bank-affiliated); Yes (asset-light) | |
| Q3: Historical precedent? | Yes | MS, GS turnarounds well-documented |
| Q4: Non-binary outcome? | Yes (post-Dodd-Frank TBTF) | |
| Q5: Macro/geo limited? | No | Deal volumes, trading tied to macro |

**Epistemic stability:** 3/5
**Suggested PCS friction:** -1 (cyclical revenue dependency)

```json
{
  "sector": "Financials",
  "sub_sector": "Capital Markets",
  "cyclicality": "high",
  "regulatory_discretion": "high",
  "binary_risk_level": "moderate",
  "macro_dependency": "high",
  "precedent_strength": "strong",
  "typical_valuation_method": "P/TBV (banks), P/E (asset-light)",
  "fcf_multiple_baseline": "12-18x for asset-light only",
  "epistemic_stability_score": 3,
  "suggested_pcs_friction": -1,
  "suggested_position_cap": "none"
}
```
