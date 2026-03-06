# Methodology Alignment Map

Date: 2026-03-06
Scope:
- Scanner project: `/home/laudes/zoot/projects/edenfintech-scanner`
- Method reference: `/home/laudes/zoot/projects/strategy_EdenFinTech/edenfintech-system`

## Purpose

Map John/EdenFinTech's investing methodology to the scanner's current implementation, identify where the system already aligns well, and isolate the highest-value gaps.

## Summary

The scanner is not a generic stock screener. It is already structured as an execution layer for the EdenFinTech deep-value turnaround methodology:
- top-down idea generation
- hard first-filter rejection
- cluster-based competitor comparison
- qualitative deep dive
- simple 4-input valuation
- downside / probability / CAGR decision scoring
- concentrated portfolio constraints

The strongest alignment is in valuation math, scoring, and position sizing. The weakest alignment is in judgment-heavy qualitative steps and in post-purchase monitoring.

## Step-by-Step Alignment

| Step | Method Source | Current Scanner Implementation | Enforcement Strength | Main Gap |
|------|---------------|-------------------------------|----------------------|----------|
| 1. Finding Ideas | `01-FINDING-IDEAS.md`, `knowledge/strategy-rules.md` | Broken-chart, sector focus, exclusions, secular-decline sniff in `.claude/agents/screener.md` | Medium | Top-down sector selection is supported, but not systematically ranked by underperformance plus catalyst density |
| 2. First Filter | `02-FIRST-FILTER.md`, `knowledge/strategy-rules.md` | 5-check screen in `.claude/agents/screener.md`; market data via `scripts/fmp-api.sh` | Medium-High | Pass/fail logic is well specified, but still mostly prompt-enforced rather than implemented as deterministic reusable checks |
| 3. Competitor Comparison | `03-DEEP-ANALYSIS.md` | Cluster analysis in `.claude/agents/analyst.md` with comparison tables and quality ranking | Medium | "Balance sheet first, then niche/margins, then return" is faithful conceptually but not mechanically scored or audited |
| 4. Qualitative Deep Dive | `04-QUALITATIVE-DEEP-DIVE.md` | 5-question workflow in `.claude/agents/analyst.md`; web grounding via `scripts/gemini-search.sh` | Medium | Moats, management quality, and catalyst quality are still narrative judgments with limited auditability |
| 5. Valuation | `05-VALUATION.md`, `knowledge/valuation-guidelines.md` | 4-input model in `.claude/agents/analyst.md`; deterministic valuation/CAGR in `scripts/calc-score.sh` | High | Revenue, margin, and multiple assumptions remain judgment-driven even though the math is deterministic |
| 5a. Worst Case / Downside | `knowledge/strategy-rules.md`, `knowledge/scoring-formulas.md` | Trough-anchored floor in `scripts/calc-score.sh`; structured process in `.claude/agents/analyst.md`; compliance audit in `.claude/agents/orchestrator.md` | Medium-High | Reproducibility improved materially, but calibration is still unsettled for growth names and distorted FCF-margin troughs |
| 6. The Decision | `06-THE-DECISION.md`, `knowledge/scoring-formulas.md` | Deterministic score, effective probability, size logic in `scripts/calc-score.sh`; orchestration in `.claude/agents/orchestrator.md` | High | Scenario comparison against existing holdings still depends on portfolio-document quality and analyst framing |
| 7. Position Sizing | `07-POSITION-SIZING.md`, `knowledge/scoring-formulas.md` | Hard breakpoints, confidence caps, binary override in `scripts/calc-score.sh` | High | One of the best-aligned parts of the system |
| 8. After the Buy | `08-AFTER-THE-BUY.md` | Mostly documented only in `knowledge/strategy-rules.md` and `knowledge/current-portfolio.md` | Low | No real monitoring workflow yet for catalyst tracking, thesis-break detection, forward-return recalculation, or post-mortems |

## Strong Alignment Areas

### 1. Core philosophy is preserved

The scanner reflects the main EdenFinTech principles:
- concentrated portfolio
- deep value turnaround focus
- hard 30% CAGR hurdle
- "no catalyst = pass"
- downside and survivability weighted above upside
- willingness to find nothing

### 2. The 4-input valuation model is preserved

The local system matches the original methodology's valuation simplification:

```text
Revenue x FCF Margin x FCF Multiple / Shares = Price Target
```

This is implemented consistently in:
- `knowledge/strategy-rules.md`
- `.claude/agents/analyst.md`
- `scripts/calc-score.sh`

### 3. Decision scoring and sizing are systematized well

The scanner translates John's later score-based decision framework into deterministic math:
- score
- effective probability
- hard breakpoints
- confidence caps
- binary outcome override

This is one of the clearest cases where the project improves consistency without distorting the method.

### 4. Independent confidence review is a good fit

The epistemic reviewer creates separation between thesis construction and confidence assessment. That aligns well with the spirit of John's "conviction comes from knowability, not spreadsheet optimism" idea.

## Partial Alignment Areas

### 1. Step 1 is only partly top-down

The methodology starts with underperforming sectors that have real catalysts. The scanner supports sector scans and hydration, but it does not yet have a systematic way to rank sectors by:
- underperformance
- hated sentiment
- catalyst density
- cycle position

So the workflow supports top-down research, but does not yet automate or prioritize it.

### 2. Competitor comparison is structurally right but weakly enforced

The analyst compares competitors, but the quality-ranking priorities from the methodology are not mechanically enforced:
1. balance sheet strength
2. superior niche / margins
3. risk-adjusted returns

Today this is prompt guidance, not a scored or audited rubric.

### 3. Qualitative work is rich but still narrative-heavy

The system asks the right questions on:
- moat
- management
- issues and fixes
- compensation
- catalysts

But the output quality still depends heavily on the analyst prompt, research quality, and model judgment. This is the main area where "alignment" can drift while still producing polished-looking reports.

## Weak Alignment Areas

### 1. Step 8 is underbuilt

The original methodology places major emphasis on:
- catalyst tracking
- management consistency
- margin drift
- competitor drift
- macro relevance
- sell triggers
- post-mortems

The scanner is currently much stronger at finding and analyzing new ideas than at monitoring existing holdings through time.

### 2. Downside is now reproducible but not fully calibrated

The trough-anchored downside guardrail is a major improvement. But current verification work shows that reproducible does not always equal credible:
- BRBR demonstrates "Frankenstein" combinations of worst revenue year plus worst margin year
- growth-company trough selection can become too punitive
- working-capital noise can dominate FCF-margin troughs

This means the guardrail has reduced analyst variance but still needs calibration before it can be treated as fully aligned with John's idea of a "reasonable worst case."

### 3. Some methodology is still prompt law, not system law

The scanner's strongest components are deterministic scripts. Its weakest components are instructions that agents are supposed to follow.

That makes alignment vulnerable in areas such as:
- catalyst quality
- management grading
- multiple selection
- peer-quality ranking
- what counts as a true thesis break

## Implementation Layer Crosswalk

| Layer | Role in Methodology | Current State |
|-------|----------------------|---------------|
| `knowledge/*.md` | Source-of-truth distillation of the methodology | Good overall, recently strengthened around downside |
| `.claude/agents/screener.md` | Encodes Steps 1-2 | Faithful but still mostly prompt-driven |
| `.claude/agents/analyst.md` | Encodes Steps 3-6 | Strong structure, still judgment-heavy |
| `.claude/agents/epistemic-reviewer.md` | Independent confidence filter | Good fit, improves discipline |
| `.claude/agents/orchestrator.md` | Enforces workflow and compliance | Strong coordinator, but audit quality depends on report structure |
| `scripts/calc-score.sh` | Deterministic math spine | Strongest implementation asset |
| `scripts/fmp-api.sh` | Shared data access and caching | Solid utility layer |
| `knowledge/current-portfolio.md` | Portfolio context for deployment decisions | Useful but static; not yet a true monitoring system |

## Highest-Value Gaps

### Gap 1: Deterministic filter logic is incomplete

The 5 first-filter checks are central to the methodology, but they are not yet broken into reusable, testable decision primitives.

### Gap 2: Quality ranking among peers is not auditable

The method clearly prioritizes balance sheet strength first. The scanner describes that priority but does not enforce or score it explicitly.

### Gap 3: Catalyst quality has no formal rubric

The system has a hard rule that no catalysts means pass. But it does not yet rigorously score whether a catalyst is:
- specific
- time-bound
- measurable
- management-linked
- already priced in

### Gap 4: Monitoring / sell workflow is mostly absent

This is the biggest end-to-end methodology hole.

### Gap 5: Downside guardrail needs calibration

The downside system is the main current methodology-engineering project. It has improved reproducibility, but still needs refinement to better match "reasonable worst case" rather than "mechanical maximum pain."

## Bottom Line

The scanner already captures the skeleton and much of the operating logic of the EdenFinTech method. It is closest to the source methodology in:
- valuation
- decision scoring
- position sizing
- concentrated portfolio logic

It is furthest from full methodology alignment in:
- sector-selection discipline
- peer-quality ranking rigor
- catalyst-quality enforcement
- post-buy monitoring and sell discipline
- calibration of downside for edge cases

The project has moved beyond a generic LLM stock-analysis workflow. The next stage is to convert the remaining judgment-heavy parts of the methodology into auditable system behavior without flattening the real discretionary edge out of the process.
