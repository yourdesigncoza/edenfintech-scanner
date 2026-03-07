# Execution Log: CPS Holding Review v4
**Date:** 2026-03-07
**Ticker:** CPS
**Review path:** `/home/laudes/zoot/projects/edenfintech-scanner/docs/scans/review/2026-03-07-CPS-holding-review-v4.md`

## Retrieval Path
- Primary: Gemini Grounded Search (3 queries)
- WebSearch fallback: not used

## Gemini Queries
1. "Cooper-Standard Holdings CPS latest earnings Q4 2025 results revenue margins guidance 2026"
2. "Cooper-Standard Holdings CPS debt refinancing credit facility maturity 2026 2027"
3. "Cooper-Standard Holdings CPS management CEO strategy turnaround progress 2025 2026"
4. "Cooper-Standard CPS auto tariffs impact 2026 25% tariff on imported auto parts"

## FMP Commands
- `profile CPS`
- `income CPS`
- `cashflow CPS`
- `ratios CPS`
- `metrics CPS`
- `price-history CPS`
- `balance CPS`

## Calculator Commands and Raw JSON

### Forward-Return (Base Case)
```
bash scripts/calc-score.sh forward-return 32 3.0 5.5 12 18 2
```
```json
{
  "current_price": 32.0,
  "revenue_b": 3.0,
  "fcf_margin_pct": 5.5,
  "multiple": 12.0,
  "shares_m": 18.0,
  "years": 2.0,
  "target_price": 110.0,
  "forward_cagr_pct": 85.4,
  "meets_30pct_hurdle": true,
  "meets_15pct_guardrail": true,
  "below_10pct_warning": false
}
```

### Floor (Trough)
```
bash scripts/calc-score.sh floor 2.33 -9.1 8 18 32
```
```json
{
  "revenue_b": 2.33,
  "fcf_margin_pct": -9.1,
  "fcf_b": -0.212,
  "multiple": 8.0,
  "shares_m": 18.0,
  "current_price": 32.0,
  "floor_price": -94.22,
  "downside_pct": 394.44
}
```

### Forward-Return (Conservative)
```
bash scripts/calc-score.sh forward-return 32 2.8 4.5 10 18 2
```
```json
{
  "current_price": 32.0,
  "revenue_b": 2.8,
  "fcf_margin_pct": 4.5,
  "multiple": 10.0,
  "shares_m": 18.0,
  "years": 2.0,
  "target_price": 70.0,
  "forward_cagr_pct": 47.9,
  "meets_30pct_hurdle": true,
  "meets_15pct_guardrail": true,
  "below_10pct_warning": false
}
```

## Source URLs
- cooperstandard.com (Q4 2025 earnings, debt refinancing, investor presentations)
- S&P Global Ratings (Mar 2026 auto sector outlook)
- stocktitan.net (press releases)
- FMP Stable API (financials, ratios, metrics, price history)

## Key Data Points Used
- Current price: $32.00 (Mar 6, 2026)
- FY2025 revenue: $2.74B
- FY2025 adj. EBITDA margin: 7.6% ($209.7M)
- FY2025 gross margin: 11.7%
- FY2025 FCF: $16.3M
- FY2025 net loss: -$4.2M (vs -$78.7M FY2024)
- Total debt: $1.26B
- Total equity: -$83M (negative)
- New business awards: $298M (74% EV/hybrid)
- Debt refi: $1.1B at 9.25% due 2031 (Mar 4, 2026)
- 2026 guidance: Revenue $2.7-2.9B, adj. EBITDA $260-300M (10%+ margin), capex $55-65M
- Shares diluted: ~17.9M
