# Execution Log: CPS-AAP-DORM-PYPL Scan v5 (2026-03-07)

## Retrieval Path

| Step | Data Source | Tickers | Notes |
|------|------------|---------|-------|
| Profile | FMP /stable/profile | CPS, AAP, DORM, PYPL | Cached |
| Income (6yr) | FMP /stable/income-statement | CPS, AAP, DORM, PYPL | Cached |
| Cash Flow (6yr) | FMP /stable/cash-flow-statement | CPS, AAP, DORM, PYPL | Cached |
| Balance Sheet (4yr) | FMP /stable/balance-sheet-statement | CPS, AAP, PYPL | Cached |
| Share Counts | FMP /stable/historical-market-capitalization | CPS, AAP, PYPL | Cached |
| Price History (ATH) | FMP /stable/historical-price-eod/full | CPS, AAP, DORM, PYPL | Cached |
| Sector Knowledge | knowledge/sectors/consumer-cyclical/sub-sectors/auto-parts.md | CPS, AAP, DORM | Hydrated 2026-03-07 |
| Sector Knowledge | knowledge/sectors/financial-services/sub-sectors/credit-services.md | PYPL | Hydrated 2026-03-07 |
| Gemini Research | CEO status, turnaround progress, catalyst updates | CPS, AAP, PYPL | Cached from earlier session |

## Key Commands Run

```bash
# Profile/screen data
bash scripts/fmp-api.sh profile CPS
bash scripts/fmp-api.sh profile AAP
bash scripts/fmp-api.sh profile PYPL
bash scripts/fmp-api.sh profile DORM

# Share counts
bash scripts/fmp-api.sh shares CPS   # 17.86M
bash scripts/fmp-api.sh shares AAP   # 59.9M
bash scripts/fmp-api.sh shares PYPL  # 959M

# Hydration status
cat knowledge/sectors/hydration-status.json
```

## Calculator Commands and Raw JSON

### CPS Floor (negative trough margin)
```bash
bash scripts/calc-score.sh floor 2.330 -9.1 8 17.86 32
```
```json
{"revenue_b": 2.33, "fcf_margin_pct": -9.1, "fcf_b": -0.212, "multiple": 8.0, "shares_m": 17.86, "current_price": 32.0, "floor_price": -94.96, "downside_pct": 396.75}
```
Interpretation: Negative FCF floor -> effective downside capped at 100%.

### AAP Floor (negative trough margin)
```bash
bash scripts/calc-score.sh floor 8.601 -3.5 8 59.9 50.33
```
```json
{"revenue_b": 8.601, "fcf_margin_pct": -3.5, "fcf_b": -0.301, "multiple": 8.0, "shares_m": 59.9, "current_price": 50.33, "floor_price": -40.2, "downside_pct": 179.87}
```
Interpretation: Negative FCF floor -> effective downside capped at 100%.

### PYPL Floor
```bash
bash scripts/calc-score.sh floor 21.454 14.2 8 959 46.97
```
```json
{"revenue_b": 21.454, "fcf_margin_pct": 14.2, "fcf_b": 3.0465, "multiple": 8.0, "shares_m": 959.0, "current_price": 46.97, "floor_price": 25.41, "downside_pct": 45.9}
```

### CPS Base Case
```bash
bash scripts/calc-score.sh forward-return 32 2.8 4 10 17.86 3
```
```json
{"current_price": 32.0, "revenue_b": 2.8, "fcf_margin_pct": 4.0, "multiple": 10.0, "shares_m": 17.86, "years": 3.0, "target_price": 62.71, "forward_cagr_pct": 25.14, "meets_30pct_hurdle": false}
```

### AAP Base Case
```bash
bash scripts/calc-score.sh forward-return 50.33 9.0 5 12 59.9 3
```
```json
{"current_price": 50.33, "revenue_b": 9.0, "fcf_margin_pct": 5.0, "multiple": 12.0, "shares_m": 59.9, "years": 3.0, "target_price": 90.15, "forward_cagr_pct": 21.44, "meets_30pct_hurdle": false}
```

### PYPL Base Case
```bash
bash scripts/calc-score.sh forward-return 46.97 38 17 12 900 2
```
```json
{"current_price": 46.97, "revenue_b": 38.0, "fcf_margin_pct": 17.0, "multiple": 12.0, "shares_m": 900.0, "years": 2.0, "target_price": 86.13, "forward_cagr_pct": 35.42, "meets_30pct_hurdle": true}
```

### CPS Score
```bash
bash scripts/calc-score.sh score 100 50 25.1
```
```json
{"downside_pct": 100.0, "adjusted_downside": 150.0, "risk_component": -22.5, "probability_component": 20.0, "return_component": 3.77, "total_score": 1.27}
```

### AAP Score
```bash
bash scripts/calc-score.sh score 100 50 21.4
```
```json
{"downside_pct": 100.0, "adjusted_downside": 150.0, "risk_component": -22.5, "probability_component": 20.0, "return_component": 3.21, "total_score": 0.71}
```

### PYPL Score (pre-epistemic)
```bash
bash scripts/calc-score.sh score 45.9 60 35.4
```
```json
{"downside_pct": 45.9, "adjusted_downside": 56.43, "risk_component": 19.61, "probability_component": 24.0, "return_component": 5.31, "total_score": 48.92}
```

### PYPL Effective Probability
```bash
bash scripts/calc-score.sh effective-prob 60 1
```
```json
{"base_probability": 60.0, "confidence": 1, "multiplier": 0.5, "effective_probability": 30.0}
```

### PYPL Score (post-epistemic)
```bash
bash scripts/calc-score.sh score 45.9 60 35.4 1
```
```json
{"downside_pct": 45.9, "adjusted_downside": 56.43, "risk_component": 19.61, "probability_component": 12.0, "return_component": 5.31, "total_score": 36.92, "effective_probability": 30.0}
```

### PYPL Probability Sensitivity
```bash
bash scripts/calc-score.sh score 45.9 55 35.4  # 46.92
bash scripts/calc-score.sh score 45.9 60 35.4  # 48.92
bash scripts/calc-score.sh score 45.9 65 35.4  # 50.92
bash scripts/calc-score.sh score 45.9 70 35.4  # 52.92
bash scripts/calc-score.sh score 45.9 75 35.4  # 54.92
```

## Source URLs

- FMP API: https://financialmodelingprep.com/stable
- Sector knowledge: knowledge/sectors/consumer-cyclical/sub-sectors/auto-parts.md
- Sector knowledge: knowledge/sectors/financial-services/sub-sectors/credit-services.md
- Gemini Grounded Search used for CEO/catalyst research (cached)

## Compliance Audit

| Check | Status | Notes |
|-------|--------|-------|
| All scores via calc-score.sh | PASS | All 8 calculator invocations shown above |
| Trough-anchored floors | PASS | All 3 candidates have floor calc with trough path |
| Probability banding | PASS | CPS 50%, AAP 50%, PYPL 60% — all valid bands |
| Calibration rules checked | PASS | No exceptions triggered |
| PCS evidence-anchored | PASS | All 5 PYPL PCS answers cite evidence |

## Output Paths

- JSON artifact: `data/scans/json/2026-03-07-CPS-AAP-DORM-PYPL-scan-report-v5.json`
- Rendered report: `data/scans/2026-03-07-CPS-AAP-DORM-PYPL-scan-report-v5.md`
- Execution log: `data/scans/2026-03-07-CPS-AAP-DORM-PYPL-execution-log-v5.md`
- Docs copy: `docs/scans/2026-03-07-CPS-AAP-DORM-PYPL-scan-report-v5.md`
