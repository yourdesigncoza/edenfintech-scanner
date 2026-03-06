# Methodology Alignment Phase 1 Plan

Date: 2026-03-06
Phase: 1
Title: Harden Step 2 First Filter

Depends on:
- `docs/plans/2026-03-06-methodology-alignment-map.md`
- `docs/plans/2026-03-06-methodology-alignment-implementation-plan.md`

Primary methodology sources:
- `knowledge/strategy-rules.md`
- `/home/laudes/zoot/projects/strategy_EdenFinTech/edenfintech-system/02-FIRST-FILTER.md`

## Goal

Strengthen the scanner's Step 2 first filter so that the five EdenFinTech checks produce more auditable, repeatable outcomes and rely less on free-form model judgment.

This phase does **not** try to make Step 2 fully automatic. It converts the current prompt-heavy screening step into a structured gate with explicit evidence, deterministic helpers where useful, and standardized verdict outputs.

## Why Phase 1 Matters

The first filter is the bouncer. If it is loose, the system wastes analysis budget on weak candidates and contaminates downstream rankings. If it is too rigid without evidence, it will reject valid turnarounds. The right target is:

- deterministic where the methodology is explicit
- structured where the methodology is judgment-heavy
- ruthless without becoming blind

## Current Weaknesses

Observed in the current screener design:

1. The five checks are specified well in prose, but not emitted as structured per-check verdicts.
2. Several judgments are repeated ad hoc inside the prompt instead of coming from reusable calculations.
3. Borderline cases are under-defined.
4. Rejections are summarized at the stock level, but not always traceable to a threshold + evidence pair.
5. The screener does not yet separate:
   - deterministic evidence
   - interpretation
   - final verdict

## Phase Outcome

After this phase, Step 2 should behave like a disciplined checklist:
- every stock gets 5 check records
- every check has verdict + evidence + threshold
- borderline names survive with explicit flags
- hard fails are clearly justified
- analysts inherit better structured context

## Scope

In scope:
- Screener workflow and output format
- Reusable Step 2 helper calculations
- Evidence schema for the five checks
- Borderline/pass/fail definitions
- Verification cases for repeatability

Out of scope:
- Step 3 peer ranking
- Step 4 catalyst rubric
- Step 8 monitoring
- Full valuation-model overhaul

## Design Principles

### 1. Preserve the method, not just the wording

The first filter exists to reject quickly while allowing a second look when risk is priced in or when catalysts plausibly change the trajectory.

### 2. Separate evidence from verdict

Every check should show:
- what was measured
- what threshold or heuristic was applied
- what the screener concluded

### 3. Keep borderline states explicit

The methodology is not purely binary. Some names should pass with a warning instead of being prematurely killed.

### 4. Prefer lightweight deterministic helpers over new agent logic

If a check can be supported by `calc-score.sh`, prefer that over more prompt text.

## Target State

For each screened stock, the screener should produce a compact Step 2 record like:

```markdown
### TICKER — Step 2 Check Record

| Check | Verdict | Evidence | Threshold / Rule | Flag |
|------|---------|----------|------------------|------|
| Solvency | BORDERLINE_PASS | cash $X, current debt $Y, FCF $Z, price -82% from ATH | risk priced in + likely survival | solvency_borderline |
| Dilution | FAIL | SBC 7.2% of revenue, rev/share -4% CAGR | SBC > 5% without growth | — |
| Revenue | PASS | 5yr rev CAGR 3.8%, new product launch in 2026 | growth exists OR catalyst identified | — |
| ROIC | PASS | median ROIC 8.1%, cyclical up-cycle > 12% | median >= 6% or cyclical exception | — |
| Valuation | BORDERLINE_PASS | rough CAGR 27% with normalized margins | 25-29.9% = analyst gate | valuation_borderline |
```

This becomes the handoff format to the analyst.

## Implementation Workstreams

### Workstream A: Structured Step 2 Output

#### Objective

Make the screener output the five checks in a reusable, auditable format.

#### Files
- Modify: `.claude/agents/screener.md`

#### Changes

1. Replace purely prose Step 2 instructions with a required check-record schema.
2. Require each stock that reaches Step 2 to emit:
   - `check_name`
   - `verdict` (`PASS`, `BORDERLINE_PASS`, `FAIL`)
   - `evidence`
   - `threshold_or_rule`
   - `flag` if applicable
3. Standardize final stock outcome:
   - `PASS_TO_ANALYST`
   - `REJECT_AT_SCREEN`
4. Require notable rejections to quote the failing check directly.

#### Success criteria

- Every Step 2 stock has five explicit check results.
- The analyst receives flags grounded in a known check.

### Workstream B: Deterministic Check Helpers

#### Objective

Move repetitive math and trend judgments out of prompt prose where possible.

#### Files
- Modify: `scripts/calc-score.sh`
- Possibly modify: `.claude/agents/screener.md`

#### Proposed helper commands

1. `rev-share-trend`
   - Inputs: 5 years revenue, 5 years shares
   - Output: revenue/share series, CAGR or trend summary
   - Purpose: support dilution and quality sniff logic

2. `median`
   - Inputs: numeric series
   - Output: median value
   - Purpose: support ROIC median and related simple checks

3. `solvency-snapshot`
   - Inputs: cash, current debt, long-term debt, FCF
   - Output: simple summary ratios / flags
   - Purpose: standardize balance-sheet summary

4. Optional: `rough-hurdle`
   - Inputs: current price, normalized margin assumption, multiple, shares, current revenue
   - Output: rough target and CAGR band
   - Purpose: reduce free-form rough valuation at screening stage

#### Guardrail

Do not build a parallel valuation engine. These helpers exist to standardize screening evidence, not to replace analyst Step 5.

#### Success criteria

- Repeated screening math no longer depends on ad hoc manual arithmetic.
- The screener instructions can reference helper outputs directly.

### Workstream C: Borderline-State Definitions

#### Objective

Clarify when a stock should be rejected immediately versus sent through with flags.

#### Files
- Modify: `.claude/agents/screener.md`
- Possibly modify: `knowledge/strategy-rules.md` if wording needs tightening

#### Target definitions

1. **Solvency**
   - `FAIL`: survival genuinely doubtful and risk not clearly priced in
   - `BORDERLINE_PASS`: survival uncertain but stock is dramatically broken and evidence suggests plausible runway

2. **Dilution**
   - `FAIL`: SBC > 5% without growth, or share issuance for debt service
   - `BORDERLINE_PASS`: dilution elevated but per-share economics still improving

3. **Revenue**
   - `FAIL`: no growth and no concrete catalyst
   - `BORDERLINE_PASS`: flat/weak trend but at least one specific catalyst exists

4. **ROIC**
   - `FAIL`: chronically below ~6% and no cyclical exception
   - `BORDERLINE_PASS`: median weak but full-cycle evidence shows recoverable economics

5. **Valuation**
   - `FAIL`: rough CAGR clearly below 25%
   - `BORDERLINE_PASS`: rough CAGR 25-29.9%

#### Success criteria

- Borderline states are narrow and intentional.
- Analysts are not flooded with low-quality “maybe” names.

### Workstream D: Handoff Improvement To Analysts

#### Objective

Ensure the analyst receives structured screening context rather than vague flags.

#### Files
- Modify: `.claude/agents/orchestrator.md`
- Modify: `.claude/agents/screener.md`

#### Changes

1. Screener output should include a per-stock `Step 2 Check Record`.
2. Orchestrator should pass:
   - stock
   - cluster
   - all borderline flags
   - the exact Step 2 evidence block
3. Analysts should be told which check was borderline and why.

#### Success criteria

- Analysts start with evidence-backed concerns, not generic labels.
- Step 3 and Step 4 are better focused.

### Workstream E: Verification Harness For Step 2

#### Objective

Validate that the hardened first filter behaves consistently on known examples.

#### Files
- Create: verification note under `docs/plans/` or `.planning/`

#### Test case types

1. Clean pass
2. Clear fail on dilution
3. Clear fail on valuation
4. Borderline solvency but priced-in risk
5. Cyclical ROIC exception

#### Suggested candidate set

Use a mix of names already discussed in project materials where possible:
- CPS-style solvency borderline
- WMT-style quality but valuation fail
- One dilution-fail case
- One cyclical pass case
- One revenue-no-catalyst fail case

#### Verification questions

1. Does the stock receive the same Step 2 verdict on repeated runs with the same cached data?
2. Does the rejection reason map clearly to one failing check?
3. Do borderline names carry the right flags into analyst handoff?

## File-Level Task Plan

### Task 1: Update Screener Spec

Modify `.claude/agents/screener.md` to:
- require structured Step 2 check records
- define PASS / BORDERLINE_PASS / FAIL
- standardize evidence and threshold language
- standardize notable-rejection formatting

### Task 2: Add Lightweight Step 2 Helpers

Modify `scripts/calc-score.sh` to add the minimum viable helper commands needed to support:
- revenue/share trend
- median calculations
- simple solvency summary

### Task 3: Wire Handoff Format

Update `.claude/agents/orchestrator.md` so analyst handoff includes structured Step 2 records instead of just generic screener flags.

### Task 4: Verify On Known Cases

Run a small fixed validation set and document:
- outcomes
- repeatability
- any threshold ambiguity

## Acceptance Criteria

Phase 1 is complete when all of the following are true:

1. Every stock reaching Step 2 gets five explicit check verdicts.
2. Screener outputs distinguish `PASS`, `BORDERLINE_PASS`, and `FAIL`.
3. At least the most repetitive Step 2 calculations are handled by deterministic helpers.
4. Analysts receive structured Step 2 evidence, not only free-form flags.
5. A small regression set demonstrates repeatable first-filter behavior.

## Risks

### Risk 1: Over-engineering the screener

If Phase 1 tries to encode every nuance of the investing method into hard logic, it will become brittle and slow.

Mitigation:
- keep helpers small
- keep final borderline judgment available
- focus on evidence structure first

### Risk 2: False precision

Adding numeric helpers can create the illusion that a judgment problem has been fully solved.

Mitigation:
- always show evidence plus verdict
- keep a narrow borderline state
- do not pretend screening-stage rough valuation is final valuation

### Risk 3: Too many borderline passes

If the system becomes too permissive, analysts get flooded and Phase 1 loses its purpose.

Mitigation:
- define strict borderline conditions
- reject clean fails early

## Recommended Execution Sequence

1. Update screener spec
2. Add minimal helper commands in `calc-score.sh`
3. Update orchestrator handoff
4. Run Step 2 verification set

## Bottom Line

Phase 1 is the right next move because it tightens the bouncer at the door without flattening the methodology into a purely mechanical system. The aim is not "fully automated screening." The aim is:

same stock + same data + same thresholds = same first-filter story

with explicit room for narrow, auditable borderline judgment where the EdenFinTech method genuinely requires it.
