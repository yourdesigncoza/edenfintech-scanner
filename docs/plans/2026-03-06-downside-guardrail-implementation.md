# Downside Estimation Guardrail — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Anchor worst-case downside estimation to historical FMP data using the same 4-input valuation formula, eliminating LLM variance (BRBR: 12% vs 42% gap).

**Architecture:** Add a `floor` command to `calc-score.sh` that computes the mechanical floor price. Update `analyst.md` to require trough-anchored inputs with a "trough path" display. Add a "Heroic Optimism" test that flags when trough inputs are more favorable than historical data. Cross-check against tangible book value.

**Tech Stack:** Bash/Python3 (calc-score.sh), Markdown (analyst.md, valuation-guidelines.md, scoring-formulas.md, strategy-rules.md)

---

### Task 1: Add `floor` command to calc-score.sh

**Files:**
- Modify: `scripts/calc-score.sh`

**Step 1: Add floor command to the help text**

In the `usage()` function (after the `momentum` entry around line 37), add:

```
  floor <trough_revenue_B> <trough_margin_pct> <trough_multiple> <shares_M> <current_price>
      Calculate worst-case floor price from trough inputs.
      Uses same valuation formula (Rev x Margin x Multiple / Shares) with trough data.
      Returns floor price, downside %, and input summary.
```

And add an example after line 54:

```
  bash calc-score.sh floor 2.2 7.0 10 130 17.52    # trough floor for BRBR
```

**Step 2: Implement the floor command**

Add this case block before the `help)` case (before line 423):

```bash
floor)
    [[ $# -eq 5 ]] || err "floor requires 5 args: <trough_revenue_B> <trough_margin_pct> <trough_multiple> <shares_M> <current_price>"
    validate_number "trough_revenue_B" "$1"
    validate_pct "trough_margin_pct" "$2"
    validate_number "trough_multiple" "$3"
    validate_number "shares_M" "$4"
    validate_number "current_price" "$5"

    python3 -c "
import json

revenue_b = float('$1')
margin_pct = float('$2')
multiple = float('$3')
shares_m = float('$4')
current_price = float('$5')

if shares_m <= 0:
    raise ValueError('shares_M must be positive')
if current_price <= 0:
    raise ValueError('current_price must be positive')
if multiple < 0:
    raise ValueError('trough_multiple must be non-negative')

margin = margin_pct / 100
fcf_b = round(revenue_b * margin, 4)
floor_price = round((fcf_b * multiple * 1000) / shares_m, 2)
downside_pct = round((1 - floor_price / current_price) * 100, 2)

print(json.dumps({
    'trough_revenue_B': revenue_b,
    'trough_margin_pct': margin_pct,
    'trough_fcf_B': round(fcf_b, 4),
    'trough_multiple': multiple,
    'shares_M': shares_m,
    'current_price': current_price,
    'floor_price': floor_price,
    'downside_pct': downside_pct
}, indent=2))
"
    ;;
```

**Step 3: Test the floor command**

Run:
```bash
# BRBR trough: Rev $2.2B, margin 7%, multiple 10x, shares 130M, current $17.52
bash scripts/calc-score.sh floor 2.2 7.0 10 130 17.52
```

Expected output (approximately):
```json
{
  "trough_revenue_B": 2.2,
  "trough_margin_pct": 7.0,
  "trough_fcf_B": 0.154,
  "trough_multiple": 10.0,
  "shares_M": 130.0,
  "current_price": 17.52,
  "floor_price": 11.85,
  "downside_pct": 32.36
}
```

Also test PYPL:
```bash
# PYPL trough: Rev $33B, margin 13%, multiple 8x, shares 960M, current $46.77
bash scripts/calc-score.sh floor 33.0 13.0 8 960 46.77
```

And test edge cases:
```bash
# Zero margin edge case
bash scripts/calc-score.sh floor 2.2 0 10 130 17.52
# Should return floor_price: 0.00, downside_pct: 100.00

# Error case — bad args
bash scripts/calc-score.sh floor 2.2 7.0
# Should show error message
```

**Step 4: Commit**

```bash
git add scripts/calc-score.sh
git commit -m "feat(scoring): add floor command for mechanical worst-case downside"
```

---

### Task 2: Update strategy-rules.md — Worst Case specification

**Files:**
- Modify: `knowledge/strategy-rules.md` (lines 130-132)

**Step 1: Replace the existing Reasonable Worst Case section**

Replace lines 130-132:
```markdown
### Reasonable Worst Case (Required)
- Every investment needs a downside estimate
- Goal: asymmetry — limited downside vs. large upside
```

With:
```markdown
### Reasonable Worst Case (Required)

Goal: asymmetry — limited downside vs. large upside. The worst case uses the **same 4-input valuation formula** as the base case, but with trough inputs anchored to historical data.

**Trough Input Anchoring:**

| Input | Anchor To |
|-------|-----------|
| Revenue | Lowest annual revenue in 5yr window, or flat if currently declining |
| FCF Margin | Lowest annual FCF margin in 5yr window |
| FCF Multiple | Lowest trading multiple in 5-10yr history (P/FCF or EV/FCF) |
| Shares | Current diluted count. No buyback credit in worst case. Add dilution if cash < 1yr OpEx |

**Process:**
1. Pull trough inputs from FMP historical data (already fetched in Step 3)
2. Run `calc-score.sh floor` to compute the mechanical floor price
3. This is the starting point — the analyst may adjust but must show the "trough path"

**Asymmetric Override Rule:**
- Making the floor WORSE (more pessimistic) than the mechanical calculation is always allowed — lawsuits, fraud, event risk justify a harsher floor
- Making the floor BETTER (more optimistic) triggers a "Heroic Optimism" flag and requires justification

**Cross-Check:** Compare floor against tangible book value per share (TBV).
- Floor > 2x TBV → flag (floor may be too optimistic)
- TBV is negative → flag (asset backing gone, downside may be worse)

**Show the Trough Path:**
```
Revenue trough: $X (FY year, source)
Margin trough: X% (FY year, source)
Multiple trough: Xx (year, P/FCF or EV/FCF)
Shares: XM (current diluted, no buyback credit)
-> Mechanical floor: $X = X% downside
TBV cross-check: $X/share — floor is X.Xx TBV (OK/FLAG)
Analyst adjustment: [none / harsher due to X / more optimistic — HEROIC OPTIMISM FLAG: justification]
-> Final floor: $X = X% downside
```
```

**Step 2: Commit**

```bash
git add knowledge/strategy-rules.md
git commit -m "feat(strategy): add trough-anchored worst case specification"
```

---

### Task 3: Update valuation-guidelines.md — Heroic Optimism test

**Files:**
- Modify: `knowledge/valuation-guidelines.md` (after the Heroic Assumptions test, around line 56)

**Step 1: Add the Heroic Optimism test section**

After line 56 (`- FCF multiple exceeds the company's historical median by more than 50%`), add:

```markdown

### Heroic Optimism Test (Worst Case)

The inverse of the Heroic Assumptions Test — flags when a worst case is unrealistically mild.

A worst case is "heroically optimistic" if ANY trough input is more favorable than the data:
- Revenue assumption is above the company's 5-year low
- FCF margin assumption is above the company's 5-year low
- Multiple assumption is above the stock's historical trough trading multiple
- Shares assumption is below current diluted count (i.e., assumes buybacks continue in a worst case)

If ANY input is flagged heroically optimistic, the analyst MUST provide explicit justification or revise the input downward.

### Cross-Check: Tangible Book Value

Every worst-case floor price must be cross-checked against tangible book value per share:
- Floor > 2x TBV → flag: floor may be too optimistic, stock could trade toward asset value
- TBV is negative → flag: asset backing is gone, downside could be more severe than formula suggests
- Floor < TBV → acceptable: beaten-down stocks routinely trade below book
```

**Step 2: Commit**

```bash
git add knowledge/valuation-guidelines.md
git commit -m "feat(valuation): add heroic optimism test and TBV cross-check for worst case"
```

---

### Task 4: Update scoring-formulas.md — Document downside anchoring

**Files:**
- Modify: `knowledge/scoring-formulas.md` (after line 9, the downside description)

**Step 1: Add anchoring note to the scoring input table**

After line 9 (`| Reasonable worst case downside | 45% | % decline in share price if thesis is wrong |`), add a new subsection before "### Downside Penalty Curve":

```markdown

### Downside Anchoring

The downside estimate must be derived from the trough valuation formula (same 4-input model as base case, with historical trough inputs). See `strategy-rules.md` "Reasonable Worst Case" for the full specification.

**Key rules:**
- Trough inputs anchored to 5yr historical lows from FMP data
- `calc-score.sh floor` computes the mechanical starting point
- Analyst may make floor harsher (no flag), but more optimistic triggers "Heroic Optimism" flag
- Cross-checked against tangible book value per share
```

**Step 2: Commit**

```bash
git add knowledge/scoring-formulas.md
git commit -m "feat(scoring): document downside anchoring requirement"
```

---

### Task 5: Update analyst.md — Structured worst-case process

**Files:**
- Modify: `.claude/agents/analyst.md` (lines 196-199, the Reasonable Worst Case section)

**Step 1: Replace the unstructured worst-case instructions**

Replace lines 196-199:
```markdown
**Reasonable Worst Case:**
- What if revenue grows slower? Margins don't recover? Multiple stays low?
- Calculate floor price under pessimistic (but not catastrophic) scenario
- Express as % downside from current price
```

With:
```markdown
**Reasonable Worst Case (Trough Valuation):**

Use the same 4-input formula with trough inputs anchored to historical FMP data:

1. **Identify trough inputs** from data already pulled in Step 3:
   - Revenue: lowest annual revenue in 5yr window (from income statement). If revenue is currently declining, use flat.
   - FCF Margin: lowest annual FCF margin in 5yr window (from cashflow/income). If negative in any year, use 0%.
   - Multiple: lowest historical trading P/FCF or EV/FCF (from metrics/ratios). Use the lower of the two.
   - Shares: current diluted count. Do NOT assume buybacks continue. If cash < 1yr operating expenses, add 10-20% dilution.

2. **Run the floor calculator** — do NOT compute floor manually:
   ```bash
   bash scripts/calc-score.sh floor <trough_revenue_B> <trough_margin_pct> <trough_multiple> <shares_M> <current_price>
   ```
   The output IS the mechanical floor. Show the command AND its JSON output.

3. **Cross-check against tangible book value:**
   - Pull TBV per share from FMP balance sheet data
   - If floor > 2x TBV: flag and justify why floor is above asset backing
   - If TBV is negative: flag and note asset backing is gone

4. **Analyst adjustment (optional):**
   - **Harsher floor** (event risk): freely adjust downward for lawsuits, fraud, covenant risk, etc. No flag needed.
   - **Milder floor** (heroic optimism): if ANY trough input is more favorable than the 5yr historical low, this triggers a **HEROIC OPTIMISM FLAG**. Must justify in 1-2 sentences or revise the input.

5. **Show the trough path:**
   ```
   Revenue trough: $X.XB (FY20XX low)
   Margin trough: X.X% (FY20XX low)
   Multiple trough: Xx (20XX trading low, P/FCF)
   Shares: XM (current diluted, no buyback credit)
   -> calc-score.sh floor output: $X.XX = X.X% downside
   TBV cross-check: $X.XX/share — floor is X.Xx TBV [OK/FLAG]
   Analyst adjustment: [none / harsher: {reason} / HEROIC OPTIMISM FLAG: {justification}]
   -> Final worst case: $X.XX = X.X% downside
   ```
```

**Step 2: Verify analyst.md is internally consistent**

Read through the full Step 5 section to confirm the new worst case fits between the base case valuation and the gut check. The flow should be:
1. Base case valuation (4 inputs, recovery assumptions) → target price → CAGR
2. **Worst case valuation (4 inputs, trough assumptions) → floor price → downside %** ← NEW
3. Gut check (does implied multiple make sense?)
4. Heroic assumptions test (base case)

**Step 3: Commit**

```bash
git add .claude/agents/analyst.md
git commit -m "feat(analyst): structured trough-anchored worst case with mechanical floor"
```

---

### Task 6: Update orchestrator.md — Downside consistency audit

**Files:**
- Modify: `.claude/agents/orchestrator.md` (after the Multiple Consistency Audit, section 4b around line 235)

**Step 1: Add a Downside Consistency Audit section**

After the existing "### 4b. Multiple Consistency Audit" section (after line 235), add:

```markdown

### 4c. Downside Consistency Audit

After the multiple consistency audit, before ranking:

1. Extract the downside % for each scored candidate
2. Check that each candidate has a `trough_path` showing anchored inputs
3. Flag any candidate where:
   - No mechanical floor was computed (missing calc-score.sh floor output)
   - A "Heroic Optimism" flag was raised without justification
   - TBV cross-check was skipped
4. For flagged candidates: move to "Rejected at Analysis" with reason "downside methodology non-compliant"
```

**Step 2: Commit**

```bash
git add .claude/agents/orchestrator.md
git commit -m "feat(orchestrator): add downside consistency audit step"
```

---

### Task 7: Update CLAUDE.md — Document the new command

**Files:**
- Modify: `CLAUDE.md` (in the calc-score.sh section or scoring quick reference)

**Step 1: Add floor command reference**

In the "Testing / Running" or relevant section, add:

```markdown
# Calculate worst-case floor price
bash scripts/calc-score.sh floor <trough_revenue_B> <trough_margin_pct> <trough_multiple> <shares_M> <current_price>
```

**Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: add floor command to CLAUDE.md reference"
```

---

### Task 8: End-to-end verification

**Step 1: Test with BRBR data to confirm the variance problem is addressed**

```bash
# BRBR trough inputs from FMP historical data:
# Revenue trough: ~$1.0B (FY2021 — pre-growth spike)
# Margin trough: ~7% (lowest in 5yr)
# Multiple trough: ~10x P/FCF (2022 trading low)
# Shares: 130M (current diluted, no buyback credit)
# Current price: $17.52

bash scripts/calc-score.sh floor 1.0 7.0 10 130 17.52
```

Verify the floor price and downside % are reasonable and reproducible.

**Step 2: Test with PYPL data to confirm it matches the "good" analyst behavior**

```bash
# PYPL trough inputs:
# Revenue: $33B (flat — not declining)
# Margin: 13% (compressed from 16.7%)
# Multiple: 8x (historical trough P/FCF)
# Shares: 960M (no buyback credit)
# Current price: $46.77

bash scripts/calc-score.sh floor 33.0 13.0 8 960 46.77
```

Verify this produces a floor close to the PYPL analyst's $35.75 (23.6% downside).

**Step 3: Test edge cases**

```bash
# Company with negative FCF margin (trough margin = 0)
bash scripts/calc-score.sh floor 5.0 0 12 200 30.00

# Very high leverage company (low multiple trough)
bash scripts/calc-score.sh floor 10.0 5.0 3 500 15.00
```

**Step 4: Verify all knowledge files are consistent**

Read through these files in order and confirm no contradictions:
1. `knowledge/strategy-rules.md` — Reasonable Worst Case section
2. `knowledge/valuation-guidelines.md` — Heroic Optimism Test section
3. `knowledge/scoring-formulas.md` — Downside Anchoring section
4. `.claude/agents/analyst.md` — Step 5 Reasonable Worst Case
5. `.claude/agents/orchestrator.md` — Step 4c Downside Consistency Audit

**Step 5: Final commit (if any fixes needed)**

```bash
git add -A
git commit -m "fix: resolve any consistency issues from end-to-end review"
```
