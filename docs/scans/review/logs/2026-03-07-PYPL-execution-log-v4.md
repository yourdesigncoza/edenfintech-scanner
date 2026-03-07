# Execution Log: PYPL Holding Review v4 -- 2026-03-07

## Retrieval Path
- Primary: Gemini Grounded Search (4 queries)
- Fallback: Not needed
- FMP API: 6 endpoints (profile, income, cashflow, ratios, metrics, price-history)

## FMP API Calls
1. `bash scripts/fmp-api.sh profile PYPL` -- current price $46.97, CEO listed as Jamie S. Miller (interim/cached)
2. `bash scripts/fmp-api.sh income PYPL` -- FY2025 revenue $33.34B, net income $5.23B
3. `bash scripts/fmp-api.sh cashflow PYPL` -- FY2025 FCF $5.56B, buybacks $6.05B
4. `bash scripts/fmp-api.sh ratios PYPL` -- FY2025 P/E 10.7x, P/FCF 10.1x, operating margin 19.7%
5. `bash scripts/fmp-api.sh metrics PYPL` -- FY2025 EV/EBITDA 7.5x, ROIC 16.2%, ROE 25.8%
6. `bash scripts/fmp-api.sh price-history PYPL` -- 52wk range $38.46-$79.50

## Gemini Search Queries
1. "PayPal PYPL CEO change 2026 Enrique Lores latest news developments March 2026"
2. "PayPal PYPL Q4 2025 earnings results revenue growth margins guidance 2026"
3. "PayPal PYPL lawsuits legal issues regulatory 2026"
4. "PayPal PYPL competitors Stripe Block Square fintech payments market share 2025 2026"

## Calculator Commands and Results

### Base Case Valuation
```
bash scripts/calc-score.sh valuation 37 17.0 15 960
```
```json
{
  "revenue_b": 37.0,
  "fcf_margin_pct": 17.0,
  "fcf_b": 6.29,
  "multiple": 15.0,
  "shares_m": 960.0,
  "target_price": 98.28
}
```

### Base Case CAGR
```
bash scripts/calc-score.sh cagr 46.97 98.28 2.5
```
```json
{
  "current_price": 46.97,
  "target_price": 98.28,
  "years": 2.5,
  "cagr_pct": 34.36,
  "meets_hurdle": true,
  "hurdle": 30
}
```

### Forward Return (combined)
```
bash scripts/calc-score.sh forward-return 46.97 37 17.0 15 960 2.5
```
```json
{
  "current_price": 46.97,
  "revenue_b": 37.0,
  "fcf_margin_pct": 17.0,
  "multiple": 15.0,
  "shares_m": 960.0,
  "years": 2.5,
  "target_price": 98.28,
  "forward_cagr_pct": 34.36,
  "meets_30pct_hurdle": true,
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

### Conservative Scenario
```
bash scripts/calc-score.sh forward-return 46.97 35.5 16.0 13 940 2.5
```
```json
{
  "current_price": 46.97,
  "revenue_b": 35.5,
  "fcf_margin_pct": 16.0,
  "multiple": 13.0,
  "shares_m": 940.0,
  "years": 2.5,
  "target_price": 78.55,
  "forward_cagr_pct": 22.84,
  "meets_30pct_hurdle": false,
  "meets_15pct_guardrail": true,
  "below_10pct_warning": false
}
```

## Key Sources
- PayPal FY2025 10-K filed 2026-02-03
- PayPal Q4 2025 earnings release 2026-02-03
- PayPal CEO transition announcement (Lores effective March 1, 2026)
- Securities fraud class-action filings (lead plaintiff deadline April 20, 2026)
- Stripe market share data (demandsage.com, chargeflow.io)

## Final Review Path
- JSON: `data/scans/review/json/2026-03-07-PYPL-holding-review-v4.json`
- Markdown: `docs/scans/review/2026-03-07-PYPL-holding-review-v4.md`
