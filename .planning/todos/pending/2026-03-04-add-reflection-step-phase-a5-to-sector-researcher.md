---
created: 2026-03-04T08:04:34.870Z
title: Add reflection step (Phase A.5) to sector researcher agent
area: tooling
files:
  - agents/sector-researcher.md
  - .planning/reflection-step/REQUIREMENTS.md
---

## Problem

Sector researcher fires 8 parallel Perplexity queries but has no systematic gap detection before synthesis. Known issues:

- Q6 (Turnaround Precedents) and Q8 (Valuation) frequently return thin results
- Cross-query contradictions go undetected (e.g., Q1 says margins expanding vs Q3 says input costs rising)
- Citation vacuums — paragraphs with zero source URLs pass through to final output
- Current fallback chain is manually baked into the prompt, not organic reflection
- Stale citations (>2yr) in fast-moving sectors not flagged

Inspired by LangChain Open Deep Research's iterative ReAct loop, but adapted to our Perplexity-first architecture. Claude + Gemini brainstorm consensus: 9/10 — high-ROI addition.

## Solution

Insert Phase A.5 between Phase A (8 queries) and Phase B (synthesis):

1. Claude reviews all 8 raw Perplexity outputs as "Research Auditor"
2. Audits for 3 gap types: Missing Data, Conflicts, Source Quality
3. Uses 5 detection criteria: hard data missing, thin evidence (<2 examples), staleness (>2yr), cross-query contradictions, citation vacuum (>100 words / 0 URLs)
4. Generates 0-3 narrow follow-up `perplexity_ask` queries (keyword-stuffed, context-injected)
5. If audit passes → skip to Phase B (0 follow-ups valid)
6. Follow-up results labeled `### SUPPLEMENTARY RESEARCH ###`, override Phase A on conflicts
7. Single pass only: A → A.5 → B — no recursion

Full spec with acceptance criteria: `.planning/reflection-step/REQUIREMENTS.md`

Task list created with 4 tasks (dependencies set):
1. Add Phase A.5 to sub-sector flow (core work)
2. Update Phase B synthesis for supplementary data (blocked by 1)
3. Add Phase A.5 to regulatory research type (blocked by 1)
4. Update Rules section with A.5 constraints (blocked by 1, 2, 3)
