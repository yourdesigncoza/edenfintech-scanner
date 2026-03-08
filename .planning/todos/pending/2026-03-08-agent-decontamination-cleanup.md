---
created: 2026-03-08T10:36:07.725Z
title: Agent decontamination cleanup
area: planning
files:
  - docs/plans/2026-03-08-agent-decontamination.md
  - .claude/agents/sector-researcher.md
  - .claude/agents/analyst.md
  - .claude/agents/sector-coordinator.md
  - .claude/agents/orchestrator.md
  - .claude/agents/epistemic-reviewer.md
---

## Problem

Stock-specific, sector-specific, and historically-anchored examples have leaked into generic agent rules. Bank-specific turnaround criteria (NPL>5%, CAMELS 4-5) hardcoded as universal definition in sector researcher. Active litigation unconditionally overrides risk type (too broad — anchored to PYPL case). Bank-centric examples (P/TBV, CET1) in cross-sector coordinator guidance. Ticker-specific examples (CPS, AAP, DORM, AMN, Synovus) in generic agent instructions create anchoring bias.

## Solution

Execute 4-task cleanup plan at `docs/plans/2026-03-08-agent-decontamination.md`. Reviewed by Gemini and Codex. All tasks independent (parallel):
1. Replace bank-specific turnaround definition with sector-adaptive dynamic derivation + 60% ATH fallback (HIGH)
2. Gate litigation override on materiality (>10% market cap exposure) instead of unconditional (MEDIUM)
3. Replace bank-centric examples with sector-neutral guidance in coordinator (LOW)
4. Replace ticker-specific examples with neutral placeholders across agents (LOW)

**Prerequisite:** Must execute AFTER epistemic data contract plan (both modify analyst.md and orchestrator.md).
