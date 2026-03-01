# ✅ GEMINI SECTOR EPISTEMIC RESEARCH PROMPT

---

You are conducting institutional-grade sector analysis.

Your objective is NOT to summarize the industry.

Your objective is to construct **sector-level epistemic priors** for use in a survival-first, probability-weighted capital allocation framework.

---

## TARGET SECTOR

**NAICS 522110 – Commercial Banking**

Subsegments:

* Retail Banking
* Commercial / Corporate Banking
* Regional Banks
* Community Banks

---

## REQUIRED OUTPUT FORMAT

Return output in STRICT structured markdown using the exact section headers below.

Do NOT write narrative fluff.

---

# 1️⃣ STRUCTURAL SECTOR CHARACTERISTICS

* Core revenue model:
* Capital intensity:
* Regulatory regime:
* Typical leverage structure:
* Cyclicality classification (Defensive / Cyclical / Highly Cyclical):
* Primary funding source:
* Margin drivers:
* Competitive dynamics:
* Switching costs:
* Concentration risk typical? (Low/Medium/High):

---

# 2️⃣ REGULATORY & POLITICAL RISK PROFILE

* Primary regulators:
* Regulatory discretion level (Low / Medium / High):
* Historical examples of regulatory intervention:
* Probability of rule change impacting profitability:
* Binary regulatory risk present? (Yes/No):
* Government backstop dependency:

---

# 3️⃣ MACRO SENSITIVITY

Rate sensitivity:
Credit cycle sensitivity:
Unemployment sensitivity:
Liquidity stress sensitivity:
Inflation exposure:
Yield curve dependency:
Deposit flight risk:

Classify overall macro dependency: Low / Moderate / High

---

# 4️⃣ HISTORICAL FAILURE PATTERNS

List documented causes of bank failures over last 40 years.

Separate into:

* Operational failures
* Liquidity failures
* Regulatory failures
* Fraud / governance failures
* Macro contagion events

For each, state whether failures were:

* Gradual deterioration
* Binary event

---

# 5️⃣ BINARY RISK TRIGGERS

Identify sector-specific binary events such as:

* Regulatory shutdown
* Capital call failure
* Liquidity run
* Rating downgrade spiral
* Counterparty collapse

Rate prevalence: Rare / Occasional / Structural

---

# 6️⃣ PRECEDENT STABILITY ANALYSIS

* Are sector downturns historically cyclical and recoverable?
* Or does structural impairment commonly occur?
* Average recovery time from sector crisis:
* Survivorship rate of publicly traded banks over 20 years:

Classify precedent reliability: Strong / Moderate / Weak

---

# 7️⃣ EPISTEMIC RISK CLASSIFICATION

Answer:

1. Is sector risk primarily operational (modelable)?
2. Is regulatory discretion material?
3. Are outcomes typically binary?
4. Are there strong historical precedents?
5. Is macro dependency dominant?

Count number of structural uncertainty dimensions.

Return:

* Epistemic Stability Score (1–5)
* Recommended Probability Confidence Multiplier
* Suggested Max Position Cap for sector exposure

---

# 8️⃣ SECTOR PRIOR TEMPLATE (JSON)

Return this exact JSON block at the end:

```json
{
  "sector": "Commercial Banking",
  "cyclicality": "",
  "regulatory_discretion": "",
  "binary_risk_level": "",
  "macro_dependency": "",
  "historical_precedent_strength": "",
  "epistemic_stability_score": "",
  "probability_confidence_multiplier": "",
  "sector_position_cap": ""
}
```

---

# IMPORTANT

Do not speculate.
Use historical evidence.
Flag areas of uncertainty explicitly.
Distinguish between quantifiable risk and discretionary/political risk.

The goal is to build a reusable sector-level epistemic prior that will later influence ticker-level probability adjustments and position caps.

---

# 🎯 Why This Prompt Works

This forces Gemini to:

* Classify risk types
* Separate binary vs gradual failure modes
* Quantify regulatory discretion
* Build priors usable across JPM, BAC, regional banks, etc.
* Produce structured machine-readable output

You are no longer researching a stock.

You are researching the **risk physics of the sector**.
