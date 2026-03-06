# Methodology Alignment Phase 5 Plan

Date: 2026-03-06
Phase: 5
Title: Calibrate Downside Guardrail

Depends on:
- `docs/plans/2026-03-06-methodology-alignment-map.md`
- `docs/plans/2026-03-06-methodology-alignment-implementation-plan.md`
- `docs/plans/2026-03-06-downside-guardrail-proposed-solution.md`
- `docs/plans/2026-03-06-downside-guardrail-verification-review.md`
- `.planning/phases/03-agent-integration/03-e2e-verification.md`

Primary methodology sources:
- `knowledge/strategy-rules.md`
- `knowledge/scoring-formulas.md`
- `knowledge/valuation-guidelines.md`
- `/home/laudes/zoot/projects/strategy_EdenFinTech/edenfintech-system/05-VALUATION.md`
- `/home/laudes/zoot/projects/strategy_EdenFinTech/edenfintech-system/06-THE-DECISION.md`

## Goal

Refine the trough-anchored downside system so it remains:
- reproducible
- auditable
- conservative

while becoming more faithful to the EdenFinTech idea of a **reasonable worst case**, rather than a mechanically extreme combination of worst inputs that may not coexist in reality.

This phase does **not** roll back the downside guardrail. It calibrates it.

## Why Phase 5 Matters

The downside estimate is the heaviest scoring input. The recent guardrail work solved the biggest old problem:

- same stock + same data now tends to produce the same downside estimate

But verification exposed a new problem:

- some mechanically valid downside outputs are too punitive to function as a useful scoring input

The BRBR example is the clearest case:
- trough revenue came from one year
- trough FCF margin came from a different, highly distorted year
- the combination was reproducible, but arguably closer to an "Armageddon stack" than a reasonable worst case

If left uncalibrated, the system may systematically mis-rank growth or working-capital-volatile names.

## Current Weaknesses

Observed in current downside implementation and verification:

1. Trough revenue and trough margin are chosen independently with no compatibility check.
2. FCF-margin troughs can be dominated by working-capital anomalies rather than enduring economics.
3. Growth companies can get "time machine" revenue floors from much smaller earlier revenue bases.
4. The mechanical floor can drift far from the spirit of "reasonable worst case" while still passing methodology compliance.
5. The project has reproducibility checks, but not yet enough calibration checks across varied company types.

## Phase Outcome

After this phase, downside estimation should:
- remain deterministic
- stay anchored to historical data
- better reflect plausible stress paths
- avoid reintroducing narrative-driven optimism
- be regression-tested on representative case types

## Scope

In scope:
- trough revenue selection rules
- trough margin selection rules
- edge-case handling for growth and working-capital distortion
- updated analyst/orchestrator instructions if needed
- regression verification set

Out of scope:
- full EV-based valuation overhaul
- multi-model waterfall system
- replacing the 4-input floor formula

## Design Principles

### 1. Reproducibility stays non-negotiable

Any calibration change must remain algorithmic and auditable. The project should not go back to "analyst picks a downside they like."

### 2. Reasonable worst case, not maximum pain

The methodology wants downside protection, but still within a sensible investment framework.

### 3. Pessimism should remain easier than optimism

The asymmetric override rule stays:
- harsher floor is allowed
- more optimistic floor must be justified

### 4. Edge-case fixes must generalize

If calibration is changed for BRBR, it should be because the rule is better, not because BRBR looked odd.

## Calibration Questions To Resolve

### Question 1: Revenue floor for growth companies

Current issue:
- using the minimum 5-year revenue can create an implausibly low scale floor for companies that grew rapidly and structurally

Need to decide whether the revenue trough should remain:
- pure 5-year minimum

or become:
- the more conservative of a historical minimum and a bounded decline from current scale

The key tradeoff:
- pure minimum is reproducible but may be too punitive
- bounded decline may be more realistic but must not become optimism laundering

### Question 2: Margin trough outlier handling

Current issue:
- lowest FCF margin may reflect a temporary working-capital collapse rather than durable earnings impairment

Need to decide whether outlier margins should:
- always stand as-is
- or be excluded by an explicit algorithmic rule

Any exclusion rule must be:
- mechanical
- documented
- resistant to analyst discretion

### Question 3: Input compatibility

Current issue:
- the system can combine the worst revenue year and the worst margin year even if those two states are unlikely to coexist

Need to decide whether the floor should allow:
- cross-year independent trough selection
- paired stress-year selection
- or a constrained compatibility rule

### Question 4: Calibration by company type

Current issue:
- one-size-fits-all trough rules may work differently for:
  - mature stable businesses
  - cyclical companies
  - growth companies
  - working-capital volatile businesses

Need to determine whether calibration should remain universal or vary by case type using explicit conditions.

## Candidate Calibration Approaches

### Option A: Keep Current Rules, Add Only Regression Coverage

#### Description

Retain:
- 5-year minimum revenue
- 5-year minimum FCF margin
- baseline-minus-discount multiple

but improve monitoring and document known edge cases.

#### Pros
- maximum reproducibility
- simplest ruleset
- no logic churn

#### Cons
- leaves BRBR-style distortion unresolved
- may keep producing unusable floor outputs in certain company types

### Option B: Add Revenue Bounding For Growth Cases

#### Description

For companies above a defined historical growth threshold, set the revenue floor as:
- max(5-year minimum revenue, bounded decline from current revenue)

The bound must be explicitly defined and documented.

#### Pros
- reduces "time machine" revenue floors
- better reflects current business scale in mature-growth turnarounds

#### Cons
- risks becoming too forgiving if bound is too mild
- needs careful rule design

### Option C: Add Margin Outlier Exclusion Rule

#### Description

If the lowest FCF margin is dramatically below the next-lowest observed level, automatically use the next-lowest.

This rule must be explicit and non-discretionary.

#### Pros
- filters working-capital flash-crash years
- preserves deterministic selection

#### Cons
- could hide legitimate stress years if the rule is too blunt

### Option D: Add Stress-Path Compatibility Rule

#### Description

Require floor inputs to come from a more internally coherent stress path rather than independently selecting the absolute minimum of each component.

Possible variants:
- use the single worst fiscal year as base stress year
- allow one adjusted component but not all independent minima
- require explicit justification for cross-year trough mixing

#### Pros
- better matches "reasonable worst case"
- reduces Frankenstein scenarios

#### Cons
- more complex than pure minimum selection
- harder to explain and verify

## Recommended Direction

Recommended direction for this phase:

1. keep the mechanical floor model
2. preserve asymmetric override
3. add the minimum necessary calibration rules only if they are explicit and auditable

That means prioritizing:
- margin outlier handling
- revenue floor treatment for clear growth-company edge cases
- regression verification

and avoiding:
- subjective analyst overrides as default
- wholesale model changes

## Implementation Workstreams

### Workstream A: Define Calibration Policy

#### Objective

Choose and document the final calibration rules for:
- revenue troughs
- margin troughs
- input compatibility

#### Files
- Modify: `knowledge/strategy-rules.md`
- Modify: `knowledge/valuation-guidelines.md`
- Possibly modify: `knowledge/scoring-formulas.md`

#### Required outputs

Document:
- default trough selection rule
- explicit edge-case exceptions
- rationale for each exception
- examples of when the exception applies

#### Success criteria

- The policy is clear enough for both analyst and orchestrator to apply consistently.

### Workstream B: Update Helper / Calculator Logic If Needed

#### Objective

If calibration requires new deterministic logic, add it to the calculator layer rather than leaving it implicit in prompts.

#### Files
- Modify: `scripts/calc-score.sh`

#### Possible additions

Depending on final design:
- helper to evaluate margin-outlier status
- helper to select bounded revenue floor
- helper to summarize trough-input selection reasoning

#### Guardrail

Do not turn `calc-score.sh` into a giant valuation engine. Add only what is needed for transparent, repeatable downside selection.

#### Success criteria

- Any new calibration rule can be applied repeatably through code or explicit deterministic logic.

### Workstream C: Update Analyst Instructions

#### Objective

Ensure the analyst uses the calibrated rules when selecting trough inputs.

#### Files
- Modify: `.claude/agents/analyst.md`

#### Changes

1. Update Step 5 downside instructions to reflect calibrated rules.
2. Require the analyst to state:
   - whether default trough rule was used
   - whether a defined calibration exception was triggered
3. Require calibrated input selection to appear in the trough path.

#### Success criteria

- The analyst cannot silently switch downside logic.

### Workstream D: Update Orchestrator Audit

#### Objective

Ensure downside compliance includes calibration-rule adherence, not just floor presence.

#### Files
- Modify: `.claude/agents/orchestrator.md`

#### Audit additions

For candidates using calibrated rules, verify:
- the rule is one of the approved calibration rules
- the trigger condition is documented
- the trough path reflects the adjusted logic

If not:
- reject as `downside_non_compliant`

#### Success criteria

- Calibrated downside remains auditable.

### Workstream E: Build A Regression Verification Set

#### Objective

Test the downside system across company types, not only BRBR/PYPL.

#### Files
- Create: verification note under `docs/plans/` or `.planning/`

#### Required case types

1. Growth company with early low-revenue years
2. Working-capital volatile company with one anomalous FCF-margin trough
3. Mature stable business
4. Cyclical business
5. Asset-light company with negative TBV
6. Company where current pure trough logic already behaves well

#### Suggested base cases

Existing internal examples where applicable:
- BRBR
- PYPL

Add at least 3-4 more names covering different patterns.

#### Verification questions

1. Is downside still reproducible?
2. Does the calibrated floor remain conservative?
3. Does the result better reflect a plausible stress path?
4. Has analyst discretion been reintroduced in disguised form?

## File-Level Task Plan

### Task 1: Decide Calibration Rules

Document the final policy for:
- revenue floor treatment
- margin outlier treatment
- input compatibility

### Task 2: Implement Deterministic Support

If needed, add helper logic in `scripts/calc-score.sh`.

### Task 3: Update Analyst / Orchestrator Rules

Wire the new calibration policy into:
- `.claude/agents/analyst.md`
- `.claude/agents/orchestrator.md`

### Task 4: Run Regression Verification

Compare old vs calibrated downside outputs on representative names and document whether:
- reproducibility holds
- calibration improves
- no new optimism loopholes appear

## Acceptance Criteria

Phase 5 is complete when all of the following are true:

1. The downside system remains deterministic.
2. Calibration rules are explicitly documented.
3. Analysts must declare whether default or calibrated rules were used.
4. The orchestrator audits calibration-rule compliance.
5. A multi-case regression set shows improved credibility without reopening large variance.

## Risks

### Risk 1: Reintroducing analyst variance

If calibration is framed too loosely, the project loses the main benefit of the guardrail.

Mitigation:
- algorithmic rules only
- explicit audit
- no open-ended discretion

### Risk 2: Over-correcting toward optimism

If edge-case relief is too generous, downside becomes flattering again.

Mitigation:
- keep asymmetric override
- require clear trigger conditions
- verify on difficult cases

### Risk 3: Adding too much complexity

If calibration becomes a mini-framework inside the framework, it will confuse the analyst and weaken adoption.

Mitigation:
- adopt only the minimum rules needed
- prefer simple defaults plus narrow exceptions

## Recommended Execution Sequence

1. Choose calibration policy
2. implement any deterministic support needed
3. update analyst instructions
4. update orchestrator audit
5. run regression verification

## Bottom Line

Phase 5 is about improving **credibility without sacrificing reproducibility**.

The downside guardrail was the right direction. This phase ensures it behaves like a disciplined EdenFinTech downside estimate:
- conservative
- explainable
- repeatable
- still usable as a scoring input

rather than a mechanically correct but occasionally distorted floor.
