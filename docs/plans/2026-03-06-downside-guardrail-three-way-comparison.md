# Downside Estimation Guardrail — Three-Way Comparison

Date: 2026-03-06
Sources:
- Our discussion: `docs/plans/2026-03-06-downside-estimation-guardrail.md`
- Gemini analysis: `docs/plans/2026-03-06-downside-guardrail-gemini-analysis.md`
- GPT operational spec: `docs/plans/2026-03-06-downside-guardrail-chatgpt.md`

---

## Side-by-Side Comparison

| Aspect | Our Discussion | Gemini | GPT |
|--------|---------------|--------|-----|
| **Focus** | Problem diagnosis | Investment theory | Implementation spec |
| **Floor methods** | "Anchor to historical troughs" | 3-level waterfall (Stumble/Broken/Zero Growth) | 4 methods with selection logic |
| **Override model** | Not designed yet | Asymmetric (pessimism free, optimism flagged) | Event-risk override with explicit triggers |
| **Cross-check** | Not considered | Not considered | Mandatory secondary method + flag thresholds |
| **Variance control** | Identified the problem | Estimated 17pt -> 3-5pt improvement | Explicit thresholds (10pp or 20% divergence) |
| **Output format** | Not specified | Not specified | Full JSON schema |
| **Leverage/EV** | Not considered | Flagged as blind spot | Not explicitly addressed |
| **Dilution** | Not considered | Flagged as blind spot | Share count rules (no aggressive buybacks in worst case) |
| **Prohibited practices** | Not specified | Not specified | Explicit rejection criteria |

---

## What Each Perspective Uniquely Contributes

### Our Discussion
- Identified the root cause: 45%-weighted input with zero structural constraints
- Mapped the contrast with probability (heavily constrained) and CAGR (mechanical)
- Provided the evidence base: BRBR 12% vs 42%, PYPL's accidental good practice, three-scan comparison report

### Gemini Adds
- **Leverage multiplier (Equity Bridge)**: Must use Enterprise Value for multiple logic, subtract Net Debt, then divide by shares. A 20% EV drop on a leveraged company = 80% equity drop. Our P/FCF approach ignores this.
- **No-Growth Perpetuity floor**: `Floor Price = Current FCF / Cost of Equity (10-12%)`. Strips out all speculative turnaround value, leaves only utility value. Simple, powerful, computable from FMP data.
- **Asymmetric override rule**: Analyst can make the floor *worse* than the mechanical calculation freely. Making it *better* (more optimistic) triggers a heroic assumption flag. Prevents optimism bias while allowing legitimate pessimism.
- **Regime change warning**: Historical trough multiples from ZIRP era may be too high for current rate environment.
- **Value trap risk**: Historical multiples applied to *shrinking* earnings still overstate the floor.

### GPT Adds
- **Mandatory cross-check**: Every downside must use a primary method + secondary cross-check. Flag if they diverge >10 percentage points or >20% floor price difference. This directly solves the BRBR variance problem.
- **Prohibited practices list**: Reject if narrative-only, floor method missing, multiple unsupported, or margin collapse unanchored. Gives the orchestrator hard rejection criteria.
- **Structured JSON output schema**: Forces the analyst to declare method, assumptions, compliance status, and method selection reason. Makes variance auditable.
- **Method selection reason**: Analyst must explain *why* they chose that floor method, not just show the math.
- **Variance control rule**: Same stock, same day = flag if >10pp downside difference or >20% floor price difference. Classify as `analyst_variability`, not genuine signal.
- **Share count discipline**: No aggressive buybacks assumed in worst case. Use current diluted count. Increase if dilution risk, buyback pause, or capital stress exists.

---

## The Best Design Would Combine

### From GPT (operational structure):
1. Four floor methods with explicit selection logic and priority order
2. Mandatory primary + secondary cross-check with divergence thresholds
3. Prohibited practices list with hard rejection criteria
4. Structured JSON output schema for auditability
5. Variance control rule for cross-scan consistency
6. Method selection reason requirement

### From Gemini (investment methodology):
1. EV-based math: use Enterprise Value, subtract Net Debt, divide by shares (not simple P/FCF)
2. No-Growth Perpetuity as a floor method: `Current FCF / Cost of Equity`
3. Asymmetric override: pessimism free, optimism flagged (not binary on/off)
4. Dilution factor: if Cash < 1yr OpEx, worst case must include dilution assumption
5. Regime change awareness: rate-adjust historical trough multiples

### From Our Discussion (problem framing):
1. The evidence base showing 17-point score gaps from downside variance alone
2. The contrast with how tightly probability and CAGR are already constrained
3. The PYPL example as a model of "good practice by accident" (historical trough anchoring)

---

## Open Questions for Design Phase

1. **Can calc-score.sh compute all three floors mechanically?** Trough multiple and tangible book are in FMP data. No-growth perpetuity needs a cost-of-equity assumption (use 10%? 12%?).
2. **EV-based math**: Should the entire valuation model shift to EV-based, or just the worst case? Changing the base case formula would be a larger refactor.
3. **Cross-check divergence**: GPT says flag at 10pp/20%. Is this the right threshold for turnaround stocks where uncertainty is inherently high?
4. **How does this interact with the existing Discount Schedule?** The base case already has a discount path. Should the worst case have its own discount schedule, or is the floor method sufficient?
5. **Implementation priority**: Add to calc-score.sh first (mechanical floors), then update analyst.md (structured output + cross-check), then update orchestrator.md (variance audit)?
