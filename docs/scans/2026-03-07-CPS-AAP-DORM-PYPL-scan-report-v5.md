# EdenFinTech Stock Scan — CPS, AAP, DORM, PYPL -- 2026-03-07 (v5)

## Scan Parameters
- Universe: Specific tickers | Focus: CPS, AAP, DORM, PYPL | Stocks scanned: 4
- Date: 2026-03-07
- API: Financial Modeling Prep

## Executive Summary
- 0 stocks survived analysis out of 4 scanned. No investable candidates at current prices.
- DORM eliminated at Step 1 (only 34% off ATH vs 60% required). CPS and AAP eliminated by 100% mechanical downside (negative trough FCF margins) and sub-30% CAGR. PYPL eliminated by epistemic confidence filter (confidence 1/5 due to CEO instability, active litigation, and regulatory risk).
- Key finding: CPS and AAP both have negative historical FCF margins in their 5yr trough, producing $0 mechanical floors. Neither currently meets the methodology's minimum investability requirements despite ongoing turnaround narratives.
- PYPL has the strongest fundamentals ($5.6B FCF, growing revenue) but governance dysfunction (3 CEOs in 3 years) and active litigation create unacceptably high epistemic uncertainty.

## Ranked Candidates

*None.* No stock achieved a passing score after full analysis.

## Portfolio Impact
- Current positions: 10/12 | Available slots: 2
- CPS (~25% weight), AAP (~8%), PYPL (~11-20%) are all current holdings that failed this scan
- This scan does NOT trigger sell signals for existing holdings — scan rejection means 'do not add new capital', not 'sell existing position'. Existing positions are governed by Step 8 holding reviews.
- Auto parts concentration (~33%) remains elevated. Both CPS and AAP showing 100% mechanical downside is a portfolio-level risk signal worth monitoring.
- PYPL holding review (2026-03-07) recommended HOLD_AND_MONITOR with mid-2026 deadline for CEO Lores to show credible strategy. This scan's epistemic confidence result (1/5) reinforces that timeline.
- CPS holding review (2026-03-07) recommended HOLD. Target needs revision from $193 to ~$62-75 (25-33% CAGR from current $32).
- Deployment recommendation: Scenario 1 applies (2 slots available with cash). No new candidates identified. Hold cash for better opportunities.

## Rejected at Screening
| Ticker | Failed At | Reason |
|---|---|---|
| DORM | Step 1 — Broken Chart | Only 34.3% off ATH ($166.92 ATH vs $109.33 current). Needs 60%+ decline to qualify. Dorman is a quality auto parts company but not beaten down enough. |

## Rejected at Analysis Detail Packets

### CPS
- Rejection reason: Multiple failures: (1) Base case CAGR 25.1% below 30% hurdle, (2) Base probability 50% below 60% hard cap, (3) 100% mechanical downside (negative trough FCF margins), (4) Score 1.27 below 45 watchlist threshold. Does not qualify for 20% CAGR exception (CEO not top-tier, runway <6yr).

### AAP
- Rejection reason: Multiple failures: (1) Conservative base case CAGR 21.4% below 30% hurdle, (2) Base probability 50% below 60% hard cap, (3) 100% mechanical downside (negative trough FCF margins), (4) Score 0.71-2.88 below 45 watchlist threshold. Does not qualify for 20% CAGR exception (runway <6yr).

### PYPL
- Rejection reason: Epistemic confidence filter: base 60% x 0.50 multiplier = 30% effective probability, below 60% threshold. Confidence 1/5 (3 No answers + Legal/Investigation friction -2). Score drops from 48.92 (pre-epistemic) to 36.92. Position size 0% (confidence 1 = watchlist only).

## Current Holding Overlays

### CPS
- Status in scan: REJECTED_AT_ANALYSIS
- New capital decision: DO_NOT_ADD
- Existing position action: HOLD_AND_MONITOR
- Reason: 100% mechanical downside and 50% probability reject new capital. However, existing position (avg cost ~$14) has different risk profile — already up >100%. Holding review (2026-03-07) recommended HOLD. Monitor FCF margin trajectory toward 3%+ target and equity recovery. Consider Step 8 review if margins stall.

### AAP
- Status in scan: REJECTED_AT_ANALYSIS
- New capital decision: DO_NOT_ADD
- Existing position action: HOLD_AND_MONITOR
- Reason: 100% mechanical downside and 50% probability reject new capital. Existing position (avg cost ~$40.61) is currently +24% but restructuring execution is unproven. FCF has been negative 2 of 3 years. Monitor FY2026 quarterly results for FCF inflection. If FCF remains negative through Q2 FY2026, trigger Step 8 review.

### PYPL
- Status in scan: REJECTED_AT_ANALYSIS
- New capital decision: DO_NOT_ADD
- Existing position action: HOLD_AND_MONITOR
- Reason: Epistemic confidence filter (1/5) rejects new capital. Existing position (avg cost $41.10) is approximately breakeven. Holding review (2026-03-07) recommended HOLD_AND_MONITOR with mid-2026 deadline for Lores to show credible strategy. This scan reinforces that timeline — if no strategic clarity by mid-2026, downgrade to EXIT consideration.

## Methodology Notes
- Qualitative assessments (moats, management, probability) are LLM estimates — review critically
- Valuation multiples involve judgment — verify reasoning matches your own assessment
- Catalyst timelines are estimates based on public information as of scan date
- All scoring math computed via calc-score.sh (deterministic, not LLM-generated)
- Epistemic confidence assessed independently — reviewer approach applied without seeing probability or score
- PCS answers are evidence-anchored — each answer cites a source or declares NO_EVIDENCE
- Risk-type friction applied: PYPL Legal/Investigation -> -2 (raw 2/5 -> adjusted 1/5)
- Threshold proximity warning: PYPL base probability 60% is AT the 60% hard cap
- Downside methodology audited: floor calc present for all candidates, negative trough margins produce $0 floors for CPS and AAP, TBV cross-check complete for PYPL (2.65x flag noted, acceptable for asset-light)
- Calibration rules checked: no exceptions triggered (growth_revenue_bound: PYPL CAGR 9.2% < 15% threshold; margin_outlier: all gaps <8pp)
- No multiple consistency audit needed — no ranked candidates
- Sector knowledge consulted: auto-parts (hydrated 2026-03-07), credit-services (hydrated 2026-03-07)
- Finding ZERO recommendable stocks is a valid and valuable outcome. Patience is an edge.

- Execution log: `data/scans/2026-03-07-CPS-AAP-DORM-PYPL-execution-log-v5.md`

---
*Scan completed 2026-03-07 using EdenFinTech deep value turnaround methodology*
