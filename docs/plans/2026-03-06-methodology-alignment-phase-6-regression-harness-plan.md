# Methodology Alignment Phase 6 Plan

Date: 2026-03-06
Phase: 6
Title: Add Methodology Regression Harness

Depends on:
- `docs/plans/2026-03-06-methodology-alignment-map.md`
- `docs/plans/2026-03-06-methodology-alignment-implementation-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-1-first-filter-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-2-peer-ranking-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-3-catalyst-quality-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-4-monitoring-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-5-downside-calibration-plan.md`

## Goal

Create a lightweight regression harness that tests the scanner against known EdenFinTech-style cases so future changes can be evaluated against methodology outcomes, not just code execution.

This phase turns "alignment" from a one-time review into an ongoing discipline.

## Why Phase 6 Matters

Without regression coverage:
- prompts drift
- rules drift
- scoring interpretations drift
- edge-case fixes accumulate

and no one can tell whether the system is still behaving like the methodology or merely producing polished output.

The scanner now has enough moving parts that methodology fidelity needs its own verification layer:
- screener rules
- analyst rubric
- catalyst-quality logic
- downside calibration
- position sizing
- monitoring / sell logic

Phase 6 creates that layer.

## Current Weaknesses

Observed in the current project:

1. Verification exists for specific changes, but not as a standing methodology suite.
2. There is no stable set of canonical examples with expected outcomes.
3. Changes can be "locally correct" and still distort overall behavior.
4. Prompt and knowledge-file updates are not currently checked against prior methodology behavior.
5. Existing examples are scattered across scan reports and planning notes, not organized as regression assets.

## Phase Outcome

After this phase, the project should have:
- a curated set of representative cases
- expected outcome bands or classifications
- a repeatable review procedure after major changes
- a record of when the system behavior changed and why

## Scope

In scope:
- canonical case selection
- expected-outcome schema
- regression checklist
- execution guidance
- methodology verification documentation

Out of scope:
- full CI automation
- full replay of the entire pipeline on every commit
- perfect numeric determinism for all qualitative judgments

## Design Principles

### 1. Test methodology behavior, not just code paths

The harness should ask:
- did the system classify this case appropriately?
- did it reject for the right reason?
- did it surface the right risk?

not just:
- did the script return JSON?

### 2. Keep expectations banded, not over-specified

Many outputs are still judgment-based. Regression should focus on:
- classification
- direction
- key reasons
- guardrail compliance

rather than exact word-for-word report matching.

### 3. Cover the full method lifecycle

The harness should not stop at new-idea scans. It should also cover:
- first filter
- peer ranking
- catalyst quality
- downside behavior
- holding review / sell logic

### 4. Record intentional behavior changes

If a methodology change is deliberate, the harness should be updated with a note explaining why, not silently overwritten.

## Regression Asset Types

### 1. New-Idea Cases

Cases used to test Steps 1-7:
- should pass screening
- should fail screening
- should reach analysis but get rejected
- should emerge as a legitimate candidate

### 2. Downside Calibration Cases

Cases used to test the downside guardrail:
- clean stable business
- cyclical business
- growth business
- working-capital distortion case
- negative TBV asset-light case

### 3. Holding Review Cases

Cases used to test Step 8:
- thesis intact despite price decline
- low forward returns after rerating
- slower thesis, not broken
- genuine thesis break

### 4. Closed-Position Review Cases

Cases used to test the post-mortem template:
- good outcome from correct thesis
- good outcome from flawed thesis
- bad outcome from thesis break
- bad outcome from sizing / timing error

## Expected Outcome Schema

Each regression case should define expectations in a coarse but enforceable way.

### Recommended schema

```markdown
## Case: TICKER

- Case type: screening / cluster / catalyst / downside / holding-review
- Source date: YYYY-MM-DD
- Context: why this case is in the suite

### Expected Outcome
- Classification: PASS / WATCHLIST / REJECT / HOLD / EXIT / etc.
- Critical reason(s): 1-3 non-negotiable reasons
- Forbidden outcome(s): outcomes that would indicate methodology drift
- Tolerance:
  - exact score required? no
  - score band required? yes/no
  - downside band required? yes/no
```

This keeps the harness usable even when wording changes.

## Candidate Canonical Case Set

The first version should stay small and high-signal.

### Suggested minimum set

1. **WMT-style valuation fail**
   - great business
   - fails due to inability to meet hurdle at current price

2. **CPS-style solvency borderline**
   - scary balance sheet
   - broken chart
   - survivability risk priced in

3. **BRBR-style downside calibration edge case**
   - good for testing reasonable-worst-case behavior

4. **PYPL-style litigation friction case**
   - good business
   - blocked by epistemic / legal uncertainty

5. **Permanent-pass margin erosion case**
   - useful for Step 3 regression

6. **No-real-catalyst case**
   - useful for Step 4 regression

7. **Holding intact despite drawdown**
   - useful for Step 8 regression

8. **Forward returns too low after rerating**
   - useful for sell-trigger regression

### Expansion later

Once the harness is stable, add:
- one China/geopolitical case
- one healthcare higher-multiple case
- one cyclical recovery case
- one dilution-fail case

## Implementation Workstreams

### Workstream A: Define Case Format

#### Objective

Create a standard format for regression cases so all future cases are comparable.

#### Files
- Create: regression template under `docs/plans/`, `docs/project_notes/`, or `.planning/`

#### Required fields

- case id
- ticker
- case type
- source artifact
- expected classification
- critical reasons
- forbidden outcomes
- tolerance notes

#### Success criteria

- New cases can be added consistently.

### Workstream B: Build Initial Canonical Suite

#### Objective

Assemble the first set of high-value methodology cases from existing materials.

#### Files
- Create: canonical regression suite document

#### Sources

Use existing project assets where possible:
- `docs/scans/*.md`
- `docs/plans/*.md`
- `.planning/phases/03-agent-integration/03-e2e-verification.md`
- methodology docs under `/home/laudes/zoot/projects/strategy_EdenFinTech/edenfintech-system`

#### Success criteria

- At least 6-8 representative cases exist.
- The suite covers both new-idea and monitoring logic.

### Workstream C: Define Regression Review Procedure

#### Objective

Make regression checking a standard step after important changes.

#### Files
- Modify: `README.md`
- Modify: `CLAUDE.md`
- Possibly add a verification procedure note

#### Trigger events

Run the methodology regression harness after changes to:
- `knowledge/strategy-rules.md`
- `knowledge/scoring-formulas.md`
- `knowledge/valuation-guidelines.md`
- `.claude/agents/screener.md`
- `.claude/agents/analyst.md`
- `.claude/agents/orchestrator.md`
- `scripts/calc-score.sh`

#### Procedure

1. Identify affected regression cases
2. Run the relevant workflow or review against the case expectations
3. Record:
   - pass
   - drift detected
   - intentional change with rationale

#### Success criteria

- Regression is no longer ad hoc.

### Workstream D: Define Drift Categories

#### Objective

Separate harmless wording changes from real methodology drift.

#### Files
- Add to regression documentation

#### Drift categories

1. **No drift**
   - classification unchanged
   - critical reasons intact

2. **Soft drift**
   - wording changed
   - classification intact
   - no methodology concern

3. **Material drift**
   - classification changed
   - key reason changed
   - score / downside moved enough to alter decision quality

4. **Intentional drift**
   - behavior changed on purpose
   - documented and accepted

#### Success criteria

- Reviewers can interpret changes consistently.

### Workstream E: Add Change Log For Regression Baseline Updates

#### Objective

Prevent silent normalization of methodology drift.

#### Files
- Create: regression changelog doc

#### Required entries

When a baseline expectation changes:
- date
- changed case
- old expectation
- new expectation
- rationale
- approving note

#### Success criteria

- Regression expectations remain historically understandable.

### Workstream F: Lightweight Execution Support

#### Objective

Optionally provide a small helper or checklist tool to make regression review less manual.

#### Files
- Possibly create: small script or markdown checklist

#### Guardrail

Do not over-invest in automation before the case set and expectations are stable.

The first version can be mostly document-driven.

#### Success criteria

- Regression review is easy enough that it actually gets used.

## File-Level Task Plan

### Task 1: Create Regression Template

Define the standard case format.

### Task 2: Build Initial Canonical Suite

Create a first set of representative methodology cases from existing examples.

### Task 3: Document Review Procedure

Add instructions for when and how to run regression review after major changes.

### Task 4: Add Drift Categories And Changelog

Document how to interpret and record changes in behavior.

### Task 5: Pilot On Recent Methodology Changes

Use the harness to evaluate at least one recent change set, ideally downside guardrail behavior.

## Acceptance Criteria

Phase 6 is complete when all of the following are true:

1. The project has a documented regression case format.
2. A canonical initial case suite exists.
3. The suite covers both new-idea and holding-review behavior.
4. A standard review procedure is documented.
5. Drift categories are defined.
6. Baseline expectation changes require explicit documentation.

## Risks

### Risk 1: Overfitting to a few examples

A small suite can create false confidence.

Mitigation:
- keep cases representative
- expand gradually
- focus on diverse failure modes

### Risk 2: Expectation precision that is too tight

If the harness expects exact prose or exact scores where judgment remains involved, it will become noisy and ignored.

Mitigation:
- use banded expectations
- focus on classification and reasons

### Risk 3: Regression process becomes shelfware

If the procedure is too heavy, it will not be run.

Mitigation:
- keep the first version lightweight
- tie it to high-impact file changes only

## Recommended Execution Sequence

1. Create regression template
2. build canonical suite
3. define review procedure
4. define drift categories and changelog
5. pilot the harness on a recent change set

## Bottom Line

Phase 6 makes methodology alignment durable.

Without it, the project can improve locally while drifting globally.
With it, the scanner gains a memory:
- what "good" behavior looks like
- what changed
- whether the system still behaves like the EdenFinTech method

That is what turns a set of good plans into a maintainable investing system.
