Findings:

  1. High: Task 1 does not actually enforce the new contract at runtime. The plan adds schema definitions in 2026-03-08-epistemic-data-contract.md:35, but the validator used by render-scan is the manual validate_scan() path in
     report_json.py:96, and it never validates ranked_candidates[*] or epistemic_confidence beyond top-level presence. As written, malformed epistemic payloads would still pass “validation” and only fail later in rendering or human
     review. The plan needs a task to either wire in JSON Schema validation or extend validate_scan() to validate the canonical epistemic object.
  2. High: The probability-band normalization bug is still present, and Task 7 incorrectly says no change is needed. The plan’s own assembly step computes effective_probability from {base_prob} in 2026-03-08-epistemic-data-
     contract.md:271, while Task 7 claims the current ordering is already correct in 2026-03-08-epistemic-data-contract.md:406. But the current orchestrator computes effective probability before the probability-band validation step in
     orchestrator.md:271 and only normalizes bands later in orchestrator.md:282. That means a non-compliant raw probability can leak into effective probability, score, and size. The plan should move normalization ahead of any effective-
     probability or score calculation, or explicitly say “use normalized base probability” everywhere downstream.
  3. Medium: The new reviewer JSON contract is not made deterministic enough because the plan never specifies parsing/validation failure behavior. The reviewer output change is defined in 2026-03-08-epistemic-data-contract.md:144, and
     the orchestrator “consumption” work is described in 2026-03-08-epistemic-data-contract.md:218, but there is no instruction for what to do if the reviewer returns malformed JSON, missing keys, mismatched tickers, or extra prose
     outside fences. For a plan centered on a “data contract,” that omission is material. Add an explicit invalid-reviewer-output path: reject candidate or fail the run with a precise reason.
  4. Medium: The dependency graph is too optimistic. The plan says Tasks 1-4 are independent and can run in parallel in 2026-03-08-epistemic-data-contract.md:469, but Tasks 3 and 4 define opposite sides of the same reviewer/orchestrator
     wire contract. If they are implemented independently, drift is likely: field names, fence format, and parsing assumptions can diverge. These should be treated as one coupled change set, with Task 5 and regression validation after
     both land.

  Residual gap: the regression check is too narrow. It only re-renders one existing scan in 2026-03-08-epistemic-data-contract.md:485. Since the plan also extends rejected analysis packets and formal validation, it should add validate-
  scan coverage plus at least one fixture where epistemic_confidence exists under a rejected candidate.

  Overall, the direction is correct and it identifies the real renderer/spec mismatch. I would not execute it as-is until the runtime validation path, probability-ordering fix, and reviewer-output failure handling are added.