# Methodology Alignment Phase 3 Plan

Date: 2026-03-06
Phase: 3
Title: Formalize Step 4 Catalyst Quality

Depends on:
- `docs/plans/2026-03-06-methodology-alignment-map.md`
- `docs/plans/2026-03-06-methodology-alignment-implementation-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-2-peer-ranking-plan.md`

Primary methodology sources:
- `knowledge/strategy-rules.md`
- `/home/laudes/zoot/projects/strategy_EdenFinTech/edenfintech-system/04-QUALITATIVE-DEEP-DIVE.md`

## Goal

Strengthen Step 4 qualitative analysis so the scanner distinguishes between:
- real catalysts
- supporting tailwinds
- vague hopes

and so that "issues and fixes" are tied to concrete management actions rather than general turnaround language.

This phase does not try to mechanize all qualitative judgment. It creates a structured rubric so the analyst must prove that a catalyst is specific, time-bound, measurable, and relevant to the thesis.

## Why Phase 3 Matters

The EdenFinTech method is explicit that:
- no catalysts = automatic pass
- vague management language is not enough
- issues must be paired with specific fixes
- conviction comes from understanding how the business is actually changing

Today the scanner asks the right Step 4 questions, but the quality bar for answers is still too narrative. LLMs are especially prone to inventing "reasonable sounding" catalysts that are really just business aspirations or macro wishes.

Phase 3 fixes that by making Step 4 more discriminating.

## Current Weaknesses

Observed in the current analyst workflow:

1. The analyst is required to identify catalysts, but not to classify their quality.
2. Tailwinds and catalysts can be blended together.
3. "Issues and fixes" often read as summaries rather than evidence-backed cause-and-response pairs.
4. Management actions can be described without measurable proof of progress.
5. A stock can technically satisfy the "has catalysts" rule even if all catalysts are vague or non-time-bound.

## Phase Outcome

After this phase, Step 4 should produce:
- a catalyst-quality record
- explicit classification of each thesis driver
- issues paired with specific management actions
- clearer rejection of vague turnaround stories

## Scope

In scope:
- catalyst identification
- catalyst quality rubric
- issues and fixes structure
- management-action evidence requirements
- analyst Step 4 output structure
- orchestrator audit for catalyst quality completeness

Out of scope:
- valuation changes
- downside calibration
- post-buy monitoring workflow

## Design Principles

### 1. Preserve the hard rule

The system must keep the original rule:
- if no real catalysts exist, the stock is a pass

### 2. Separate catalyst from context

Not every positive factor is a catalyst. Some are just supportive background conditions.

### 3. Require evidence of change, not just plans

Management saying the right words is not enough. The scanner should force a distinction between:
- announced intention
- concrete action
- measurable result

### 4. Keep the rubric simple

This phase should improve discrimination, not turn Step 4 into a bureaucratic scoring exercise.

## Target State

For each surviving stock, the analyst should produce something like:

```markdown
## Catalyst Quality Record: TICKER

| Item | Type | Specific? | Time-Bound? | Measurable? | Evidence Status | Verdict |
|------|------|-----------|-------------|-------------|-----------------|---------|
| Margin recovery from restructuring | Catalyst | Yes | Yes | Yes | concrete actions + early results | VALID_CATALYST |
| Falling rates may help demand | Tailwind | Yes | No | No | macro support only | SUPPORTING_TAILWIND |
| New CEO could improve execution | Monitor Item | Yes | Partial | Partial | leadership change only, no proof yet | WATCH_ONLY |
| Brand could recover over time | Hope | No | No | No | narrative only | INVALID |
```

This record feeds the stock's Step 4 conclusion and determines whether the no-catalyst hard rule is actually satisfied.

## Implementation Workstreams

### Workstream A: Add A Catalyst Classification Rubric

#### Objective

Force the analyst to distinguish thesis drivers from background positives.

#### Files
- Modify: `.claude/agents/analyst.md`

#### Required categories

Each identified item must be labeled as one of:
- `VALID_CATALYST`
- `SUPPORTING_TAILWIND`
- `WATCH_ONLY`
- `INVALID`

#### Required dimensions

For each item, the analyst must explicitly assess:
- Is it specific?
- Is it time-bound?
- Is it measurable?
- Is it linked to business change or market-perception change?

#### Success criteria

- The analyst cannot satisfy Step 4 by listing generic positives.
- Catalyst sections become much easier to audit.

### Workstream B: Tighten The Definition Of A Valid Catalyst

#### Objective

Make the scanner's Step 4 definition closer to John's actual method.

#### Files
- Modify: `.claude/agents/analyst.md`
- Possibly modify: `knowledge/strategy-rules.md` if wording needs refinement

#### Target definition

An item qualifies as a `VALID_CATALYST` only if most of the following are true:
- specific event or operational change
- plausible time window
- measurable effect or checkpoint
- tied to management action, regulatory event, demand inflection, divestiture, or other identifiable driver
- relevant to the core thesis rather than general optimism

Examples likely to qualify:
- announced restructuring with targeted cost savings
- regulatory approval expected in a known window
- clearly defined production ramp
- identifiable deleveraging path

Examples that should not qualify on their own:
- "the market may rerate the stock"
- "the brand is strong"
- "the business could recover over time"
- "rates might fall eventually"

#### Success criteria

- Fewer false-positive catalysts
- Better distinction between catalyst and background context

### Workstream C: Structure Issues And Fixes As Paired Evidence

#### Objective

Make "what went wrong and how it is being fixed" a real analysis step rather than a prose summary.

#### Files
- Modify: `.claude/agents/analyst.md`

#### Required structure

For each major issue, the analyst should produce:
- `Issue`
- `Management Response`
- `Evidence Of Action`
- `Evidence Of Progress`
- `Open Risk`

Example:

```markdown
| Issue | Management Response | Evidence Of Action | Evidence Of Progress | Open Risk |
|------|----------------------|-------------------|----------------------|-----------|
| Margin compression | SKU rationalization + cost program | company announced $X savings plan | gross margin up 180bps QoQ | recovery may stall if input costs stay elevated |
```

#### Success criteria

- "Issues and fixes" become traceable.
- Vague "working on it" analysis is easier to reject.

### Workstream D: Improve Management-Action Evidence Standard

#### Objective

Prevent the system from treating management promises as proof.

#### Files
- Modify: `.claude/agents/analyst.md`

#### Evidence statuses

For management-driven fixes, require one of:
- `ANNOUNCED_ONLY`
- `ACTION_UNDERWAY`
- `EARLY_RESULTS_VISIBLE`
- `PROVEN`

The analyst should not treat `ANNOUNCED_ONLY` as equivalent to an active catalyst unless there is a strong reason.

#### Success criteria

- Step 4 better reflects execution reality.
- Management quality and catalyst quality stop bleeding into each other.

### Workstream E: Add A Step 4 Completeness Audit

#### Objective

Ensure the orchestrator verifies that Step 4 produced a real catalyst-quality assessment, not just a list.

#### Files
- Modify: `.claude/agents/orchestrator.md`

#### Audit checks

Before ranking, confirm each scored candidate includes:
1. a catalyst-quality record or equivalent structured catalyst section
2. at least one `VALID_CATALYST`
3. an issues-and-fixes table or paired structure
4. evidence status for management-driven actions

If missing:
- reject with reason: `step4_non_compliant`
or
- move to rejected-at-analysis with reason: `no valid catalyst`

#### Success criteria

- The "no catalysts = pass" rule becomes enforceable in practice, not just in principle.

### Workstream F: Verification Cases

#### Objective

Test that the new rubric correctly distinguishes genuine catalysts from soft narratives.

#### Files
- Create: verification note under `docs/plans/` or `.planning/`

#### Test case types

1. A stock with clear operational catalysts and timelines
2. A stock with mostly macro tailwinds but no real catalyst
3. A stock with new management but no evidence of progress yet
4. A stock with one real catalyst plus several weak supporting points

#### Verification questions

1. Does the system identify at least one truly valid catalyst where appropriate?
2. Does it reject cases where all "catalysts" are really hopes or tailwinds?
3. Are management actions separated from management rhetoric?
4. Is the issues-and-fixes section evidence-backed?

## File-Level Task Plan

### Task 1: Update Analyst Step 4 Structure

Modify `.claude/agents/analyst.md` to require:
- catalyst classification
- catalyst-quality dimensions
- issues-and-fixes paired table
- management-action evidence status

### Task 2: Tighten Hard Rule Handling

Update `.claude/agents/analyst.md` so "no catalysts" means:
- no `VALID_CATALYST` found
- not merely "no positive factors found"

### Task 3: Add Orchestrator Step 4 Audit

Modify `.claude/agents/orchestrator.md` to verify catalyst-quality completeness before final ranking.

### Task 4: Verify On Representative Cases

Run a small set of names where catalyst quality is:
- strong
- ambiguous
- absent

and document whether the new structure improves discrimination.

## Acceptance Criteria

Phase 3 is complete when all of the following are true:

1. Each analyzed stock has a structured catalyst-quality record.
2. Items are clearly classified as catalyst, tailwind, watch-only, or invalid.
3. At least one `VALID_CATALYST` is required for a stock to survive Step 4.
4. Issues and fixes are paired with evidence of action and progress.
5. The orchestrator audits Step 4 completeness.

## Risks

### Risk 1: Excessive rigidity

Some real catalysts emerge gradually and do not fit a perfect template.

Mitigation:
- allow `WATCH_ONLY` and partial evidence states
- require at least one valid catalyst, not perfect certainty across all items

### Risk 2: Confusing catalyst quality with management quality

A strong CEO does not automatically create a valid catalyst.

Mitigation:
- separate catalyst record from management assessment
- require business-change linkage

### Risk 3: Making Step 4 overly bureaucratic

If the structure becomes too heavy, analysts may comply mechanically without improving judgment.

Mitigation:
- keep labels coarse
- require concise evidence, not long form-filling

## Recommended Execution Sequence

1. Update analyst Step 4 structure
2. Tighten valid-catalyst definition
3. Add orchestrator Step 4 audit
4. Run catalyst-quality verification set

## Bottom Line

Phase 3 makes Step 4 behave more like the actual EdenFinTech method:
- catalysts must be real
- management fixes must be concrete
- vague turnaround language is not enough

That strengthens one of the most important discretionary parts of the process without pretending it can be fully automated.
