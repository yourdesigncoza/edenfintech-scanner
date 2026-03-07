# Execution Log: CPS Holding Review v5 -- 2026-03-07

## Retrieval Path
- Primary: Gemini Grounded Search
- WebSearch fallback: not used
- Gemini queries:
  1. "Cooper-Standard Holdings CPS Q4 2025 earnings results revenue margins guidance outlook 2026"
  2. "Cooper-Standard Holdings CPS 2026 auto parts industry tariffs competition margin recovery management CEO Edwards"

## FMP API Commands
- `bash scripts/fmp-api.sh profile CPS`
- `bash scripts/fmp-api.sh income CPS`
- `bash scripts/fmp-api.sh cashflow CPS`
- `bash scripts/fmp-api.sh ratios CPS`
- `bash scripts/fmp-api.sh metrics CPS`
- `bash scripts/fmp-api.sh price-history CPS`
- `bash scripts/fmp-api.sh balance CPS`

## Calculator Commands and Raw JSON

### Base Case Valuation
```
bash scripts/calc-score.sh valuation 3.0 5.5 12 18
```
```json
{"revenue_b": 3.0, "fcf_margin_pct": 5.5, "fcf_b": 0.165, "multiple": 12.0, "shares_m": 18.0, "target_price": 110.0}
```

### Base Case CAGR
```
bash scripts/calc-score.sh cagr 32 110 2
```
```json
{"current_price": 32.0, "target_price": 110.0, "years": 2.0, "cagr_pct": 85.4, "meets_hurdle": true, "hurdle": 30}
```

### Forward Return
```
bash scripts/calc-score.sh forward-return 32 3.0 5.5 12 18 2
```
```json
{"current_price": 32.0, "revenue_b": 3.0, "fcf_margin_pct": 5.5, "multiple": 12.0, "shares_m": 18.0, "years": 2.0, "target_price": 110.0, "forward_cagr_pct": 85.4, "meets_30pct_hurdle": true, "meets_15pct_guardrail": true, "below_10pct_warning": false}
```

### Worst-Case Floor
```
bash scripts/calc-score.sh floor 2.33 -9.1 8 18 32
```
```json
{"revenue_b": 2.33, "fcf_margin_pct": -9.1, "fcf_b": -0.212, "multiple": 8.0, "shares_m": 18.0, "current_price": 32.0, "floor_price": -94.22, "downside_pct": 394.44}
```

### Conservative Scenario
```
bash scripts/calc-score.sh forward-return 32 2.8 4.5 10 18 2
```
```json
{"current_price": 32.0, "revenue_b": 2.8, "fcf_margin_pct": 4.5, "multiple": 10.0, "shares_m": 18.0, "years": 2.0, "target_price": 70.0, "forward_cagr_pct": 47.9, "meets_30pct_hurdle": true, "meets_15pct_guardrail": true, "below_10pct_warning": false}
```

## Source URLs
- Cooper Standard Q4 2025 Earnings Release (Feb 13, 2026) -- cooperstandard.com
- Cooper Standard Debt Refinancing Press Release (Mar 4, 2026) -- cooperstandard.com
- S&P Global Ratings CPS Credit Analysis (Mar 2026) -- spglobal.com
- Gemini Grounded Search (multiple queries)
- FMP Stable API (profile, income, cashflow, ratios, metrics, price-history, balance)

## Prior Review Reference
- v4: docs/scans/review/2026-03-07-CPS-holding-review-v4.md (HOLD, $110 target, 85.4% CAGR)

## Output Paths
- JSON: data/scans/review/json/2026-03-07-CPS-holding-review-v5.json
- Markdown: data/scans/review/2026-03-07-CPS-holding-review-v5.md
- Git-tracked copies: docs/scans/review/2026-03-07-CPS-holding-review-v5.md, docs/scans/review/json/2026-03-07-CPS-holding-review-v5.json
- Execution log: docs/scans/review/logs/2026-03-07-CPS-execution-log-v5.md
