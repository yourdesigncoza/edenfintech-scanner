# Execution Log: PYPL Holding Review v3
**Date:** 2026-03-07
**Ticker:** PYPL
**Review path:** `/home/laudes/zoot/projects/edenfintech-scanner/docs/scans/review/2026-03-07-PYPL-holding-review-v3.md`

## Retrieval Path
- Primary: Gemini Grounded Search (3 queries)
- WebSearch fallback: not used

## FMP API Commands Run
```
bash scripts/fmp-api.sh profile PYPL
bash scripts/fmp-api.sh income PYPL
bash scripts/fmp-api.sh cashflow PYPL
bash scripts/fmp-api.sh ratios PYPL
bash scripts/fmp-api.sh metrics PYPL
bash scripts/fmp-api.sh price-history PYPL
```

## Gemini Search Queries
1. "PayPal PYPL CEO Alex Chriss fired February 2026 new CEO Enrique Lores latest news developments March 2026"
2. "PayPal PYPL Q4 2025 earnings results revenue margins transaction volume 2026"
3. "PayPal PYPL lawsuits legal regulatory issues 2025 2026 SEC consumer protection"
4. "PayPal vs Apple Pay Stripe Block Square Adyen competitive landscape 2026 market share branded checkout"

## Calculator Commands and Raw JSON

### Base Case Valuation
```
bash scripts/calc-score.sh forward-return 46.97 36.0 16.5 13 900 2.5
```
```json
{
  "current_price": 46.97,
  "revenue_b": 36.0,
  "fcf_margin_pct": 16.5,
  "multiple": 13.0,
  "shares_m": 900.0,
  "years": 2.5,
  "target_price": 85.8,
  "forward_cagr_pct": 27.25,
  "meets_30pct_hurdle": false,
  "meets_15pct_guardrail": true,
  "below_10pct_warning": false
}
```

### Worst-Case Floor
```
bash scripts/calc-score.sh floor 27.5 14.2 8 960 46.97
```
```json
{
  "revenue_b": 27.5,
  "fcf_margin_pct": 14.2,
  "fcf_b": 3.905,
  "multiple": 8.0,
  "shares_m": 960.0,
  "current_price": 46.97,
  "floor_price": 32.54,
  "downside_pct": 30.72
}
```

### Intermediate Calculations (explored during review)
- 12x / 940M shares: target $73.53, CAGR 19.5% (too low)
- 15x / 940M shares / 16.5% margin: target $94.79, CAGR 32.5% (heroic multiple)
- 13x / 940M shares / 16.5% margin: target $82.15, CAGR 25.1%
- 12x / 900M shares / 16.5% margin: target $79.20, CAGR 23.2%
- 13x / 900M shares / 16.5% margin: target $85.80, CAGR 27.3% (selected as base)
- 10x floor with $27.5B rev (v2 approach): $40.68, downside 13.4%
- 8x floor with $27.5B rev (v3 approach): $32.54, downside 30.7%

## Key Delta from v2
- FCF multiple recalibrated from 18x to 13x (cumulative discount schedule applied)
- Base CAGR reduced from 36.6% to 27.3%
- Floor multiple reduced from 10x to 8x
- Floor price reduced from $40.68 to $32.54
- Verdict unchanged: HOLD_AND_MONITOR

## Source URLs
- FMP Stable API (cached data)
- Gemini sources: fintechmagazine.com, paymentsdive.com, fintechfutures.com, stocktitan.net, stockstory.org, capital.com, rgrdlaw.com, rosenlegal.com, redstagfulfillment.com, capitaloneshopping.com
