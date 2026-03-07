# EdenFinTech Stock Scan -- 2026-03-07 (v3)

## Scan Parameters
- Universe: Specific tickers | Focus: CPS, AAP, DORM, PYPL | Stocks scanned: 4
- Date: 2026-03-07
- API: Financial Modeling Prep

## Executive Summary
- 0 stocks survived analysis out of 4
- DORM rejected at screening (not beaten down enough, CAGR fails hurdle)
- CPS rejected at analysis (negative equity caps probability at 50%, below 60% hard breakpoint)
- AAP rejected at analysis (trough FCF margins near zero produce 84%+ downside, uninvestable score)
- PYPL rejected at analysis (active litigation forces Legal risk type, epistemic confidence filter kills at 42% effective probability)
- **Finding zero recommendable stocks is a valid outcome. Patience is an edge.**

## Ranked Candidates

*None. All four candidates were rejected. See rejection details below.*

## Portfolio Impact
- Current positions: 10/12 | Available slots: 2
- CPS (~25%), AAP (~8%), PYPL (~11-20%) are ALL existing holdings
- Auto parts concentration: ~33% of portfolio (CPS + AAP)
- This scan does not change any existing position recommendations
- Existing holdings are governed by Step 8 sell rules, not this scan's rejection criteria
- Deployment recommendation: Scenario 1 (cash available for 2 slots) -- no candidates meet investment criteria. Hold cash or seek opportunities in other sectors.

## Rejected at Screening

| Ticker | Failed At | Reason |
|--------|-----------|--------|
| DORM | Step 1 (broken chart) | Only 34.3% off ATH ($169 ATH, ~$111 current). Needs 60%+ decline. Even aggressive CAGR estimate = 17.4%, well below 30% hurdle. |

## Rejected at Analysis

| Ticker | Failed At | Reason |
|--------|-----------|--------|
| CPS | Probability hard breakpoint | Negative equity (-$309M). Probability ceiling: 50% (negative equity cap from operating deterioration). Below 60% hard breakpoint. CAGR at realistic 3% FCF margin = 16.3%; even at heroic 5% margin = 37.8% but probability kills it. |
| AAP | Score / extreme downside | Trough FCF margins near zero/negative from 5yr FMP history. At 1% trough margin: downside = 84.3%, score = 21.07. At 0.5% margin: downside = 91.8%. Extreme downside makes any reasonable score fall below 45 investability threshold. |
| PYPL | Epistemic confidence filter | Base probability 60% (CEO tenure <1yr ceiling caps at 65%, banded to 60%). Active class-action lawsuits force Legal/Investigation risk type (per active litigation override rule). Raw PCS confidence: 4/5 (1 "No"). Risk-type friction: Legal/Investigation = -2. Adjusted confidence: max(1, 4-2) = 2/5. Multiplier: x0.70. Effective probability: 60% x 0.70 = 42%, below 60% threshold. |

### Detailed Rejection Analysis

#### CPS -- Cooper-Standard Holdings

- **Pre-rejection metrics:** CAGR 16.3-37.8% (range depends on FCF margin assumption) | Prob: 50% (capped)
- **Why it fails:** CPS has negative equity of -$309M from cumulative operating losses (5 consecutive years of net losses). This is NOT spinoff leverage -- it represents genuine operating deterioration. The 60% probability ceiling for negative equity applies, but the analyst assessment is even lower: 50% band.
- **ROIC:** Median 1.56% over 5 years -- capital destruction, not creation.
- **FCF margin reality:** Best 5yr FCF margin was ~3%. Achieving the 5% needed for 30%+ CAGR would be unprecedented for CPS.
- **Solvency concern:** High leverage with negative tangible book value. Debt refinancing risk is material.
- **What would change this:** Sustained margin recovery to 5%+ FCF margin AND equity turning positive through retained earnings. Likely 2+ years away at minimum.

#### AAP -- Advance Auto Parts

- **Pre-rejection metrics:** CAGR ~33.8% | Downside: 84%+ | Prob: 60%
- **Why it fails:** Even at a generous 60% probability, the extreme downside from margin collapse produces a score of ~21 -- far below the 45 investability threshold. AAP's trough FCF margins from FMP history are near zero or negative.
- **Margin collapse:** Recent restructuring and competitive pressure from O'Reilly and AutoZone have compressed margins to levels that make the floor price nearly zero.
- **Floor analysis:** At 1% trough FCF margin (above actual trough), floor = ~$6.42 on a ~$40 stock = 84% downside. This makes AAP's risk/reward asymmetry deeply unfavorable.
- **What would change this:** Clear evidence of margin recovery to 3%+ FCF margin, which would bring downside to manageable levels. New CEO Shane O'Kelly needs 2-3 quarters of execution proof.

#### PYPL -- PayPal Holdings

- **Pre-rejection metrics (pre-epistemic):** Score ~54.1 | CAGR 30.68% | Downside 36.62% | Prob 60%
- **Thesis:** PayPal trades ~60% below ATH with a dominant two-sided payments network (400M+ accounts, 35M+ merchants). New CEO Enrique Lores (appointed March 1, 2026, ex-HP CEO) inherits a platform with $30B+ revenue and improving margins. Turnaround depends on Lores executing a coherent strategy pivot.
- **Why it fails:** Active securities fraud class-action lawsuits (class period Feb 2025 - Feb 2026) trigger the active litigation override, forcing Legal/Investigation risk classification. This applies -2 friction to PCS confidence, dropping effective probability to 42% (below 60% hard cap).
- **Epistemic Confidence Assessment:**
  - Q1 (Operational risk?): **No** -- Dominant risk is active securities fraud litigation and CEO instability, not operational execution. Evidence: Gemini search confirmed class-action lawsuits filed, CEO departure Feb 2026.
  - Q2 (Regulatory discretion minimal?): **Yes** -- Payment processing is well-regulated but stable; no SEC investigation or regulatory enforcement identified. Evidence: Gemini search found no regulatory actions.
  - Q3 (Historical precedent?): **Yes** -- Credit services turnaround base rate ~80%; PYPL itself recovered from eBay spinoff uncertainty 2015-2017. Evidence: Sector knowledge credit-services.md, 4 of 5 precedents recovered.
  - Q4 (Non-binary outcome?): **Yes** -- Gradient of outcomes available: partial margin recovery, slower growth, Venmo optionality. Evidence: FMP data: $30B+ revenue base with multiple business lines.
  - Q5 (Macro/geo limited?): **Yes** -- Primarily company-specific thesis. Evidence: Global diversification, e-commerce secular trend.
  - **"No" count:** 1 -- Raw confidence: 4/5
  - **Risk-type friction:** Legal/Investigation (active litigation override) -- friction -2 (raw 4/5 -> adjusted 2/5)
  - **Effective probability:** 60% x 0.70 = 42%
  - **Threshold proximity warning:** Base probability AT the 60% hard cap -- review for threshold anchoring. The 60% base probability is itself a ceiling-constrained value (CEO tenure <1yr caps at 65%, banded to 60%). Even without the epistemic filter, this probability reflects low conviction.
- **Human Judgment Flags:**
  - Enrique Lores (ex-HP CEO) track record at HP is mixed (cost-cutting focus, not growth). Fintech domain expertise unclear.
  - Class-action lawsuit outcome timeline and potential settlement amounts are unknowable from public data.
  - Whether Lores will retain or rebuild PayPal's product leadership team is not yet observable.
- **What would change this:** (1) Lawsuit settlement or dismissal removing the litigation overhang. (2) Lores demonstrating fintech strategic vision (expect H2 2026 at earliest). (3) 6+ months of CEO tenure to lift the probability ceiling. Realistically, re-evaluate Q4 2026 at earliest.

## Methodology Notes
- Qualitative assessments (moats, management, probability) are LLM estimates -- review critically
- Valuation multiples involve judgment -- verify reasoning matches your own assessment
- Catalyst timelines are estimates based on public information as of scan date
- All scoring math computed via calc-score.sh (deterministic, not LLM-generated)
- Epistemic confidence assessed independently -- reviewer never sees analyst probability or score
- PCS answers are evidence-anchored -- each answer cites a source or declares NO_EVIDENCE
- Risk-type friction applied: PYPL classified Legal/Investigation per active litigation override (friction -2)
- Threshold proximity warning: PYPL base probability 60% is AT the 60% hard cap
- Active litigation override rule: class-action lawsuits force Legal/Investigation risk classification regardless of other factors
- Note: Steps 3-4 audit, downside compliance audit, and multiple consistency audit were not fully executed because no candidates survived to the scoring stage. CPS and AAP failed at hard breakpoints (probability, downside); DORM failed at screening; PYPL's pre-epistemic analysis was completed but the epistemic filter rejected it before final report compilation.
- This is the third scan of these tickers on 2026-03-07. All three scans produced zero survivors, confirming methodology consistency.

---
*Scan completed 2026-03-07 using EdenFinTech deep value turnaround methodology*
