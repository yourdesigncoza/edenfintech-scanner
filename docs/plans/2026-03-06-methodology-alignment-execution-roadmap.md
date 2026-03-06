# Methodology Alignment Execution Roadmap

Date: 2026-03-06

Related documents:
- `docs/plans/2026-03-06-methodology-alignment-map.md`
- `docs/plans/2026-03-06-methodology-alignment-implementation-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-1-first-filter-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-2-peer-ranking-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-3-catalyst-quality-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-4-monitoring-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-5-downside-calibration-plan.md`
- `docs/plans/2026-03-06-methodology-alignment-phase-6-regression-harness-plan.md`

## Purpose

Combine the six methodology-alignment phases into one practical execution sequence:
- what to do first
- what depends on what
- what produces the biggest improvement in methodology fidelity

## Executive View

The roadmap has two tracks:

1. **Selection quality track**
   - Phase 1: First filter
   - Phase 2: Peer ranking
   - Phase 3: Catalyst quality

2. **Lifecycle discipline track**
   - Phase 4: Monitoring
   - Phase 5: Downside calibration
   - Phase 6: Regression harness

Recommended order is still linear, but this framing shows the logic:
- improve input quality first
- then improve post-buy discipline
- then protect the whole system from drift

## Recommended Execution Order

### Phase 1: Harden Step 2 First Filter

Primary files:
- `.claude/agents/screener.md`
- `scripts/calc-score.sh`
- `.claude/agents/orchestrator.md`

Why first:
- sharpens the bouncer at the door
- reduces wasted analysis effort
- improves repeatability before touching more subjective layers

Expected payoff:
- fewer weak names reaching deep analysis
- clearer rejection reasons
- better handoff context for analysts

### Phase 2: Make Step 3 Peer Ranking Auditable

Primary files:
- `.claude/agents/analyst.md`
- `.claude/agents/orchestrator.md`

Why second:
- once Step 2 is tighter, Step 3 becomes the next biggest source of ambiguity
- makes "balance sheet first" operational instead of rhetorical

Expected payoff:
- clearer cluster winners
- fewer unjustified backup candidates
- better alignment with EdenFinTech's relative-quality logic

### Phase 3: Formalize Step 4 Catalyst Quality

Primary files:
- `.claude/agents/analyst.md`
- `.claude/agents/orchestrator.md`
- possibly `knowledge/strategy-rules.md`

Why third:
- after candidate quality and peer quality improve, tighten the core thesis-change requirement
- prevents vague turnaround stories from surviving

Expected payoff:
- better catalyst discipline
- stronger "issues and fixes" analysis
- real enforcement of "no catalysts = pass"

### Phase 4: Build Step 8 Monitoring Workflow

Primary files:
- new holding-review skill/agent
- `knowledge/current-portfolio.md`
- `README.md`
- `CLAUDE.md`

Why fourth:
- closes the biggest lifecycle gap
- extends the project from idea engine to full investing workflow

Expected payoff:
- current holdings can be reviewed with the same discipline as new ideas
- sell logic becomes operational
- portfolio notes become living research records

### Phase 5: Calibrate Downside Guardrail

Primary files:
- `knowledge/strategy-rules.md`
- `knowledge/valuation-guidelines.md`
- `knowledge/scoring-formulas.md`
- `scripts/calc-score.sh`
- `.claude/agents/analyst.md`
- `.claude/agents/orchestrator.md`

Why fifth:
- downside is already much better than before, but calibration should be done after upstream selection quality is cleaner
- avoids tuning the most sensitive input before the rest of the process is stable

Expected payoff:
- downside remains reproducible
- fewer BRBR-style distorted floors
- more credible scoring input

### Phase 6: Add Methodology Regression Harness

Primary files:
- regression template doc
- canonical suite doc
- `README.md`
- `CLAUDE.md`

Why last:
- protects the earlier phases from future drift
- best built after the key workflow changes are defined

Expected payoff:
- methodology memory
- explicit drift detection
- more confident iteration going forward

## Dependency Map

### Hard dependencies

- Phase 2 depends on Phase 1
  - peer ranking is better when first-filter outputs are more structured

- Phase 3 depends on Phase 2
  - catalyst review is cleaner when cluster winners and backups are explicit

- Phase 6 depends on all earlier phases conceptually
  - regression coverage is strongest after behavior is intentionally defined

### Soft dependencies

- Phase 4 can begin before Phase 5
  - monitoring does not require downside calibration to be complete

- Phase 5 benefits from Phases 1-3
  - cleaner upstream selection makes downside evaluation easier to interpret

## Recommended Milestones

### Milestone A: New-Idea Discipline

Includes:
- Phase 1
- Phase 2
- Phase 3

Result:
- stronger idea selection pipeline
- clearer rejection logic
- tighter Step 2-4 methodology alignment

### Milestone B: Full Lifecycle Coverage

Includes:
- Phase 4

Result:
- scanner becomes a more complete investing workflow

### Milestone C: Robustness And Drift Protection

Includes:
- Phase 5
- Phase 6

Result:
- downside gets calibrated
- future changes become safer

## Best Starting Point

If implementation starts now, begin with:

### Start Here: Phase 1

Reason:
- highest signal-to-effort
- least philosophical ambiguity
- strongest immediate reduction in downstream noise
- naturally improves Phase 2 and Phase 3

Immediate target files:
- `.claude/agents/screener.md`
- `scripts/calc-score.sh`
- `.claude/agents/orchestrator.md`

## Practical Build Sequence

### Sprint 1

- Implement Phase 1
- verify with a small screening case set

### Sprint 2

- Implement Phase 2
- verify on representative clusters

### Sprint 3

- Implement Phase 3
- verify catalyst-quality discrimination

### Sprint 4

- Implement Phase 4
- review one or two real existing holdings

### Sprint 5

- Implement Phase 5
- run downside regression set

### Sprint 6

- Implement Phase 6
- create canonical methodology suite

## Decision Rules During Execution

### If time is limited

Prioritize:
1. Phase 1
2. Phase 2
3. Phase 3

That gives the biggest improvement to new-idea quality.

### If the main pain is poor downside behavior

Still do not jump straight to Phase 5 unless the issue is acute.
Recommended exception:
- do a narrow calibration spike
- then return to normal order

### If the main pain is portfolio management

Pull Phase 4 forward after Phase 1.
That is the only sequencing change I would consider reasonable.

## Risks By Roadmap Stage

### Early-stage risk

- overengineering the screener before tightening output structure

Control:
- keep Phase 1 evidence-first

### Mid-stage risk

- adding too much rubric overhead to analysts

Control:
- keep labels coarse
- require short evidence, not verbose form-filling

### Late-stage risk

- calibrating downside before enough representative cases exist

Control:
- pair Phase 5 with regression-minded verification

## Completion Standard

This roadmap is meaningfully complete when:
- Phases 1-3 improve the quality of names entering valuation and scoring
- Phase 4 closes the post-buy gap
- Phase 5 keeps downside useful and credible
- Phase 6 prevents silent methodology drift

## Bottom Line

The recommended implementation path is:

1. Phase 1: first filter
2. Phase 2: peer ranking
3. Phase 3: catalyst quality
4. Phase 4: monitoring
5. Phase 5: downside calibration
6. Phase 6: regression harness

That order gives the best balance of:
- immediate quality improvement
- methodology fidelity
- implementation clarity
- long-term maintainability
