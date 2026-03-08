# Epistemic Data Contract — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Formalize the data contract between analyst, epistemic reviewer, and orchestrator so epistemic data flows deterministically through the pipeline with consistent rendering.

**Architecture:** Define a canonical JSON shape for epistemic data. Update the epistemic reviewer to output structured JSON (not markdown tables). Update the orchestrator to pass risk type to the reviewer and consume structured output. Update the renderer to match.

**Tech Stack:** Markdown agent specs, JSON schema, Python renderer

**Review status:** Reviewed by Gemini (2026-03-08) and Codex (2026-03-08). All findings incorporated below.

---

## Problem Summary

The `2026-03-07` scan JSON (used as regression fixture — the only existing scan with real epistemic data) has `epistemic_confidence` structured as:
```json
{
  "q1_operational": { "answer": "Yes|No", "justification": "...", "evidence": "..." },
  "q2_regulatory": { ... },
  ...
  "no_count": <0-5>,
  "raw_confidence": <1-5>,
  "risk_type": "<canonical enum>",
  "risk_type_friction": <-2 to 0>,
  "adjusted_confidence": <1-5>,
  "multiplier": <0.50-1.00>,
  "effective_probability": <number>
}
```

But the renderer (`report_json.py:282`) looks for `checks[]` array. The epistemic reviewer spec says output markdown tables. The orchestrator prompt omits `Dominant Risk Type`. Nobody specifies who computes `risk_type_friction`, `adjusted_confidence`, or `effective_probability` — they just appear. The contract should be stock-agnostic; the fixture only proves the current renderer is broken.

---

## Task 1: Add `epistemic_confidence` to the JSON schema

**Files:**
- Modify: `schemas/scan-report.schema.json`

**Step 1: Add epistemic_confidence schema definition**

Add a reusable `$defs` block and reference it from both `ranked_candidates` items and `rejected_at_analysis_detail_packets` items:

```json
"$defs": {
  "pcs_check": {
    "type": "object",
    "required": ["answer", "justification", "evidence"],
    "properties": {
      "answer": { "type": "string", "enum": ["Yes", "No"] },
      "justification": { "type": "string" },
      "evidence": { "type": "string" }
    }
  },
  "epistemic_confidence": {
    "type": "object",
    "required": [
      "q1_operational", "q2_regulatory", "q3_precedent",
      "q4_nonbinary", "q5_macro",
      "no_count", "raw_confidence",
      "risk_type", "risk_type_friction",
      "adjusted_confidence", "multiplier",
      "effective_probability"
    ],
    "properties": {
      "q1_operational": { "$ref": "#/$defs/pcs_check" },
      "q2_regulatory": { "$ref": "#/$defs/pcs_check" },
      "q3_precedent": { "$ref": "#/$defs/pcs_check" },
      "q4_nonbinary": { "$ref": "#/$defs/pcs_check" },
      "q5_macro": { "$ref": "#/$defs/pcs_check" },
      "no_count": { "type": "integer", "minimum": 0, "maximum": 5 },
      "raw_confidence": { "type": "integer", "minimum": 1, "maximum": 5 },
      "risk_type": {
        "type": "string",
        "enum": [
          "Operational/Financial",
          "Cyclical/Macro",
          "Regulatory/Political",
          "Legal/Investigation",
          "Structural fragility (SPOF)"
        ]
      },
      "risk_type_friction": { "type": "integer", "minimum": -2, "maximum": 0 },
      "friction_note": { "type": "string" },
      "adjusted_confidence": { "type": "integer", "minimum": 1, "maximum": 5 },
      "multiplier": { "type": "number" },
      "effective_probability": { "type": "number" },
      "confidence_cap_pct": { "type": ["number", "null"] },
      "binary_override": { "type": "boolean" },
      "threshold_proximity_warning": { "type": ["string", "null"] },
      "human_judgment_flags": {
        "type": "array",
        "items": { "type": "string" }
      }
    }
  }
}
```

**Step 2: Commit**

```bash
git add schemas/scan-report.schema.json
git commit -m "feat: add epistemic_confidence schema definition to scan report"
```

---

## Task 2: Update the scan report template with epistemic fields

**Files:**
- Modify: `schemas/scan-report.template.json`

**Step 1: Add epistemic_confidence template block**

Add an `epistemic_confidence` field to the template showing the expected shape for candidates. This goes inside a candidate object example or as a top-level reference block.

**Step 2: Commit**

```bash
git add schemas/scan-report.template.json
git commit -m "feat: add epistemic_confidence template block to scan report template"
```

---

## Task 3: Update the epistemic reviewer to output structured JSON

**Files:**
- Modify: `.claude/agents/epistemic-reviewer.md:33-42` (Your Input section)
- Modify: `.claude/agents/epistemic-reviewer.md:97-122` (Output Format section)

**Step 1: Add `Dominant Risk Type` to the input spec**

In the "Your Input" section (line 35-42), add after "Moat assessment":
```markdown
- **Dominant Risk Type** — the analyst's classification of the dominant risk
  (Operational/Financial, Cyclical/Macro, Regulatory/Political,
  Legal/Investigation, or Structural fragility (SPOF))
```

This solves Inconsistency #1: the reviewer now receives risk type from the analyst.

**Step 2: Replace the Output Format section (lines 97-122)**

Replace the markdown-table output with structured JSON output. The reviewer outputs JSON per candidate that the orchestrator can parse mechanically:

```markdown
## Output Format

Return a JSON block for each candidate inside a markdown code fence:

~~~markdown
### {TICKER}

```json
{
  "ticker": "{TICKER}",
  "q1_operational": {
    "answer": "Yes|No",
    "justification": "1-line specific justification",
    "evidence": "source or NO_EVIDENCE"
  },
  "q2_regulatory": {
    "answer": "Yes|No",
    "justification": "1-line",
    "evidence": "source or NO_EVIDENCE"
  },
  "q3_precedent": {
    "answer": "Yes|No",
    "justification": "1-line",
    "evidence": "source or NO_EVIDENCE"
  },
  "q4_nonbinary": {
    "answer": "Yes|No",
    "justification": "1-line",
    "evidence": "source or NO_EVIDENCE"
  },
  "q5_macro": {
    "answer": "Yes|No",
    "justification": "1-line",
    "evidence": "source or NO_EVIDENCE"
  },
  "no_count": <n>,
  "raw_confidence": <1-5>,
  "risk_type_acknowledged": "{analyst's Dominant Risk Type}",
  "human_judgment_flags": ["flag1", "flag2"]
}
```

{If question 4 = No AND raw_confidence <= 3: "**Binary outcome override applies** — max 5% position"}
~~~

**Key changes:**
- Reviewer outputs JSON, not markdown tables
- Reviewer echoes `risk_type_acknowledged` (the analyst's classification) — does NOT compute friction (that's the orchestrator's job)
- `no_count` and `raw_confidence` are computed by the reviewer
- `human_judgment_flags` replaces the freeform text block
- Reviewer still does NOT see probability, score, or position size
- **Q3 named precedent rule** (Gemini finding): Add explicit instruction to the Q3 question definition in the reviewer spec: "Answer 'Yes' to Q3 ONLY if you can cite a specific, named historical precedent in the evidence field. If no named precedent exists, answer 'No'." This ensures the boolean check in the orchestrator's friction override table is semantically valid.
```

**Step 3: Commit**

```bash
git add .claude/agents/epistemic-reviewer.md
git commit -m "feat: epistemic reviewer outputs structured JSON with risk type input"
```

---

## Task 4: Update orchestrator to pass risk type and consume structured JSON

**Files:**
- Modify: `.claude/agents/orchestrator.md:244-253` (epistemic reviewer prompt)
- Modify: `.claude/agents/orchestrator.md:256-269` (risk-type friction application)
- Modify: `.claude/agents/orchestrator.md:271-300` (effective probability and scoring)

**Step 1: Add Dominant Risk Type to the epistemic reviewer prompt**

Replace lines 244-253 (the prompt template) to include the analyst's risk type:

```markdown
Assess epistemic confidence for these candidates:

{For each candidate:}
### {TICKER} — {Industry}
- Thesis: {2-3 sentence summary from analyst's Epistemic Input section}
- Key Risks: {risk list}
- Catalysts: {catalyst list with timelines}
- Moat Assessment: {moat summary}
- Dominant Risk Type: {from analyst's Epistemic Input — must be one of the 5 canonical types}

Return the structured confidence assessment for all candidates."
```

**Step 1b: Add risk type normalization and reviewer output validation** (Gemini finding #3, Codex finding #3)

Before consuming reviewer output, the orchestrator must:

```markdown
3a. **Parse and validate epistemic reviewer output**:
   - Extract JSON from markdown code fences (```json ... ```)
   - For each candidate, validate required keys: `ticker`, `q1_operational` through `q5_macro`, `no_count`, `raw_confidence`, `risk_type_acknowledged`, `human_judgment_flags`
   - Each PCS check (`q1`-`q5`) must have `answer` (Yes|No), `justification`, and `evidence`
   - **If reviewer output is malformed** (unparseable JSON, missing required keys, ticker mismatch, or extra prose corrupting the fence):
     - Log: `"epistemic_review_failed: {reason}"`
     - **Do NOT silently skip** — reject the candidate with reason: `"epistemic review parse failure: {reason}"`
     - This is a pipeline error, not a soft degradation. The candidate cannot proceed without valid epistemic assessment.

   - **Normalize `risk_type_acknowledged`** against the canonical enum:
     - Exact match → use as-is
     - Common variants → map: "Cyclical" | "Cyclical & Macro" → "Cyclical/Macro", "Regulatory" → "Regulatory/Political", "Legal" → "Legal/Investigation", "SPOF" → "Structural fragility (SPOF)"
     - If no match after normalization → flag as `"risk_type_mismatch"` in `human_judgment_flags` and use analyst's original `Dominant Risk Type` for friction lookup
```

**Step 2: Formalize the friction computation as deterministic rules**

Replace the vague "use the lower end of friction ranges" (line 268) with explicit rules:

```markdown
3b. **Apply risk-type friction** (deterministic rules):
   - Read each candidate's `Dominant Risk Type` from the analyst's Epistemic Input
   - Verify the epistemic reviewer's `risk_type_acknowledged` matches
   - Look up friction and apply conditional override:

   | Risk Type | Default Friction | Override Condition | Overridden Friction |
   |-----------|------------------|--------------------|---------------------|
   | Operational/Financial | 0 | — | — |
   | Cyclical/Macro | -1 | Q3=Yes with named precedent | 0 |
   | Regulatory/Political | -2 | Q2=Yes (stable regulatory environment) | -1 |
   | Legal/Investigation | -2 | — (no override) | — |
   | Structural fragility (SPOF) | -1 | — (also set binary flag) | — |

   - Compute: `adjusted_confidence = max(1, raw_confidence - abs(friction))`
   - Record: `friction_note` explaining why override did/didn't apply
```

**Step 3: Specify the orchestrator's assembly of the final epistemic_confidence object**

After computing friction and effective probability, the orchestrator assembles the canonical JSON object. Add explicit instructions:

```markdown
4. **Assemble the `epistemic_confidence` JSON object** for each candidate:
   - Copy the 5 PCS check objects (`q1_operational` through `q5_macro`) from reviewer output
   - Copy `no_count` and `raw_confidence` from reviewer output
   - Set `risk_type` from analyst's Dominant Risk Type
   - Set `risk_type_friction` from friction table lookup
   - Set `friction_note` with override explanation
   - Compute `adjusted_confidence = max(1, raw_confidence - abs(risk_type_friction))`
   - Look up `multiplier` from confidence-to-multiplier table
   - Compute `effective_probability` via: `bash scripts/calc-score.sh effective-prob {base_prob} {adjusted_confidence}`
   - Set `confidence_cap_pct` from confidence-to-size-cap table (null if confidence=5)
   - Set `binary_override` = true if Q4=No AND adjusted_confidence <= 3
   - Set `threshold_proximity_warning` from step 4c (null if none)
   - **Merge** `human_judgment_flags`: start with reviewer's list, then append any locally generated flags (e.g., `risk_type_mismatch` from Step 1b). Do NOT overwrite.

   This assembled object goes into the candidate's JSON (whether ranked or rejected).
```

**Step 4: Fix the Q4 binary flag reference**

Replace line 296 ("If analyst's Q4 (non-binary) was 'No'") with:

```markdown
# Read Q4 answer from the epistemic reviewer's structured output
# If reviewer's q4_nonbinary.answer == "No", add binary flag
```

**Step 5: Commit**

```bash
git add .claude/agents/orchestrator.md
git commit -m "feat: orchestrator passes risk type to reviewer, deterministic friction, assembles canonical epistemic JSON"
```

---

## Task 5: Update the report renderer to match the canonical schema

**Files:**
- Modify: `scripts/report_json.py:277-295` (epistemic rendering)

**Step 1: Replace the epistemic rendering block**

Replace the current rendering logic (which looks for `checks[]` array and ad-hoc string fields) with logic that reads the canonical schema fields:

```python
    if candidate.get("epistemic_confidence"):
        epi = candidate["epistemic_confidence"]
        if isinstance(epi, dict):
            adj = epi.get("adjusted_confidence", epi.get("raw_confidence", "?"))
            raw = epi.get("raw_confidence", "?")
            no_ct = epi.get("no_count", "?")
            lines.append(f"- **Epistemic Confidence:** {adj}/5 ({no_ct} \"No\" answers)")
            for key, label in [
                ("q1_operational", "Operational risk"),
                ("q2_regulatory", "Regulatory discretion"),
                ("q3_precedent", "Historical precedent"),
                ("q4_nonbinary", "Non-binary outcome"),
                ("q5_macro", "Macro/geo limited"),
            ]:
                check = epi.get(key)
                if isinstance(check, dict):
                    lines.append(
                        f"  - {label}: {check.get('answer', '')} -- "
                        f"{check.get('justification', '')} -- "
                        f"Evidence: {check.get('evidence', '')}"
                    )
            if epi.get("risk_type_friction") is not None and epi["risk_type_friction"] != 0:
                rt = epi.get("risk_type", "Unknown")
                friction = epi["risk_type_friction"]
                note = epi.get("friction_note", "")
                lines.append(
                    f"  - Risk-type friction: {rt} -> {friction} "
                    f"(raw {raw}/5 -> adjusted {adj}/5)"
                    + (f" -- {note}" if note else "")
                )
            if epi.get("effective_probability") is not None:
                mult = epi.get("multiplier", "?")
                eff = epi["effective_probability"]
                lines.append(f"  - Effective probability: base x{mult} = {eff}%")
            if epi.get("confidence_cap_pct") is not None:
                lines.append(f"  - Confidence cap: {epi['confidence_cap_pct']}%")
            if epi.get("binary_override"):
                lines.append("  - Binary outcome override: max 5%")
            if epi.get("threshold_proximity_warning"):
                lines.append(
                    f"  - **Threshold proximity warning**: {epi['threshold_proximity_warning']}"
                )
            for flag in epi.get("human_judgment_flags", []):
                lines.append(f"  - Human review: {flag}")
```

This handles both the new canonical format AND gracefully degrades if a field is missing.

**Step 2: Verify existing scan JSON still renders**

```bash
python3 scripts/report_json.py render-scan docs/scans/json/2026-03-07-CPS-AAP-DORM-PYPL-scan-report-v5.json /tmp/test-render.md
cat /tmp/test-render.md | grep -A 20 "Epistemic"
```

Expected: any candidate with canonical `epistemic_confidence` data renders correctly — all 5 PCS checks, friction note, effective probability visible. No `checks[]` fallback needed because the real data already uses `q1_operational` format. The 2026-03-07 scan is used as the regression fixture (the only existing scan with epistemic data).

**Step 3: Commit**

```bash
git add scripts/report_json.py
git commit -m "feat: renderer uses canonical epistemic schema with q1-q5 fields"
```

---

## Task 6: Add rejection reason distinction (epistemic vs base probability)

**Files:**
- Modify: `.claude/agents/orchestrator.md:287` (rejection filter)

**Step 1: Split the rejection reason into two distinct paths**

Replace the single filter at line 287 with:

```markdown
5. **Filter on probability** — two distinct checks:

   a. **Base probability compliance**: If analyst's base probability band < 60% → reject with reason:
      `"base probability below threshold (base {base}% < 60% hard cap)"`
      This indicates the ANALYST found insufficient evidence for a viable turnaround.

   b. **Epistemic confidence filter**: If base >= 60% but effective probability < 60% → reject with reason:
      `"epistemic confidence filter (base {base}% x {multiplier} = {effective}%, below 60% threshold)"`
      This indicates the EPISTEMIC REVIEWER found the probability too uncertain to trust.

   Both go to "Rejected at Analysis" but with different rejection reasons.
```

**Step 2: Commit**

```bash
git add .claude/agents/orchestrator.md
git commit -m "feat: distinguish base probability rejection from epistemic confidence rejection"
```

---

## Task 7: Fix probability band normalization ordering (Codex finding #2)

**Files:**
- Modify: `.claude/agents/orchestrator.md` (reorder steps 4, 4c, 4d)

**Problem:** The current orchestrator computes `effective_probability` at step 4 using the raw base probability, but probability band normalization happens LATER at step 4d. This means a non-compliant raw probability (e.g., 63%) leaks into `effective_probability`, `score`, and `size` before being corrected to a valid band (60%).

**Step 1: Reorder the orchestrator pipeline to normalize BEFORE computing**

Move probability band validation (4d) BEFORE effective probability computation (step 4). New ordering:

```markdown
3c. **Probability band normalization** (moved from 4d):
   - Confirm analyst probability is a valid band (50/60/70/80)
   - If not, round to nearest: <55% → 50%, 55-64% → 60%, 65-74% → 70%, 75%+ → 80%
   - Note: "Probability rounded: analyst assigned {n}%, corrected to {band}%"
   - If post-hoc override language detected → reject: `probability_non_compliant: post_hoc_band_override`
   - **All downstream computation uses the NORMALIZED band, not the raw value**

4. **Compute effective probability** using normalized base probability:
   bash scripts/calc-score.sh effective-prob {normalized_base_prob} {adjusted_confidence}

4c. **Threshold-hugging detection**: Check if the NORMALIZED probability is within 2% of hard caps
```

**Step 2: In the epistemic_confidence assembly (Task 4, Step 3), change the instruction:**

Replace:
```
- Compute `effective_probability` via: `bash scripts/calc-score.sh effective-prob {base_prob} {adjusted_confidence}`
```
With:
```
- Compute `effective_probability` via: `bash scripts/calc-score.sh effective-prob {normalized_base_prob} {adjusted_confidence}`
  (MUST use the band-normalized probability, never the raw analyst value)
```

**Step 3: Commit**

```bash
git add .claude/agents/orchestrator.md
git commit -m "fix: normalize probability band BEFORE effective probability computation"
```

---

## Task 8: Update scoring-formulas.md friction table to match deterministic rules

**Files:**
- Modify: `knowledge/scoring-formulas.md:155-165`

**Step 1: Replace the friction table with deterministic version**

Replace the current friction table and surrounding text with:

```markdown
| Dominant Risk Type | Default Friction | Override Condition | Overridden Friction |
|--------------------|------------------|--------------------|---------------------|
| Operational / Financial | 0 | — | — |
| Cyclical / Macro | -1 | Q3 = Yes (named historical precedent) | 0 |
| Regulatory / Political | -2 | Q2 = Yes (stable regulatory environment) | -1 |
| Legal / Investigation | -2 | No override available | -2 |
| Structural fragility (SPOF) | -1 | No override; also sets binary flag if Q4 not already No | -1 |

**Application:** `adjusted_confidence = max(1, raw_confidence - abs(friction))`

**Override logic is deterministic:**
1. Look up risk type → get default friction
2. Check PCS answer for override condition → apply or keep default
3. Record `friction_note` with decision: "{risk_type}, Q{n}={answer} -> friction {value}"

**Friction does NOT stack with PCS answers** — it applies after the 5-question count. The override conditions use PCS answers to determine WHETHER to soften friction, not to add more.
```

**Step 2: Commit**

```bash
git add knowledge/scoring-formulas.md
git commit -m "feat: deterministic friction rules with explicit override conditions"
```

---

## Task 9: Add runtime validation for epistemic_confidence (Codex finding #1)

**Files:**
- Modify: `scripts/report_json.py` (extend `validate_scan()`)

**Problem:** `validate_scan()` only checks top-level key presence. Malformed `epistemic_confidence` payloads (missing PCS checks, wrong types, invalid enums) pass validation and only fail at render time or — worse — silently produce incomplete output.

**Step 1: Add `validate_epistemic()` helper function**

```python
VALID_RISK_TYPES = {
    "Operational/Financial", "Cyclical/Macro", "Regulatory/Political",
    "Legal/Investigation", "Structural fragility (SPOF)",
}

PCS_KEYS = ["q1_operational", "q2_regulatory", "q3_precedent", "q4_nonbinary", "q5_macro"]

def validate_epistemic(epi, context=""):
    """Validate an epistemic_confidence object. Raises on structural errors, warns on missing optional fields."""
    if not isinstance(epi, dict):
        fail(f"{context}epistemic_confidence must be a dict, got {type(epi).__name__}")
    # Required PCS checks
    for key in PCS_KEYS:
        if key not in epi:
            fail(f"{context}epistemic_confidence missing required key: {key}")
        check = epi[key]
        if not isinstance(check, dict):
            fail(f"{context}{key} must be a dict")
        for field in ["answer", "justification", "evidence"]:
            if field not in check:
                fail(f"{context}{key} missing required field: {field}")
        if check["answer"] not in ("Yes", "No"):
            fail(f"{context}{key}.answer must be 'Yes' or 'No', got '{check['answer']}'")
    # Required scalar fields
    for key in ["no_count", "raw_confidence", "risk_type", "risk_type_friction",
                "adjusted_confidence", "multiplier", "effective_probability"]:
        if key not in epi:
            fail(f"{context}epistemic_confidence missing required key: {key}")
    # Enum validation
    if epi["risk_type"] not in VALID_RISK_TYPES:
        warn(f"{context}risk_type '{epi['risk_type']}' not in canonical enum")
    # Range checks
    if not (0 <= epi.get("no_count", 0) <= 5):
        fail(f"{context}no_count must be 0-5")
    if not (1 <= epi.get("raw_confidence", 1) <= 5):
        fail(f"{context}raw_confidence must be 1-5")
    if not (1 <= epi.get("adjusted_confidence", 1) <= 5):
        fail(f"{context}adjusted_confidence must be 1-5")
    if not (-2 <= epi.get("risk_type_friction", 0) <= 0):
        fail(f"{context}risk_type_friction must be -2 to 0")
```

**Step 2: Wire into `validate_scan()`**

After the existing top-level key checks, add:

```python
# Validate epistemic_confidence in ranked candidates
for i, cand in enumerate(data.get("ranked_candidates", [])):
    if "epistemic_confidence" in cand:
        validate_epistemic(cand["epistemic_confidence"],
                          context=f"ranked_candidates[{i}].")

# Validate epistemic_confidence in rejected-at-analysis packets
for i, pkt in enumerate(data.get("rejected_at_analysis_detail_packets", [])):
    if "epistemic_confidence" in pkt:
        validate_epistemic(pkt["epistemic_confidence"],
                          context=f"rejected_at_analysis[{i}].")
```

Note: `epistemic_confidence` is validated IF present but not required — candidates rejected at screening won't have it.

**Step 3: Commit**

```bash
git add scripts/report_json.py
git commit -m "feat: validate epistemic_confidence structure in validate_scan()"
```

---

## Task 10: Expand regression coverage (Codex finding #5)

**Files:**
- No code changes — this is a test procedure task

**Step 1: Run full validation + render on existing scan**

```bash
# Validate structure (now includes epistemic validation)
python3 scripts/report_json.py validate-scan \
  docs/scans/json/2026-03-07-CPS-AAP-DORM-PYPL-scan-report-v5.json

# Render and compare
python3 scripts/report_json.py render-scan \
  docs/scans/json/2026-03-07-CPS-AAP-DORM-PYPL-scan-report-v5.json \
  /tmp/regression-test.md
diff <(head -100 docs/scans/2026-03-07-CPS-AAP-DORM-PYPL-scan-report-v5.md) \
     <(head -100 /tmp/regression-test.md)
```

**Step 2: Verify any candidate WITH epistemic data renders correctly**

Using the 2026-03-07 scan as the regression fixture (contains one candidate with `epistemic_confidence`), confirm:
- All 5 PCS checks render with answer/justification/evidence
- Risk-type friction renders when non-zero
- Effective probability renders with multiplier
- Binary override renders only when `binary_override: true`
- Threshold proximity warning renders only when present
- Human judgment flags render only when present

**Step 3: Verify candidates WITHOUT epistemic data render cleanly**

The same fixture contains candidates rejected before epistemic review (no `epistemic_confidence` key). Confirm:
- No epistemic section renders
- No crash or empty bullet points
- All other fields render unchanged

**Step 4: No commit — this is a validation gate before marking the plan complete**

---

## Dependency Graph

```
Wave 1 (parallel):  Task 1 (schema), Task 2 (template), Task 8 (scoring-formulas)
Wave 2:             Task 3 (reviewer) — reviewer-side contract
Wave 3:             Tasks 4+6+7+11+12+13+14 as ONE orchestrator rewrite
                    (all modify orchestrator.md — apply as single coupled pass, not 7 diffs)
Wave 4 (parallel):  Task 5 (renderer) + Task 9 (runtime validation) + Task 15 (param fix in analyst.md)
Wave 5:             Task 10 (regression validation gate)
```

**Coupling notes:**
- Tasks 3 and 4 define opposite sides of the reviewer↔orchestrator wire contract. Task 3 lands first, then the orchestrator rewrite consumes its output format. Field names, fence format, and parsing assumptions must be cross-verified.
- Tasks 4, 6, 7, 11, 12, 13, 14 ALL modify `orchestrator.md`. To avoid context drift and merge conflicts, execute them as a **single orchestrator rewrite** — read the file once, apply all changes, write once, commit once.
- Task 5 depends on Tasks 1+3+orchestrator-rewrite to know the final shape.
- Task 9 depends on Task 1 (schema definition) for validation rules.
- Task 15 modifies `analyst.md` (independent of orchestrator rewrite).
- Task 10 is the final gate — runs AFTER all code changes are committed.

**Plan ordering:** This plan executes BEFORE the agent decontamination plan (`2026-03-08-agent-decontamination.md`), since both modify `analyst.md` and `orchestrator.md`.

---

## Task 11: Fix score recomputation using wrong probability variable

**Files:**
- Modify: `.claude/agents/orchestrator.md:291`

**Problem:** Line 289 says "Recompute decision score **using effective probability**" but line 291 passes `{base_probability}`:
```bash
bash scripts/calc-score.sh score {downside} {base_probability} {cagr} {confidence}
```

Every post-epistemic score is computed with the wrong probability input.

**Step 1: Fix the command**

Replace:
```bash
bash scripts/calc-score.sh score {downside} {base_probability} {cagr} {confidence}
```
With:
```bash
bash scripts/calc-score.sh score {downside} {effective_probability} {cagr} {confidence}
```

**Step 2: Commit**

```bash
git add .claude/agents/orchestrator.md
git commit -m "fix: score recomputation uses effective_probability, not base"
```

---

## Task 12: Fix duplicate "4d" step labels + renumber

**Files:**
- Modify: `.claude/agents/orchestrator.md`

**Problem:** "4d" appears twice — once as a substep of 4c (probability band validation, line 282) and once as a top-level section (Multiple Consistency Audit, line 343). Any reference to "4d" is ambiguous.

**Step 1: Renumber**

Since Task 7 already moves probability band validation to "3c", the substep collision resolves naturally. After Task 7 lands, verify:
- No remaining duplicate step labels
- All cross-references (in this file and in knowledge files) use the correct label

**Step 2: Commit with Task 7 (no separate commit needed)**

---

## Task 13: Fix probability sensitivity table values

**Files:**
- Modify: `.claude/agents/orchestrator.md:359-369`

**Problem:** Sensitivity table runs at 55/60/65/70/75% but valid probability bands are 50/60/70/80 only. Contradiction.

**Step 1: Replace sensitivity values with valid bands**

Update the sensitivity table to use 50/60/70/80 bands. Also explicitly assign responsibility: the **orchestrator** computes this table (not the analyst), since it requires running `calc-score.sh` at each band.

**Step 2: Commit**

```bash
git add .claude/agents/orchestrator.md
git commit -m "fix: probability sensitivity uses valid 50/60/70/80 bands, assign to orchestrator"
```

---

## Task 14: Fix probability ceiling re-validation gap

**Files:**
- Modify: `.claude/agents/orchestrator.md` (after effective probability computation)

**Problem:** Analyst applies probability ceilings to base probability. But after epistemic friction adjusts effective probability, nobody re-checks ceilings. This is likely a non-issue in practice (friction only reduces probability, so ceilings still hold), but the spec should be explicit.

**Step 1: Add ceiling compliance note after effective probability**

After the effective probability computation, add:

```markdown
Note: Probability ceilings (3yr decline → 65%, negative equity → 60%, CEO <1yr → 65%)
apply to the analyst's BASE probability assignment. Epistemic friction only reduces
effective probability below base — ceilings cannot be violated by the epistemic pipeline.
No re-validation needed.
```

**Step 2: Commit**

```bash
git add .claude/agents/orchestrator.md
git commit -m "docs: clarify probability ceilings apply to base, not re-validated post-epistemic"
```

---

## Task 15: Fix calc-score.sh parameter count mismatch

**Files:**
- Modify: `.claude/agents/analyst.md:349`

**Problem:** Analyst uses `score <downside> <prob> <cagr>` (3 params). Orchestrator uses `score {downside} {prob} {cagr} {confidence}` (4 params). Need to check which is correct.

**Step 1: Read calc-score.sh to determine actual interface**

```bash
bash scripts/calc-score.sh help
```

**Step 2: Update whichever agent has the wrong parameter count to match the script's actual interface**

**Step 3: Commit**

```bash
git add .claude/agents/analyst.md .claude/agents/orchestrator.md
git commit -m "fix: align calc-score.sh score command params with actual script interface"
```

---

## Updated Dependency Graph

```
Wave 1 (parallel):  Task 1 (schema), Task 2 (template), Task 8 (scoring-formulas)
Wave 2 (coupled):   Task 3 (reviewer) + Task 4 (orchestrator) — ONE change set
Wave 3 (parallel):  Task 5 (renderer) + Task 9 (runtime validation)
Wave 4 (parallel):  Task 6 (rejection split) + Task 7 (band ordering) + Task 11 (score fix) + Task 12 (renumber) + Task 13 (sensitivity) + Task 14 (ceiling note) + Task 15 (param fix)
                    — all modify orchestrator.md or analyst.md, apply after Wave 2
Wave 5:             Task 10 (regression validation gate)
```

---

## What This Does NOT Change

- **calc-score.sh** — no changes needed; it already computes effective-prob correctly
- **Analyst agent** — already outputs Epistemic Input with Dominant Risk Type (line 541-547)
- **Holding reviewer** — epistemic review is scan-only, not holding-review
- **Screener** — not involved in epistemic flow

---

## Regression Check

See **Task 10** for the full regression procedure. The 2026-03-07 scan is the regression fixture (only existing scan with real epistemic data). Summary:

1. `validate-scan` must pass on existing JSON (including epistemic_confidence deep validation)
2. `render-scan` must produce equivalent or improved output vs existing markdown
3. Any candidate with canonical `epistemic_confidence` renders all PCS checks, friction, effective probability
4. Candidates without epistemic data render unchanged — no crashes, no empty bullets
5. The contract is stock-agnostic: no ticker-specific logic in schema, renderer, or validation
