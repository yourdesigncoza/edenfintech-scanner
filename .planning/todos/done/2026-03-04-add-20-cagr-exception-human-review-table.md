---
created: 2026-03-04T11:18:25.930Z
title: Add 20% CAGR exception human review table
area: tooling
files:
  - agents/orchestrator.md
  - agents/analyst.md
  - knowledge/strategy-rules.md
---

## Problem

The strategy allows the 30% CAGR hurdle to drop to 20% for "top-tier CEO + 6yr+ runway." This is inherently subjective — John's assessment is backed by deep domain expertise; the LLM analyst has only FMP API data. An LLM will apply it too liberally: good narrative → "top-tier CEO" → exception triggered → stock passes.

The 20% exception creates a backdoor through the hardest filter in the system. If the LLM can self-authorize it, the hurdle is effectively ~20% for any stock with a CEO the LLM finds impressive.

Validated against test scan: 73 regional banks → only 1 stock (LOB at 24.1% CAGR) would trigger this. Cost of human review is trivial.

## Solution

Do NOT pause the pipeline. Instead:

1. Orchestrator scores everything normally — stocks with CAGR 20-29.9% fail the 30% hurdle and are **rejected** in main rankings
2. Analyst still runs full analysis on these stocks (valuation, moats, catalysts, epistemic review) so all data is available
3. Orchestrator adds a "Pending Human Review — 20% CAGR Exception Candidates" table to the final report
4. Table includes: Ticker, CAGR, CEO evidence, runway evidence, why exception may apply, pre-epistemic score
5. Stock only gets promoted to ranked candidates if human manually approves after reading the report

The LLM recommends but cannot authorize. Pipeline flow is unbroken.

Key implementation points:
- Analyst agent: still runs full analysis for stocks in 20-29.9% CAGR range (don't skip them)
- Orchestrator: collect these into separate table, place just before "Rejected at Analysis" section
- Strategy-rules.md / scoring-formulas.md: document that exception requires human approval
