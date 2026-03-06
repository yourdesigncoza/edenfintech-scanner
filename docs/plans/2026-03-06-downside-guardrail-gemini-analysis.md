# Downside Estimation Guardrail — Gemini Analysis

Date: 2026-03-06
Input: `docs/plans/2026-03-06-downside-estimation-guardrail.md`

---

## 1. Is the problem diagnosis correct?

**Yes, the diagnosis is correct and likely the primary driver of variance.**

In expected value scoring models, Downside Estimation is usually the most sensitive input variable because it represents the "ruin risk." Most successful investors (Soros, Buffett, Klarman) focus on downside protection first. By weighting it at 45%, the formula correctly prioritizes capital preservation.

However, the mathematical leverage of that 45% weight means small variances in input create massive variances in output.

- **The BRBR Example:** The difference between a 12% downside and a 42% downside isn't just a "difference of opinion"; in a scoring model, it is the difference between a "Strong Buy" and a "Hard Pass."
- **The Root Cause:** LLMs (and human analysts) suffer from "recency bias" and "context window drift." Without a structural anchor, the LLM hallucinates a downside based on the *tone* of the earnings call rather than the *math* of the balance sheet.

**Conclusion:** You cannot have a quantitative scoring system if your heaviest variable is qualitative. The variance is structural, not incidental.

## 2. Is anchoring to historical troughs the right approach?

**It is the correct *starting point*, but for Deep Value/Turnaround strategies, it is insufficient on its own.**

**The Risks of "Historical Trough" Floors:**

1. **Regime Change:** A company might have traded at a trough of 15x P/E during the zero-interest-rate policy (ZIRP) era. In a 5% rate environment, the new structural floor might be 10x. Anchoring to the last 10 years of data might artificially inflate the floor.
2. **The "Value Trap" Risk:** In a turnaround scenario, the business fundamentals are often deteriorating. Historical multiples applied to *shrinking* earnings will yield a price target that is still too high. The floor must account for the degradation of the "E" (Earnings) or "FCF" (Free Cash Flow), not just the "P" (Price multiple).
3. **Balance Sheet Ignorance:** Historical multiples ignore debt. If a company has taken on massive leverage, the equity value can go to zero even if the Enterprise Value (EV) multiple stays constant.

**The Verdict:** Mechanical anchoring is necessary to stop the hallucination, but you need a "Safety Valve" for structural impairment (bankruptcy risk).

## 3. Recommended Anchoring Methods for Turnaround Context

For a turnaround strategy, you want to identify the price at which the asset is cheap *even if the turnaround fails*. Implement a **"Waterfall" of Floors**, ranked by severity.

### Level 1: The "Stumble" Floor (Operational Cyclicality)

- **Method:** Trough Margin x Trough Multiple.
- **Logic:** Take the lowest FCF margin the company has achieved in 10 years and apply it to current revenue. Then, apply the lowest multiple the stock has traded at in 10 years.
- **Use case:** Good for "good companies in bad neighborhoods" (sector rotations).

### Level 2: The "Broken" Floor (Asset Backing)

- **Method:** Tangible Book Value (TBV) or Net Current Asset Value (NCAV).
- **Logic:** If the earnings power disappears, what are the hard assets worth?
- **Implementation:** `Hard Floor = Tangible Assets - Total Liabilities`.
- **Use case:** Essential for the PYPL/BRBR examples. If the market cap approaches TBV, the downside is structurally limited unless they are burning cash.

### Level 3: The "Zero Growth" Floor (Perpetuity)

- **Method:** No-Growth Perpetuity Formula.
- **Logic:** `Floor Price = Current FCF / Cost of Equity (e.g., 10-12%)`.
- **Meaning:** This calculates the value of the company if it never grows another dollar. This effectively strips out all "speculative value" (the Turnaround Upside) and leaves only the "utility value."

**Recommendation:** Force the Analyst/LLM to calculate all three, and set the Base Downside to the *lowest* of the three. This is the definition of "Conservatism."

## 4. Blind Spots and Risks

The discussion misses two critical factors that define downside in turnarounds:

### The Leverage Multiplier (The "Equity Bridge")

- The discussion uses Price Targets and P/FCF. It does not mention **Net Debt**.
- **Risk:** A 20% drop in Enterprise Value for a highly levered firm can result in an 80% drop in Equity Value.
- **Fix:** The downside calculation *must* use Enterprise Value (EV) for the multiple logic, subtract Net Debt, and then divide by shares. A simple "P/E floor" ignores leverage risk.

### Dilution Risk

- Turnaround candidates often need cash.
- **Risk:** The stock price might drop 20%, but if they issue 20% more shares, the *value per share* drops 40%.
- **Fix:** The "Reasonable Worst Case" must include a "Dilution Factor" if the company has low cash reserves (e.g., Cash < 1yr of OpEx).

## 5. Implementation: Mechanical vs. Semi-Structured

**Do NOT make it fully mechanical.** Turnarounds often involve idiosyncratic risks (lawsuits, like BRBR) that historical data cannot see.

### The "Guardrails + Override" Model

**Step 1: The Calculator (Mechanical)**
- `calc-score.sh` (or a python script) computes the "Historical Trough Floor" and "Tangible Book Floor."
- This establishes the **Default Downside**.

**Step 2: The Analyst Review (Semi-Structured)**
- The LLM Analyst is presented with the Default Downside.
- *Prompt Instruction:* "The historical data suggests a floor of $30. Does this company face specific existential risks (lawsuits, fraud, debt covenants) that would invalidate history?"
- **Constraint:** If the Analyst wants to set a downside *lower* than the mechanical floor (more pessimistic), they can do so freely (e.g., BRBR lawsuit risk).
- **Constraint:** If the Analyst wants to set a downside *higher* than the mechanical floor (more optimistic), they trigger a **"Heroic Assumption" flag** which penalizes the score or requires a specific "Variance Justification."

### Expected Impact

- **BRBR with new system:** The mechanical scan sees the lawsuit risk is not in the financial history. The "Default Floor" might be $40 (based on 16x FCF). The Analyst sees the lawsuit and overrides it to $35.
- **Result:** Variance drops from 17 points to perhaps 3-5 points, and the decision remains stable.

---

*Analysis by Gemini (gemini-analyze-document), 2026-03-06*
