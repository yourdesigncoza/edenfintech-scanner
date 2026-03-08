# EdenFinTech Stock Scan -- 2026-03-08 (v1)

## Scan Parameters
- Universe: Specific tickers | Focus: CPS, AAP, DORM, PYPL | Stocks scanned: 4
- Date: 2026-03-08
- API: Financial Modeling Prep

## Executive Summary
- 4 stocks scanned (CPS, AAP, DORM, PYPL) -- 1 ranked survivor (PYPL, via human CAGR exception)
- DORM rejected at screening: only 34% off ATH, fails 60% broken chart requirement. CAGR ~5% even with generous assumptions.
- CPS rejected at analysis: negative equity floor (100% downside), 50% probability below 60% threshold despite 35% CAGR.
- AAP rejected at analysis: negative FCF margin floor (100% downside), 50% probability, 25% CAGR insufficient.
- PYPL approved via 20% CAGR exception: score 63.33, CAGR 28.2%, 20% downside, 60% probability. Max size 6-10%.

## Ranked Candidates

| Rank | Ticker | Score | CAGR | Downside | Prob | Max Size | Notes |
|------|--------|-------|------|----------|------|----------|-------|
| 1 | PYPL | 63.33 | 28.2% | 20.0% | 60% | 6-10% | 20% CAGR exception APPROVED by human reviewer. CEO Lores tenure <1yr caps probability at 60%. Strong FCF ($5.6B), low downside, but competitive pressure on branded checkout and third CEO in 3 years create execution uncertainty. |

## Pending Human Review
*None.* PYPL exception approved 2026-03-08.

## Portfolio Impact
- Current positions: 10/12 | Available slots: 2
- Auto parts concentration: CPS (~25%) + AAP (~8%) = ~33% of portfolio in auto parts theme. Both scanned stocks rejected -- no new capital recommended for auto parts.
- Catalyst concentration: no new catalyst themes would be added (all scanned stocks are existing holdings or rejected).
- vs. Weakest holding: PYPL is already held at ~11-20% weight. No new capital deployment scenario applies since PYPL fails the 30% CAGR hurdle for new capital.
- Deployment recommendation: Scenario 1 (Cash Available) -- no new ideas clear the hurdle. Hold cash for better opportunities. Patience is an edge.

## Rejected at Screening
| Ticker | Failed At | Reason |
|---|---|---|
| DORM | Step 1 -- Broken Chart | Only 34% off ATH ($166 to $109). Requires 60%+ decline. Even with generous assumptions (rev $2.4B, 8% FCF margin, 20x multiple), implied CAGR is ~5%. Not beaten down enough for deep value methodology. |

## Rejected at Analysis Detail Packets

### CPS
- Rejection reason: base probability below threshold (base 50% < 60% hard cap). Negative equity (-$83M FY2025) from operating deterioration (not spinoff) confirms solvency risk. Floor price negative (-$70.67) due to trough FCF margin of -9.1%. Downside capped at 100%.
- Valuation command: `bash scripts/calc-score.sh valuation 2.85 5.0 10 18`
- CAGR command: `bash scripts/calc-score.sh cagr 32 79.17 3`
- Floor command: `bash scripts/calc-score.sh floor 2.33 -9.1 6 18 32`
- Score command: `bash scripts/calc-score.sh score 100 50 35.25`
- Size command: `bash scripts/calc-score.sh size 2.79 35.25 50 100`
- Valuation JSON:
```json
{
  "revenue_b": 2.85,
  "fcf_margin_pct": 5.0,
  "fcf_b": 0.1425,
  "multiple": 10.0,
  "shares_m": 18.0,
  "target_price": 79.17
}
```
- CAGR JSON:
```json
{
  "current_price": 32.0,
  "target_price": 79.17,
  "years": 3.0,
  "cagr_pct": 35.25,
  "meets_hurdle": true,
  "hurdle": 30
}
```
- Floor JSON:
```json
{
  "revenue_b": 2.33,
  "fcf_margin_pct": -9.1,
  "fcf_b": -0.212,
  "multiple": 6.0,
  "shares_m": 18.0,
  "current_price": 32.0,
  "floor_price": -70.67,
  "downside_pct": 320.84
}
```
- Score JSON:
```json
{
  "downside_pct": 100.0,
  "adjusted_downside": 150.0,
  "risk_component": -22.5,
  "probability_component": 20.0,
  "return_component": 5.29,
  "total_score": 2.79
}
```
- Size JSON:
```json
{
  "score": 2.79,
  "score_band": "<45",
  "score_based_max": "0%",
  "hard_breakpoint_cap": "0%",
  "hard_breakpoint_reason": "probability < 60%",
  "final_max_size": "0%",
  "investable": false
}
```
- Downside normalization: mechanical 320.84% / scored 100% (equity floor below zero -> capped at 100%)

### AAP
- Rejection reason: base probability below threshold (base 50% < 60% hard cap) AND CAGR 25.37% below 30% hurdle (no exception evidence: O'Kelly is new CEO without proven turnaround track record). Floor price negative (-$40.13) due to trough FCF margin of -3.5%. Downside capped at 100%.
- Valuation command: `bash scripts/calc-score.sh valuation 9.0 5.5 12 59.9`
- CAGR command: `bash scripts/calc-score.sh cagr 50.33 99.17 3`
- Floor command: `bash scripts/calc-score.sh floor 8.6 -3.5 8 60 50.33`
- Score command: `bash scripts/calc-score.sh score 100 50 25.37`
- Size command: `bash scripts/calc-score.sh size 1.31 25.37 50 100`
- Valuation JSON:
```json
{
  "revenue_b": 9.0,
  "fcf_margin_pct": 5.5,
  "fcf_b": 0.495,
  "multiple": 12.0,
  "shares_m": 59.9,
  "target_price": 99.17
}
```
- CAGR JSON:
```json
{
  "current_price": 50.33,
  "target_price": 99.17,
  "years": 3.0,
  "cagr_pct": 25.37,
  "meets_hurdle": false,
  "hurdle": 30
}
```
- Floor JSON:
```json
{
  "revenue_b": 8.6,
  "fcf_margin_pct": -3.5,
  "fcf_b": -0.301,
  "multiple": 8.0,
  "shares_m": 60.0,
  "current_price": 50.33,
  "floor_price": -40.13,
  "downside_pct": 179.73
}
```
- Score JSON:
```json
{
  "downside_pct": 100.0,
  "adjusted_downside": 150.0,
  "risk_component": -22.5,
  "probability_component": 20.0,
  "return_component": 3.81,
  "total_score": 1.31
}
```
- Size JSON:
```json
{
  "score": 1.31,
  "score_band": "<45",
  "score_based_max": "0%",
  "hard_breakpoint_cap": "0%",
  "hard_breakpoint_reason": "CAGR < 30%",
  "final_max_size": "0%",
  "investable": false
}
```
- Downside normalization: mechanical 179.73% / scored 100% (equity floor below zero -> capped at 100%)

## Current Holding Overlays

### CPS
- Status in scan: REJECTED_AT_ANALYSIS
- New capital decision: DO_NOT_ADD
- Existing position action: HOLD_AND_MONITOR
- Reason: CPS fails new capital assessment (100% downside, 50% probability) but this does NOT trigger a sell for the existing ~25% position. The company is showing turnaround progress (EBITDA margin improving toward 10%, FCF positive, debt refinanced to 2031). Step 8 sell triggers are not activated: thesis is not broken (margin recovery on track), forward returns from cost basis (~$14) remain attractive. Monitor: debt refinancing execution, EBITDA margin progress toward 10% target, FCF trajectory. Next review: after Q1 2026 earnings.

### AAP
- Status in scan: REJECTED_AT_ANALYSIS
- New capital decision: DO_NOT_ADD
- Existing position action: HOLD_AND_MONITOR
- Reason: AAP fails new capital assessment (100% downside, 50% probability, 25% CAGR) but existing ~8% position is early in turnaround. Positive comps in 2025 (+0.8%) after 3 years of decline, operating margin expanding 200bps, guided 2026 FCF return to positive ~$100M. Step 8 sell triggers: thesis not broken (turnaround progressing, just slowly), forward returns from cost basis (~$40.61) may still be adequate. Monitor: 2026 FCF delivery, comparable store sales acceleration, margin trajectory toward guided 3.8-4.5% adj operating margin.

### PYPL
- Status in scan: REJECTED_AT_ANALYSIS
- New capital decision: DO_NOT_ADD
- Existing position action: HOLD_AND_MONITOR
- Reason: PYPL is an exception candidate (CAGR 28.2%, score 63.33) but fails the 30% CAGR hurdle for new capital. Existing ~11-20% position: thesis is WEAKENED (third CEO in 3 years, branded checkout slowing to 1%, class action lawsuits) but not BROKEN ($5.6B FCF, strong network, buybacks). Step 8 sell trigger assessment: T1 (target reached) -- not applicable; T2 (rapid move) -- not triggered; T3 (thesis broken) -- thesis weakened but not broken, Lores has until mid-2026 to show credible strategy. Monitor: Lores strategy announcement, Q2 2026 branded checkout growth, class action developments. Deadline: mid-2026 for credible Lores strategy or downgrade to BROKEN.

## Methodology Notes
- Qualitative assessments (moats, management, probability) are LLM estimates -- review critically
- Valuation multiples involve judgment -- verify reasoning matches your own assessment
- Catalyst timelines are estimates based on public information as of scan date
- All scoring math computed via calc-score.sh (deterministic, not LLM-generated)
- Epistemic confidence assessed independently for PYPL -- reviewer never sees analyst probability or score
- PCS answers are evidence-anchored -- each answer cites a source or declares NO_EVIDENCE
- Risk-type friction: PYPL classified Operational/Financial (litigation assessed as SECONDARY per materiality gate: shareholder class action <5% of market cap, not existential). No friction applied.
- Threshold proximity warning: PYPL base probability 60% is AT the 60% hard cap (constrained by CEO <1yr tenure ceiling of 65%, banded to 60%)
- Downside methodology audited: CPS and AAP have negative floors -> downside capped at 100% with explicit normalization. PYPL floor calc present, trough path verified.
- CPS floor calc: calc-score.sh floor 2.33 -9.1 6 18 32 -> -$70.67, mechanical downside 320.84%, scored 100%
- AAP floor calc: calc-score.sh floor 8.6 -3.5 8 60 50.33 -> -$40.13, mechanical downside 179.73%, scored 100%
- PYPL floor calc: calc-score.sh floor 25.37 14.2 10 959 46.97 -> $37.57, downside 20.01%
- PYPL TBV cross-check: TBV/share $9.58, floor $37.57 > 2x TBV $19.16 -- flagged but expected for asset-light processor
- Existing holdings separated from new-capital decisions via explicit holding overlay for CPS, AAP, PYPL
- Litigation materiality assessment (PYPL): shareholder class action estimated exposure <5% of $44B market cap, classified SECONDARY. Prior scans applied unconditional litigation override; current methodology gates on materiality per analyst spec commit 613f0bd.
- Finding ZERO recommendable stocks is a valid outcome. Patience is an edge.

---
*Scan completed 2026-03-08 using EdenFinTech deep value turnaround methodology*
