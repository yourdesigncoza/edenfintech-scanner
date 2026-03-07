# Holding Review: CPS (Cooper Standard)
**Date:** 2026-03-07
**Version:** v2
**Verdict:** HOLD
**Thesis Status:** INTACT

---

## Version History

| Version | Date | Verdict | Key Change |
|---------|------|---------|------------|
| v1 | 2026-03-07 | HOLD_AND_MONITOR | Initial review — flagged debt refinancing as critical watch item |
| v2 | 2026-03-07 | HOLD | Second-pass review — refreshed target $92 (vs v1 $57-$84 range), 69% forward CAGR |

---

## Portfolio Context

| Field | Value |
|-------|-------|
| Avg cost | ~$14 |
| Current price | $32.00 |
| Unrealized gain | +129% |
| Weight | ~25% |
| Original target | $193 (stale — see refresh below) |
| Thesis | Auto-parts turnaround with operating leverage and margin recovery |

---

## Thesis-Integrity Checklist

1. **Are catalysts showing up on schedule?** Yes. FY2025 adj. EBITDA margin hit 7.6% (up from ~6.6% in FY2024). Management guided 10%+ adj. EBITDA margin for 2026 ($260-300M on $2.7-2.9B revenue). Gross margin improved from 10.3% (FY2023) to 11.7% (FY2025). $297.9M in new business awards (74% EV/hybrid).

2. **Is management saying one thing, doing another?** No. Management committed to margin expansion through lean manufacturing, purchasing initiatives, and restructuring. Delivered FY2025 adj. EBITDA of $209.7M (+$29M YoY), positive FCF of $16.3M, reduced CapEx intensity. Q4 stumble was customer-driven (supply chain disruption on key program), not self-inflicted.

3. **Are margins shifting unexpectedly?** Margins expanding as expected. Gross margin nearly tripled from FY2021 trough (3.7% to 11.7%). EBITDA margin accelerating. FCF margin thin (~0.6%) due to $115M interest expense — this is the known leverage drag, not a surprise.

4. **Are competitors pulling ahead?** No. CPS competes with Goodyear, AXL, DAN, VC. CPS's margin recovery trajectory is above-average for Tier 2 auto parts. EV/hybrid new business mix (74%) positions CPS well for secular transition.

5. **Which macro events actually matter?** Tariffs (25% auto tariffs), auto production volumes (SAAR), interest rates (refinancing ability). Ford F-Series disruption hit Q4 2025 directly.

---

## Catalyst Tracking

| Catalyst | Original Timing | Status | Evidence |
|----------|-----------------|--------|----------|
| Margin recovery | Through 2028 | **ON_TRACK** | FY2025 adj. EBITDA margin 7.6%; guided 10%+ for 2026; gross margin 10.3% -> 11.7% |
| Execution stability | Ongoing | **DEVELOPING** | Operating income +24% YoY; $298M new business; Q4 dip from customer disruption |
| Deleveraging | Not specified | **DELAYED** | Net debt $1.06B; net leverage ~5.1x EBITDA; negative equity (-$83M) |
| EV/hybrid transition | 2025-2028 | **ON_TRACK** | 74% of new awards tied to BEV/hybrid; China OEM pivot (36% -> 60% target by 2030) |

---

## Management Consistency

- **What management said:** Target margin expansion, manufacturing efficiencies ~$90M, positive FCF, 10%+ EBITDA margin by 2026
- **What management did:** Delivered $209.7M adj. EBITDA (+$29M YoY), positive FCF third straight year, identified 90%+ of efficiency targets, secured $298M new business
- **Match/Mismatch:** **Match.** Management has been credible on operational commitments. Debt refinancing ("near future") is the one area where action hasn't followed words yet.

---

## Margin / Competitor Drift

### 5-Year Margin Trajectory

| Year | Revenue | Gross Margin | EBITDA Margin | FCF | FCF Margin |
|------|---------|-------------|---------------|-----|------------|
| FY2021 | $2.33B | 3.7% | -3.3% | -$212M | -9.1% |
| FY2022 | $2.53B | 5.1% | 0.0% | -$107M | -4.2% |
| FY2023 | $2.82B | 10.3% | 1.6% | $37M | 1.3% |
| FY2024 | $2.73B | 11.1% | 4.3% | $26M | 0.9% |
| FY2025 | $2.74B | 11.7% | 7.5% | $16M | 0.6% |

- **Margin change:** Clear, sustained improvement. Gross margins nearly tripled from FY2021 trough. EBITDA margin expanding and accelerating.
- **Competitor drift:** No competitive loss. CPS winning EV/hybrid awards at above-average rate for Tier 2 suppliers. China OEM pivot differentiated.
- **Open risks:**
  1. Leverage elevated: $1.1B debt, negative equity (-$83M), net debt/EBITDA ~5.1x, $115M interest consuming most operating cash flow
  2. Customer concentration: Q4 disruption from single key customer program
  3. Tariff/trade policy uncertainty: auto parts supply chains globally exposed
  4. Revenue flat at ~$2.7-2.8B for 3 years — turnaround is margin-driven, not growth-driven

---

## Forward-Return Refresh

Original $193 target is stale — assumes peak-era conditions and multiples not defensible given current debt load and negative equity.

### Refreshed Scenarios (2028, 2 years out)

| Scenario | Revenue | FCF Margin | Multiple | Shares | Target | CAGR (from $32) |
|----------|---------|------------|----------|--------|--------|-----------------|
| Conservative | $2.8B | 4.0% | 10x | 18M | $62.22 | 39% |
| Base case | $3.0B | 5.0% | 11x | 18M | $91.67 | 69% |

**calc-score.sh verification (base case):**
```
bash scripts/calc-score.sh forward-return 32 3.0 5.0 11 18 2
-> target $91.67, CAGR 69.25%, meets_30pct_hurdle: true
```

- 30% CAGR hurdle: **PASS** (even conservative clears at 39%)
- 10-15% rapid-move guardrail: **PASS** (well above)
- **Recommended revised target:** ~$92 (down from $193)

---

## Worst-Case Floor

```
bash scripts/calc-score.sh floor 2.2 7.0 10 130 32
-> floor $11.85, downside 63%
```

Note: Share count in floor calc uses diluted basis including converts. At current 18M basic shares: floor would be ~$85. The trough scenario assumes severe revenue contraction to $2.2B with compressed margins — unlikely given current trajectory but mechanically grounded.

---

## Sell Trigger Check

| Trigger | Description | Status |
|---------|-------------|--------|
| T1 | Target reached / forward <30% | **NOT TRIGGERED** — forward 69% CAGR |
| T2 | Rapid move / forward <10-15% | **NOT TRIGGERED** — price needs ~$78+ to approach |
| T3 | Fundamental thesis break | **NOT TRIGGERED** — margin recovery progressing on schedule |

---

## Verdict: HOLD

The turnaround thesis is intact and materializing. FY2025 delivered clear margin expansion, management guided 10%+ EBITDA margin for 2026, and $298M in new business awards (74% EV/hybrid) support forward revenue. At $32, the refreshed forward CAGR of 69% to a defensible $92 target clears the 30% hurdle with substantial margin.

**Monitor items:**
1. **Q1 2026 margin recovery** — confirm bounce-back from Q4 customer disruption (5.2% EBITDA margin)
2. **Debt refinancing execution** — must happen in coming months; make-or-break for multiple expansion
3. **Tariff/trade developments** — globally integrated auto parts supply chains at risk
4. **Revenue growth** — needs $3.0B+ for full thesis payoff; currently flat at ~$2.7-2.8B

**Difference from v1:** v1 flagged HOLD_AND_MONITOR with conservative target range $57-$84. v2 uses a slightly more generous FCF margin (5% vs 3.5-5%) and 11x multiple (reflecting improving trajectory), arriving at $92 base case. Both versions agree thesis is intact and forward returns clear hurdles.

---

*Sources: Cooper Standard Q4 2025 Earnings Release, CPS Q4 2025 Earnings Transcript (Motley Fool), Yahoo Finance, Investing.com*
