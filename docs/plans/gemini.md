 Gemini Review Results

  Epistemic Data Contract Plan — APPROVED with 3 amendments

  Required fixes:

  ┌─────┬─────────────────────────────────────────────────────────────────────────────┬───────────────┬───────────────────────────────────────────────────────────────────────────────────────────────────┐
  │  #  │                                   Finding                                   │     Task      │                                                Fix                                                │
  ├─────┼─────────────────────────────────────────────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 1   │ human_judgment_flags will be overwritten, not merged                        │ Task 4 Step 3 │ Change "Copy" to "Merge reviewer's flags with locally generated flags (e.g., risk_type_mismatch)" │
  ├─────┼─────────────────────────────────────────────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 2   │ effective_probability may return floats — calc-score.sh may expect integers │ Task 4 Step 3 │ Add rounding instruction or verify script handles floats                                          │
  ├─────┼─────────────────────────────────────────────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 3   │ 7 tasks all modify orchestrator.md — high churn risk                        │ Wave 2-4      │ Execute Tasks 4, 6, 7, 11, 12, 13, 14 as a single orchestrator rewrite, not 7 separate diffs      │
  └─────┴─────────────────────────────────────────────────────────────────────────────┴───────────────┴───────────────────────────────────────────────────────────────────────────────────────────────────┘

  Validated as correct:
  - Task 11: Score SHOULD use effective_probability (confirmed)
  - Task 14: Ceiling logic is sound — friction only reduces, so ceilings always hold (confirmed)

  ---
  Agent Decontamination Plan — APPROVED with 4 modifications

  ┌─────┬─────────────────────────────────────────────────────────┬───────────┬─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │  #  │                         Finding                         │   Task    │                                                                           Fix                                                                           │
  ├─────┼─────────────────────────────────────────────────────────┼───────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 1   │ Replacing one hardcoded list with three is still        │ Task 1    │ Change to "derive sector-appropriate distress metrics" with the general 60%+ ATH fallback, not a finite switch-statement                                │
  │     │ brittle                                                 │           │                                                                                                                                                         │
  ├─────┼─────────────────────────────────────────────────────────┼───────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 2   │ 10% market cap threshold is unverifiable by LLMs        │ Task 2    │ Remove numeric threshold, use qualitative: "existential threat to business model or balance sheet" / "potential liability exceeds current cash          │
  │     │                                                         │           │ reserves"                                                                                                                                               │
  ├─────┼─────────────────────────────────────────────────────────┼───────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 3   │ Abstract replacements degrade LLM performance           │ Task 3    │ Use multi-sector examples ("P/TBV for Banks, EV/EBITDA for Industrials, P/ARR for SaaS") instead of vague "specialized methods"                         │
  ├─────┼─────────────────────────────────────────────────────────┼───────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
  │ 4   │ Execution ordering matters                              │ Both      │ Apply epistemic plan FIRST, then decontamination (both edit analyst.md and orchestrator.md)                                                             │
  │     │                                                         │ plans     │                                                                                                                                                         │
  └─────┴─────────────────────────────────────────────────────────┴───────────┴─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

  Scope gap flagged: Check if a fundamental-researcher.md or context-rules.md exists with similar bank-overfit definitions.
