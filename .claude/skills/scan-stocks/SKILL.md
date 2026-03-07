---
name: scan-stocks
description: This skill should be used when the user asks to "scan stocks", "find stocks", "screen NYSE", "find turnaround candidates", "scan for deep value", "run stock screener", "find investment ideas", or mentions "EdenFinTech scan". Runs the full two-phase stock scanning pipeline.
version: 0.1.0
---

# EdenFinTech Stock Scanner

On-demand NYSE stock scanner using the EdenFinTech deep value turnaround strategy. Two-phase pipeline: quantitative screening (Steps 1-2) then parallel deep analysis (Steps 3-6).

## Invocation

Parse the user's input to determine scan type:

- `/scan-stocks` or no arguments → **Full NYSE scan** (requires paid FMP tier)
- `/scan-stocks {sector}` (e.g., "consumer staples") → **Sector-focused scan**
- `/scan-stocks {TICK1} {TICK2}` (e.g., "CPS BABA HRL") → **Specific ticker analysis** (skips screening)

## Prerequisites

Before running, verify the FMP API key is configured:

```bash
bash scripts/fmp-api.sh help
```

If the key is not set, instruct the user:
1. Get a free API key at https://financialmodelingprep.com/developer/docs/
2. Edit `data/.env` and set `FMP_API_KEY=your_key`
3. Free tier (250 calls/day) supports sector scans. Full NYSE scans need paid tier.

## Execution

Spawn the orchestrator agent to run the full pipeline:

```
Use the Task tool with subagent_type "general-purpose" and this prompt:

"You are the EdenFinTech Orchestrator. Read your instructions at
.claude/agents/orchestrator.md and follow them exactly.

Scan type: {full | sector: NAME | tickers: TICK1,TICK2,...}
User request: {original user message}

Run the complete two-phase pipeline and produce the final ranked report."
```

## After the Scan

Once the orchestrator returns:
1. Present the executive summary to the user
2. Show the path to the full saved report
3. Show the path to the saved JSON artifact when available
4. Offer to discuss any candidate in more detail
5. If the user asks about a specific stock, pull additional data using the FMP helper script

Treat the run as incomplete if:
- the markdown report path is missing
- the JSON artifact path is missing

If incomplete, do not present the scan as finished. Ask the orchestrator to complete artifact generation first.

## Token Budget

| Scan Type | Estimated Tokens |
|-----------|-----------------|
| Full NYSE | ~150-300k |
| Sector focus | ~80-150k |
| Specific tickers (2-3) | ~50-80k |

Warn the user about token cost for full scans.
