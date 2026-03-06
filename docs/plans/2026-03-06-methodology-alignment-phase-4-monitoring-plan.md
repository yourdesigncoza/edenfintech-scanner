# Methodology Alignment Phase 4 Plan

Date: 2026-03-06
Phase: 4
Title: Build Step 8 Monitoring Workflow

Depends on:
- `docs/plans/2026-03-06-methodology-alignment-map.md`
- `docs/plans/2026-03-06-methodology-alignment-implementation-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-3-catalyst-quality-plan.md`

Primary methodology sources:
- `knowledge/strategy-rules.md`
- `/home/laudes/zoot/projects/strategy_EdenFinTech/edenfintech-system/08-AFTER-THE-BUY.md`
- `/home/laudes/zoot/projects/strategy_EdenFinTech/edenfintech-system/06-THE-DECISION.md`
- `/home/laudes/zoot/projects/strategy_EdenFinTech/edenfintech-system/07-POSITION-SIZING.md`

## Goal

Extend the scanner from a new-idea engine into a full methodology workflow by adding a structured process for monitoring existing holdings, evaluating thesis integrity, recalculating forward returns, and supporting sell decisions.

This phase is about Step 8 alignment:
- track catalysts after purchase
- check management consistency
- watch for margin drift and competitor slippage
- distinguish price volatility from thesis breaks
- review whether forward returns still clear the hurdle

## Why Phase 4 Matters

The current scanner is strongest at:
- finding candidates
- analyzing candidates
- ranking candidates

But the EdenFinTech method explicitly continues after purchase. In the original system, conviction is maintained by staying close to the business over time, not by passively holding a score from the original report.

Without a Step 8 workflow, the scanner is only half of the methodology.

## Current Weaknesses

Observed in the current project:

1. `knowledge/current-portfolio.md` is useful context, but it is not a monitoring system.
2. Existing positions are referenced in portfolio-impact sections, but not reviewed with a dedicated holding-review workflow.
3. There is no structured way to compare current fundamentals against the original thesis.
4. Sell-trigger logic exists in documentation, but not in an operational workflow.
5. There is no post-mortem loop for closed positions.

## Phase Outcome

After this phase, the project should support a repeatable holding-review process that can answer:
- Is the original thesis still intact?
- Are catalysts showing up on schedule?
- Has management execution improved or deteriorated?
- Do forward returns still justify holding?
- Is the position a hold, reduce, exit, or add candidate?

## Scope

In scope:
- holding-review workflow
- current-portfolio data structure improvements
- thesis tracking
- catalyst-progress tracking
- forward-return refresh
- sell-trigger checklist
- post-mortem template for closed positions

Out of scope:
- broker integration
- automated trading
- live portfolio PnL dashboards

## Design Principles

### 1. Preserve the core idea

The methodology is clear:
- price declines are not thesis breaks
- business changes are thesis breaks
- forward returns matter after a run-up

The workflow must keep those distinctions explicit.

### 2. Monitoring should be thesis-centered, not news-centered

The system should review the business against the thesis, not drown in daily headlines.

### 3. Favor structured review over constant churn

The goal is informed patience, not endless tinkering.

### 4. Support decision categories that match the method

The workflow should make it natural to conclude:
- `HOLD`
- `HOLD_AND_MONITOR`
- `ADD_CANDIDATE`
- `TRIM / REDUCE`
- `EXIT`

without forcing action.

## Target State

For an existing holding, the system should be able to produce a review like:

```markdown
# Holding Review: TICKER

## Thesis Status
- Original thesis: intact / weakened / broken
- Current forward returns: X%
- Sell trigger status: none / trigger 1 / trigger 2 / trigger 3

## Catalyst Tracking
| Catalyst | Original Timing | Current Status | Evidence | Verdict |
|----------|-----------------|----------------|----------|---------|
| Margin recovery | 2026-2027 | ahead of plan | GM +220bps YoY | ON_TRACK |
| New CEO reset | 2026 | too early | strategic actions announced | DEVELOPING |

## Management Consistency
- What management said
- What management did
- Match / mismatch

## Margin / Competitor Drift
- Unexpected margin changes
- Competitor position change
- Open risks

## Holding Verdict
- HOLD
- Reason: thesis intact, forward returns still above hurdle
```

## Implementation Workstreams

### Workstream A: Add A Dedicated Holding-Review Workflow

#### Objective

Create a distinct workflow for reviewing existing positions rather than reusing the new-idea scan path.

#### Files
- Create: new skill or workflow doc under `.claude/skills/`
- Possibly create: new agent under `.claude/agents/`
- Modify: `README.md` and/or `CLAUDE.md`

#### Design options

Option 1: New skill
- `/review-holding TICKER`
- lightweight and clear

Option 2: Extend `/scan-stocks`
- allows ticker review mode
- but risks mixing new-idea and existing-position logic

Recommended:
- create a separate holding-review skill or command

#### Required outputs

The review should explicitly cover:
1. catalyst progress
2. management consistency
3. margin drift
4. competitor drift
5. forward returns
6. sell-trigger status

#### Success criteria

- Existing positions can be reviewed independently of new idea generation.
- The workflow feels like Step 8, not Step 1 repeated.

### Workstream B: Upgrade Portfolio Data Model

#### Objective

Turn `knowledge/current-portfolio.md` into a more useful monitoring input.

#### Files
- Modify: `knowledge/current-portfolio.md`
- Possibly add a template or companion file

#### New fields to support

For each active holding:
- ticker
- theme / catalyst bucket
- entry date
- cost basis
- current thesis summary
- original catalysts
- original key risks
- last review date
- current thesis status
- current forward return estimate
- next check item

#### Design consideration

Do not force too much structure into a hard-to-maintain file. If `current-portfolio.md` becomes unwieldy, split into:
- overview file
- one file per holding

#### Success criteria

- The holding-review workflow has enough stored context to compare "then vs now."

### Workstream C: Add Forward-Return Refresh Logic

#### Objective

Operationalize the sell logic tied to forward returns rather than just original upside.

#### Files
- Modify: `scripts/calc-score.sh` only if a helper is useful
- Modify: holding-review instructions

#### Core requirement

The review should recalculate:
- current valuation target
- forward CAGR from current price
- whether the 30% hurdle still holds
- whether forward returns have fallen below 10-15% after a sharp move

#### Notes

This does not require a brand-new valuation framework. It requires re-running the same valuation logic with current price and current assumptions.

#### Success criteria

- The system can explicitly say whether the position still clears the hurdle from today's price.

### Workstream D: Add Thesis-Integrity Checklist

#### Objective

Make thesis-break assessment concrete and business-centered.

#### Files
- Create or modify holding-review workflow docs
- Possibly update `knowledge/strategy-rules.md` for Step 8 detail

#### Required checklist

The review must assess:
1. Are catalysts showing up on schedule?
2. Is management saying one thing and doing another?
3. Are margins shifting unexpectedly?
4. Are competitors pulling ahead?
5. Which macro events actually matter to this business?

These map directly to the methodology.

#### Verdict states

For thesis status, require one of:
- `INTACT`
- `INTACT_BUT_SLOWER`
- `WEAKENED`
- `BROKEN`

#### Success criteria

- Thesis status is tied to business evidence, not price action.

### Workstream E: Add Sell-Trigger Decision Layer

#### Objective

Operationalize the three documented sell triggers.

#### Files
- Modify: holding-review workflow docs
- Possibly update `knowledge/strategy-rules.md` or `knowledge/scoring-formulas.md` for clarity

#### Required sell checks

1. **Target reached / forward returns < 30% hurdle**
2. **Rapid move / forward returns < 10-15%**
3. **Fundamental thesis break**

#### Output requirement

The review should explicitly state:
- `Sell trigger 1: yes/no`
- `Sell trigger 2: yes/no`
- `Sell trigger 3: yes/no`

If any are `yes`, the review must explain why with evidence.

#### Success criteria

- Sell logic becomes operational and reviewable.
- The system can distinguish "hold despite drop" from "exit due to thesis break."

### Workstream F: Add Post-Mortem Template For Closed Positions

#### Objective

Support the feedback loop described in the methodology.

#### Files
- Create: template under `docs/` or `knowledge/`
- Possibly add a new command/workflow for closed-position review

#### Required post-mortem questions

1. Was the original thesis right or wrong?
2. Were the catalysts identified correctly?
3. Was downside assessed reasonably?
4. Was sizing appropriate?
5. What changed vs expectations?
6. What mistake or blind spot should be learned from?

#### Success criteria

- Closed positions produce reusable learning artifacts.

### Workstream G: Verification Cases

#### Objective

Test that the Step 8 workflow reaches sensible hold/sell conclusions.

#### Files
- Create: verification note under `docs/plans/` or `.planning/`

#### Test case types

1. A holding that is down, but thesis remains intact
2. A holding that has rerated and now offers low forward returns
3. A holding where one catalyst slipped, but thesis is still alive
4. A holding with a genuine thesis break

#### Verification questions

1. Does the review avoid treating price decline as a thesis break?
2. Does it identify low forward returns after a rally?
3. Does it distinguish "slower" from "broken"?
4. Does the final verdict map to the documented sell triggers?

## File-Level Task Plan

### Task 1: Create Holding-Review Workflow

Add a dedicated holding-review skill / agent path that:
- pulls current data
- loads stored thesis context
- runs a Step 8 review

### Task 2: Upgrade Portfolio Context Storage

Modify `knowledge/current-portfolio.md` or split it into a richer holding-tracking structure.

### Task 3: Add Forward-Return Recheck

Wire current-price-based return refresh into the holding-review flow.

### Task 4: Add Sell-Trigger Checklist

Make the three sell triggers explicit and mandatory in holding reviews.

### Task 5: Add Closed-Position Post-Mortem Template

Create a consistent way to learn from exits.

### Task 6: Verify On Representative Cases

Run a small set of holdings through the workflow and document whether the outputs match the methodology.

## Acceptance Criteria

Phase 4 is complete when all of the following are true:

1. The project has a dedicated holding-review workflow.
2. Existing positions can be reviewed against the original thesis.
3. Forward returns can be recalculated from today's price.
4. Sell-trigger status is explicit and evidence-backed.
5. Thesis status distinguishes intact, weakened, and broken.
6. Closed positions can be reviewed via a structured post-mortem template.

## Risks

### Risk 1: Overcomplicating portfolio tracking

If too much structure is added too early, portfolio maintenance will become burdensome.

Mitigation:
- start simple
- only store fields needed for review
- split files only if necessary

### Risk 2: Re-analyzing holdings from scratch every time

That would make monitoring expensive and noisy.

Mitigation:
- use original thesis context as anchor
- review deltas, not the entire company from zero

### Risk 3: Triggering churn

A monitoring workflow can encourage overreaction if it is too sensitive.

Mitigation:
- keep the focus on business change, not market movement
- preserve "hold and monitor" as a normal outcome

## Recommended Execution Sequence

1. Create holding-review workflow
2. upgrade portfolio context storage
3. add forward-return refresh
4. add sell-trigger checklist
5. add post-mortem template
6. run verification set

## Bottom Line

Phase 4 closes the biggest lifecycle gap in the scanner.

Without it, the project helps find stocks but only partially supports the full EdenFinTech method.
With it, the system becomes capable of:
- finding ideas
- evaluating ideas
- monitoring positions
- supporting disciplined exits
- learning from completed positions

That is the difference between a stock picker and a real investing process.
