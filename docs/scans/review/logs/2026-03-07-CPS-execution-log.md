# Execution Log: CPS Holding Review -- 2026-03-07

## Retrieval Path
- Primary research path: Gemini Grounded Search
- WebSearch fallback used: no
- Gemini queries:
  1. "Cooper-Standard Holdings CPS 2025 full year earnings results Q4 2025 margins revenue guidance 2026"
  2. "Cooper-Standard Holdings CPS CEO Jeffrey Edwards turnaround strategy margin recovery execution 2025 2026"
  3. "Cooper-Standard Holdings CPS debt refinancing maturity schedule leverage reduction 2025 2026"

## FMP API Commands
- `bash scripts/fmp-api.sh profile CPS`
- `bash scripts/fmp-api.sh income CPS`
- `bash scripts/fmp-api.sh cashflow CPS`
- `bash scripts/fmp-api.sh ratios CPS`
- `bash scripts/fmp-api.sh metrics CPS`
- `bash scripts/fmp-api.sh price-history CPS`
- `bash scripts/fmp-api.sh balance CPS`

## Calculator Commands and Raw JSON
### Forward Return (Base Case)
```bash
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

### Worst-Case Floor
```bash
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

### Conservative Scenario
```bash
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
- https://www.cooperstandard.com (Cooper Standard investor relations, earnings releases)
- https://www.spglobal.com (S&P Global Ratings credit analysis, March 2026)
- https://www.prnewswire.com (Cooper Standard Q4 2025 earnings press release, Feb 13, 2026)
- https://stocktitan.net (Cooper Standard debt refinancing announcements)
- https://seekingalpha.com (Cooper Standard earnings analysis)
- FMP Stable API (financialmodelingprep.com/stable)

## Compliance Audit
- JSON artifact saved: PASS -- data/scans/review/json/2026-03-07-CPS-holding-review.json
- JSON validation passed: PASS
- Markdown rendered via `scripts/report_json.py`: PASS
- Required review sections present: PASS
- Terminal save contract complete: PASS

## Output Paths
- JSON: `data/scans/review/json/2026-03-07-CPS-holding-review.json`
- Markdown: `data/scans/review/2026-03-07-CPS-holding-review.md`
- Docs JSON: `docs/scans/review/json/2026-03-07-CPS-holding-review.json`
- Docs Markdown: `docs/scans/review/2026-03-07-CPS-holding-review.md`
- Execution log: `docs/scans/review/logs/2026-03-07-CPS-execution-log.md`
