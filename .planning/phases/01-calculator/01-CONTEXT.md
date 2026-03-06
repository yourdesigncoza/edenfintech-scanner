# Phase 1: Calculator - Context

**Gathered:** 2026-03-06
**Status:** Ready for planning

<domain>
## Phase Boundary

Add a `floor` command to calc-score.sh that computes a mechanical worst-case floor price from trough inputs and returns the downside percentage from current price. This is the deterministic anchor that eliminates LLM variance in downside estimation.

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
- Mirror the existing `valuation` command pattern — same 4-input formula, same JSON structure, extended with current_price and downside_pct
- Command signature: `floor <revenue_b> <margin_pct> <multiple> <shares_m> <current_price>` (5 args, matching success criteria example)
- Output JSON should echo trough inputs back (consistent with how `valuation`, `score`, and `cagr` commands echo their inputs)
- Edge cases: follow existing patterns — `validate_number` for all args, `validate_pct` for margin, error on zero/negative shares and current_price (division by zero), compute normally for zero/negative margin (produces zero/negative floor — valid for worst case)
- Help text and examples added to the `usage()` function
- Keep it simple — no heroic optimism flags or TBV cross-checks in the calculator (those are Phase 3 analyst-level concerns)

</decisions>

<specifics>
## Specific Ideas

No specific requirements — the existing calc-score.sh patterns and CALC-01/02/03 requirements are clear enough to implement directly.

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `valuation` command (line 194-227): Already implements the 4-input formula. `floor` reuses the same math plus downside calculation.
- `validate_number()` / `validate_pct()`: Input validation helpers, reuse directly.
- `cagr` command: Shows pattern for computing a derived value from price inputs (current vs target).

### Established Patterns
- All commands use python3 inline for math, output via `json.dumps(result, indent=2)`
- Input validation happens in bash before python3 block
- Error handling via `err()` function with stderr + exit 1
- `validate_pct` warns on decimal-looking percentages (0.30 vs 30)

### Integration Points
- New `case` block in the main `case "$cmd" in` switch (line 90)
- Help text added to `usage()` function (line 11-55)
- No changes to existing commands needed

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 01-calculator*
*Context gathered: 2026-03-06*
