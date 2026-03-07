---
name: review-holding
description: Use this skill when the user asks to review an existing holding, monitor thesis progress, check sell triggers, or run a Step 8 post-buy review (e.g., "/review-holding CPS").
version: 0.1.0
---

# EdenFinTech Holding Review

Run a Step 8 monitoring review for an existing portfolio position.

## Invocation

- `/review-holding TICKER` -> single-holding review
- `/review-holding TICK1 TICK2` -> batch holding review
- Optional flag: `--terminal_save` or `--terminal-save` -> also save a best-effort execution log for review

## Prerequisites

1. Ensure `FMP_API_KEY` is configured:
```bash
bash scripts/fmp-api.sh help
```
2. Read portfolio context:
```bash
KNOWLEDGE_DIR=$(bash scripts/fmp-api.sh knowledge-dir)
cat "$KNOWLEDGE_DIR/current-portfolio.md"
```

## Execution

For each ticker, spawn the holding reviewer agent:

```
Use the Task tool with subagent_type "general-purpose" and this prompt:

"You are the EdenFinTech Holding Reviewer. Read your instructions at
.claude/agents/holding-reviewer.md and follow them exactly.

Review holding: {TICKER}
User request: {original user message}
Terminal save requested: {yes | no}

Return a complete Step 8 holding review with thesis status, catalyst tracking, forward-return refresh, and sell-trigger checks."
```

## Output

After reviews return:

1. Present a concise verdict per ticker:
- `HOLD`
- `HOLD_AND_MONITOR`
- `ADD_CANDIDATE`
- `TRIM / REDUCE`
- `EXIT`
2. Highlight triggered sell checks (if any).
3. Provide path to saved review artifact when requested.
4. If `--terminal_save` was requested, also show the execution-log path and note that it is a best-effort execution log, not a hidden Claude transcript.
