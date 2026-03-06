# Methodology Alignment Phase 2 Plan

Date: 2026-03-06
Phase: 2
Title: Make Step 3 Peer Ranking Auditable

Depends on:
- `docs/plans/2026-03-06-methodology-alignment-map.md`
- `docs/plans/2026-03-06-methodology-alignment-implementation-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-1-first-filter-plan.md`

Primary methodology sources:
- `knowledge/strategy-rules.md`
- `/home/laudes/zoot/projects/strategy_EdenFinTech/edenfintech-system/03-DEEP-ANALYSIS.md`

## Goal

Strengthen Step 3 competitor comparison so the scanner does not merely present peer tables, but explicitly ranks candidates using the EdenFinTech quality hierarchy:

1. balance sheet strength
2. superior niche / margins / business quality
3. overall risk-adjusted return

This phase turns peer comparison into a more auditable decision process without pretending that relative business quality can be fully automated.

## Why Phase 2 Matters

The methodology is clear that a stock can look fine on its own and still fail once compared to peers. Today the scanner does the comparison, but the "winner" is still mostly the analyst's narrative conclusion.

That creates three problems:
- the ranking logic is hard to audit
- balance-sheet priority can be diluted by story quality
- weaker names can survive without a clear reason

Phase 2 fixes that by making the ranking path explicit.

## Current Weaknesses

Observed in the current analyst workflow:

1. Peer tables are present, but the path from table to winner is weakly structured.
2. The methodology's quality ordering is stated, but not enforced through a visible rubric.
3. "Permanent pass" for long-term margin erosion is described, but not explicitly audited.
4. It is hard to see why a weaker company remains alive in a cluster.
5. The orchestrator does not currently verify that a cluster ranking was methodologically complete.

## Phase Outcome

After this phase, Step 3 should produce:
- a structured cluster-ranking record
- an explicit quality hierarchy application
- a clear "winner / conditional winner / no clear winner" outcome
- documented reasons when weaker names remain in analysis

## Scope

In scope:
- cluster competitor comparison
- quality ranking rubric
- permanent-pass treatment for margin erosion
- analyst output structure for Step 3
- orchestrator audit of ranking completeness

Out of scope:
- Step 4 catalyst-quality rubric
- Step 5 valuation changes
- portfolio monitoring

## Design Principles

### 1. Respect the methodology's ordering

The original method is explicit:
- balance sheet strength comes first
- business quality and niche come second
- return potential matters, but not before survival quality

### 2. Make ranking explainable, not fake-precise

The goal is not to assign meaningless decimals. The goal is to make the analyst show how they reached the ordering.

### 3. Preserve backup-candidate logic

The method allows weaker companies to remain in contention only if:
- they did not fail an earlier step
- they offer materially higher returns
- alternatives are limited

That must be made explicit, not implied.

### 4. Separate elimination from preference

Some names should be removed because they are structurally worse.
Others should remain but rank lower. The system should distinguish those cases.

## Target State

For each cluster, the analyst should produce a record like:

```markdown
## Cluster Ranking Record: Auto Parts

| Ticker | Survival Quality | Business Quality | Return Quality | Margin Trend Gate | Final Cluster Status |
|--------|------------------|------------------|----------------|-------------------|----------------------|
| CPS | Strong | Moderate | Strong | PASS | CLEAR_WINNER |
| AAP | Moderate | Moderate | Weak | PASS | LOWER_PRIORITY |
| DORM | Strong | Strong | Moderate | PASS | CONDITIONAL_WINNER |
| XYZ | Weak | Weak | Strong | PERMANENT_PASS | ELIMINATED |

**Quality Priority Applied**
- Balance sheet winner: CPS
- Best niche / margin quality: DORM
- Highest return potential: CPS

**Cluster Verdict**
- Clear winner: CPS
- Backup candidate kept: DORM because quality is high and returns remain competitive
- Eliminated: XYZ due to persistent margin erosion
```

This becomes the auditable bridge between Step 2 filtering and Step 4 qualitative deep dive.

## Implementation Workstreams

### Workstream A: Add A Cluster Ranking Rubric

#### Objective

Make the analyst explicitly rank each stock across the three EdenFinTech Step 3 dimensions.

#### Files
- Modify: `.claude/agents/analyst.md`

#### Changes

1. Add a required `Cluster Ranking Record` section.
2. Require each surviving stock to be assessed on:
   - `Survival Quality`
   - `Business Quality`
   - `Return Quality`
3. Allowed labels should stay simple:
   - `Strong`
   - `Moderate`
   - `Weak`
4. Require a `Final Cluster Status`:
   - `CLEAR_WINNER`
   - `CONDITIONAL_WINNER`
   - `LOWER_PRIORITY`
   - `ELIMINATED`

#### Success criteria

- Every analyzed cluster has an explicit relative ranking record.
- The final winner is linked to the methodology's quality ordering.

### Workstream B: Define The Three Ranking Dimensions

#### Objective

Prevent the analyst from mixing unrelated ideas inside one vague quality judgment.

#### Files
- Modify: `.claude/agents/analyst.md`
- Possibly modify: `knowledge/strategy-rules.md` if wording needs precision

#### Dimension definitions

1. **Survival Quality**
   - leverage
   - cash runway
   - debt burden
   - interest coverage
   - ability to survive long enough for the thesis to work

2. **Business Quality**
   - margins
   - niche strength
   - moat evidence
   - industry position
   - historical capital efficiency

3. **Return Quality**
   - expected upside
   - downside profile
   - simplicity / credibility of the valuation path
   - whether return depends on too many heroic assumptions

#### Success criteria

- Analysts have a shared vocabulary for the three Step 3 judgments.
- Tables and narrative align with the methodology's logic.

### Workstream C: Formalize Permanent-Pass Margin Gate

#### Objective

Make the methodology's "clear downtrend in margins = permanent pass" rule visible and auditable.

#### Files
- Modify: `.claude/agents/analyst.md`
- Possibly modify: `.claude/agents/orchestrator.md`

#### Changes

1. Require the analyst to explicitly check:
   - gross margin trend
   - operating margin trend
   - FCF margin trend
2. If one or more margins show a clear 5+ year erosion pattern, the candidate must be labeled:
   - `PERMANENT_PASS`
   - with one-line explanation
3. A permanently passed name may still appear in the comparison table, but not advance as a real contender.

#### Success criteria

- Long-term margin erosion cannot be hidden inside general narrative.
- Permanent passes are clearly separated from merely weaker names.

### Workstream D: Formalize Backup-Candidate Logic

#### Objective

Make it explicit why a weaker company remains in the cluster after comparison.

#### Files
- Modify: `.claude/agents/analyst.md`

#### Changes

Require a short justification whenever a non-winner remains alive:

```markdown
**Why kept despite lower quality:**
- No earlier-step failure found
- Return potential is materially higher
- Limited alternative names in cluster
```

If these conditions are not met, the name should be dropped from deeper analysis.

#### Success criteria

- Weaker names survive only for reasons consistent with the methodology.
- Analysts cannot quietly carry low-quality names forward out of caution or indecision.

### Workstream E: Improve Orchestrator Audit

#### Objective

Ensure the orchestrator checks whether the analyst completed the cluster-ranking logic.

#### Files
- Modify: `.claude/agents/orchestrator.md`

#### Changes

Add a Step 3 ranking completeness audit before final report assembly:

1. Confirm each cluster contains:
   - comparison table
   - quality ordering
   - cluster ranking record
   - winner / backup / eliminated outcome
2. If a cluster is missing ranking rationale:
   - add a `cluster_ranking_incomplete` warning
   - or reject the ranking section if materially incomplete

#### Success criteria

- The orchestrator no longer treats any polished comparison write-up as equivalent to a method-aligned Step 3 ranking.

### Workstream F: Verification Cases

#### Objective

Validate that the peer-ranking step behaves consistently on known cluster types.

#### Files
- Create: verification note under `docs/plans/` or `.planning/`

#### Test case types

1. One cluster with a clear balance-sheet winner
2. One cluster where the best business is not the highest-upside stock
3. One cluster with a permanent-pass margin erosion case
4. One cluster where a weaker name is kept only because returns are materially higher

#### Verification questions

1. Does the ranking record clearly identify the winner and why?
2. Is balance sheet strength visibly prioritized?
3. Are eliminated names clearly separated from lower-priority names?
4. Is backup-candidate logic used sparingly and explicitly?

## File-Level Task Plan

### Task 1: Update Analyst Step 3 Structure

Modify `.claude/agents/analyst.md` to require:
- a cluster ranking record
- the three ranking dimensions
- margin trend gate
- final cluster statuses

### Task 2: Add Backup-Candidate Rule

Update `.claude/agents/analyst.md` so weaker names may only remain if the methodology's three keep conditions are explicitly satisfied.

### Task 3: Add Orchestrator Ranking Audit

Modify `.claude/agents/orchestrator.md` to verify Step 3 ranking completeness before final compilation.

### Task 4: Verify On Known Cluster Cases

Run a small set of representative clusters and document:
- whether the winner is obvious
- whether the ranking logic matches the methodology
- where ambiguity remains

## Acceptance Criteria

Phase 2 is complete when all of the following are true:

1. Every cluster has an explicit ranking record.
2. The three ranking dimensions are clearly separated.
3. Permanent-pass margin erosion is explicitly handled.
4. Non-winner names are only retained with a method-consistent reason.
5. The orchestrator audits Step 3 completeness.

## Risks

### Risk 1: Fake objectivity

Turning peer ranking into a table can create false confidence if the labels are arbitrary.

Mitigation:
- keep labels coarse
- require evidence narrative next to labels
- avoid numeric overfitting

### Risk 2: Overweighting the rubric over judgment

The methodology still requires business judgment. The rubric should support it, not replace it.

Mitigation:
- use explicit ordering, not rigid scores
- keep room for `CONDITIONAL_WINNER` and `no clear winner`

### Risk 3: Carrying too many names forward

If backup logic is too permissive, Step 3 stops being selective.

Mitigation:
- require explicit keep rationale
- tie it back to materially higher returns and lack of better alternatives

## Recommended Execution Sequence

1. Update analyst Step 3 structure
2. Add backup-candidate rule
3. Add orchestrator ranking audit
4. Run cluster verification set

## Bottom Line

Phase 2 makes the peer-comparison step behave more like John actually uses it:
- compare side by side
- prioritize survival quality first
- eliminate structurally weaker names
- keep backups only for a clear reason

That moves Step 3 from "good analysis prose" toward "auditable methodology execution."
