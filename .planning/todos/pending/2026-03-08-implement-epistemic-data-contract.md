---
created: 2026-03-08T10:34:43.568Z
title: Implement epistemic data contract
area: planning
files:
  - docs/plans/2026-03-08-epistemic-data-contract.md
  - schemas/scan-report.schema.json
  - schemas/scan-report.template.json
  - .claude/agents/epistemic-reviewer.md
  - .claude/agents/orchestrator.md
  - .claude/agents/analyst.md
  - scripts/report_json.py
  - knowledge/scoring-formulas.md
---

## Problem

The epistemic confidence pipeline has no formal data contract. The reviewer outputs markdown tables, the orchestrator assembles JSON ad-hoc, and the renderer looks for a `checks[]` array that doesn't exist. Nobody specifies who computes `risk_type_friction`, `adjusted_confidence`, or `effective_probability`. Same stock can get different epistemic treatment depending on which agent improvises the shape. Additionally: probability band normalization happens AFTER effective probability computation (wrong order), score recomputation uses base probability instead of effective, and sensitivity table uses invalid probability values.

## Solution

Execute the 15-task implementation plan at `docs/plans/2026-03-08-epistemic-data-contract.md`. Reviewed by both Gemini and Codex. Key changes:
- Add `epistemic_confidence` to JSON schema with `$defs` for reuse
- Reviewer outputs structured JSON (not markdown tables), echoes risk type
- Orchestrator passes risk type to reviewer, applies deterministic friction rules, assembles canonical JSON object
- Renderer reads canonical q1-q5 fields instead of `checks[]`
- Runtime validation for epistemic payloads in `validate_scan()`
- Fix probability band normalization ordering, score variable bug, sensitivity table values
- 5-wave dependency graph: schema/template/formulas -> reviewer -> orchestrator rewrite -> renderer/validation -> regression gate
