# Methodology Alignment Implementation Plan

Date: 2026-03-06
Depends on:
- `docs/plans/2026-03-06-methodology-alignment-map.md`

## Goal

Move the scanner from "method-inspired research assistant" to "method-aligned execution system" by tightening enforcement at the points where the EdenFinTech process is currently most dependent on prompt judgment.

## Principle

Do not try to automate away the investing method. Automate the checks, audit the judgment, and preserve human review where the methodology is genuinely discretionary.

## Priority Order

1. Strengthen hard gates before adding new intelligence
2. Convert ranking heuristics into auditable rubrics
3. Add monitoring and sell-discipline workflows
4. Calibrate downside without reintroducing narrative drift

## Phase 1: Harden Step 2 First Filter

### Objective

Convert the five first-filter checks into reusable, explicit decision outputs that are less dependent on free-form agent reasoning.

### Why this phase comes first

Bad ideas should die early. The first filter is one of the core advantages of the methodology, and strengthening it reduces wasted analysis budget and downstream noise.

### Scope

- solvency
- dilution
- revenue trend
- ROIC / ROCE
- valuation sanity

### Deliverables

- A structured check schema for all five filters
- Deterministic helper commands or reusable shell snippets where possible
- Standardized screener output for pass / fail / borderline / evidence
- Reduced prompt ambiguity in `.claude/agents/screener.md`

### Proposed changes

1. Add reusable calculator or helper support for:
   - revenue per share trend
   - share count trend
   - ROIC median
   - simple solvency summary metrics
2. Require the screener to emit a compact per-check result block:
   - check
   - verdict
   - threshold
   - evidence
3. Distinguish:
   - hard fail
   - borderline pass with flag
   - pass cleanly
4. Tighten the valuation pre-check so rough 30% hurdle screening is less narrative

### Success criteria

- Same stock run twice produces the same Step 2 filter verdict absent data changes
- Borderline names are explicitly flagged with reasons, not buried in prose
- Rejected names have auditable evidence for the failing check

## Phase 2: Make Step 3 Peer Ranking Auditable

### Objective

Turn competitor comparison from a well-written table into a disciplined ranking process aligned with John's quality hierarchy.

### Why this matters

The original methodology is clear that relative quality matters and that balance sheet strength comes first. Right now the scanner describes that priority without enforcing it.

### Scope

- cluster comparisons
- quality ranking
- permanent-pass margin trend handling

### Deliverables

- A peer-ranking rubric used by the analyst for each cluster
- A weighted quality summary aligned to:
  1. balance sheet strength
  2. niche / margins / business quality
  3. upside and risk-adjusted return
- Explicit permanent-pass detection for long-term margin erosion

### Proposed changes

1. Add a structured cluster-ranking table to `.claude/agents/analyst.md`
2. Require the analyst to assign sub-rank judgments for:
   - survival quality
   - business quality
   - return quality
3. Add a simple cluster summary verdict:
   - clear winner
   - winner with caveats
   - no clear winner
4. Add an orchestrator audit for missing cluster-ranking rationale

### Success criteria

- Cluster outputs make the "why this name over peers" decision obvious
- Balance sheet strength is explicitly surfaced, not implied
- Margin-erosion permanent passes are handled consistently

## Phase 3: Formalize Step 4 Catalyst Quality

### Objective

Keep the hard rule "no catalysts = pass" but improve quality control on what counts as a real catalyst.

### Why this matters

This is one of the easiest places for LLMs to hallucinate plausible-sounding but weak investment reasons.

### Scope

- catalyst identification
- management fix specificity
- moat evidence quality

### Deliverables

- A catalyst-quality rubric
- Explicit distinction between:
  - real catalyst
  - supporting tailwind
  - vague hope
- Better report structure for issues + fixes

### Proposed changes

1. Add catalyst grading criteria in `.claude/agents/analyst.md`:
   - specific
   - time-bound
   - measurable
   - management-linked or externally observable
   - not purely macro wishcasting
2. Require analysts to label each item as:
   - catalyst
   - tailwind
   - monitor item
3. Require "issues and fixes" to be paired:
   - problem
   - specific management action
   - evidence of progress
4. Add a rejection trigger for catalysts that are all vague or non-time-bound

### Success criteria

- Fewer false-positive "catalysts"
- Clearer distinction between thesis driver and supporting context
- Better alignment with John's insistence on concrete, measurable change

## Phase 4: Build Step 8 Monitoring Workflow

### Objective

Add a real post-buy operating workflow so the system covers the full EdenFinTech method rather than stopping at idea generation.

### Why this matters

This is the biggest current methodology gap. The original system spends significant effort on monitoring, thesis integrity, and sell discipline.

### Scope

- existing holdings review
- catalyst tracking
- forward return recalculation
- thesis-break checks
- post-mortem support

### Deliverables

- A new monitoring skill or command for existing holdings
- A holding-review template aligned to Step 8
- Forward-return refresh workflow
- Sell-trigger checklist

### Proposed changes

1. Add a new workflow for current holdings:
   - refresh price and core financial data
   - re-evaluate forward returns
   - check catalyst timing vs original thesis
   - check management consistency
   - check competitor drift
   - assess whether thesis is intact
2. Extend `knowledge/current-portfolio.md` structure so it stores:
   - original thesis
   - original catalysts
   - last review date
   - current forward return estimate
   - current thesis status
3. Add a post-mortem template for closed positions

### Success criteria

- The system can review an existing position using the same methodology discipline as a new idea
- Sell decisions are linked to thesis and forward returns, not price noise
- Portfolio records become living research artifacts rather than static notes

## Phase 5: Calibrate Downside Guardrail

### Objective

Keep downside reproducible while making it more credible for growth companies and distorted trough years.

### Why this matters

Downside is the heaviest score input. If it is reproducible but systematically too punitive or too optimistic in key cases, the whole ranking engine drifts.

### Scope

- trough revenue selection
- trough margin selection
- edge-case handling
- verification against known examples

### Deliverables

- A documented calibration policy for outlier trough inputs
- Updated analyst/orchestrator rules if needed
- A small set of regression test cases

### Proposed changes

1. Decide whether to keep:
   - pure lowest-5-year input selection
   - or constrained trough selection with explicit algorithmic exceptions
2. If exceptions are added, they must be algorithmic and auditable, not narrative
3. Add regression cases from real scanner outputs:
   - BRBR
   - PYPL
   - at least 3 additional names from different business types
4. Document the calibration tradeoff:
   - reproducibility
   - credibility
   - conservatism

### Success criteria

- Downside remains reproducible
- Growth-company edge cases do not automatically become absurd
- Calibration changes do not reopen large analyst-variance gaps

## Phase 6: Add Methodology Regression Harness

### Objective

Test the system against known EdenFinTech-style cases so changes can be evaluated against methodology outcomes, not just code behavior.

### Why this matters

Without regression cases, alignment will drift silently as prompts and rules evolve.

### Scope

- known buys
- known watchlists
- known passes
- rule edge cases

### Deliverables

- A fixed set of example cases
- Expected outcome bands
- A lightweight verification checklist

### Proposed changes

1. Build a methodology regression set with examples from:
   - EdenFinTech source docs
   - existing scan reports
   - future verified holdings
2. For each case, store:
   - source date
   - expected classification
   - key non-negotiable reasons
3. Use regression after major changes to:
   - scoring
   - downside rules
   - analyst prompts
   - screening logic

### Success criteria

- Major prompt or rule changes can be checked against known methodology-consistent outcomes
- Alignment becomes measurable over time

## Recommended Execution Order

1. Phase 1: Harden Step 2 first filter
2. Phase 2: Make Step 3 peer ranking auditable
3. Phase 3: Formalize Step 4 catalyst quality
4. Phase 4: Build Step 8 monitoring workflow
5. Phase 5: Calibrate downside guardrail
6. Phase 6: Add methodology regression harness

## Why this order

- Phases 1-3 improve idea quality before adding new breadth
- Phase 4 closes the biggest lifecycle gap
- Phase 5 improves ranking reliability once upstream logic is cleaner
- Phase 6 protects all earlier work from silent drift

## Near-Term Recommendation

If only one phase should be started immediately, start with **Phase 1**.

Reason:
- it sharpens the bouncer at the door
- it reduces wasted analysis effort
- it improves consistency without trying to over-automate qualitative judgment
- it is the cleanest next move from the current state of the codebase

## Bottom Line

The scanner already has the right architecture. The next stage is not a rewrite. It is a tightening exercise:
- convert hard judgments into auditable checks where possible
- preserve real discretion where the methodology truly requires it
- add the missing post-buy half of the process

That gets the project closer to a system that behaves like the EdenFinTech method rather than merely describing it well.
