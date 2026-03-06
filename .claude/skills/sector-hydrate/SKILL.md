---
name: sector-hydrate
description: |
  Hydrate sector knowledge for the EdenFinTech scanner. Use when the user says
  "sector hydrate", "hydrate sector", "build sector knowledge", "sector research",
  or wants to pre-load sector-specific data for future scans.
  Produces structured knowledge files in knowledge/sectors/<sector-slug>/.
version: 0.1.0
---

# EdenFinTech Sector Hydration

Build structured sector knowledge files for use in future scans. Uses Gemini Grounded Search (via bash script) + Claude synthesis to produce per-sub-sector analysis covering metrics, valuation approaches, turnaround precedents, risk profiles, and evidence requirements.

## Invocation

Parse the user's input to determine the sector:

- `/sector-hydrate Banking` → hydrate the Banking sector (narrow: Diversified + Regional Banks)
- `/sector-hydrate "Consumer Defensive"` → hydrate Consumer Defensive
- `/sector-hydrate Healthcare` → hydrate Healthcare

## Prerequisites

**HARD STOP** — Sector hydration relies entirely on the Gemini Grounded Search API. Test it first before doing anything else:

```bash
bash scripts/gemini-search.sh ask "ping"
```

**If the call fails or errors:**

STOP immediately. Do NOT resolve the sector, do NOT spawn agents, do NOT fall back to WebSearch.

Alert the user with this exact message:

> **BLOCKED: Gemini Grounded Search API unavailable** — sector hydration cannot proceed.
>
> Fix: ensure `GEMINI_API_KEY` is set in `data/.env` or `~/.claude.json`. Then re-run `/sector-hydrate`.

Only continue to Sector Resolution if the Gemini Grounded Search test call returns a successful response.

## Sector Resolution

1. **Fuzzy-match** the user input to an FMP sector name:

| Common Name | FMP Sector | Scope |
|---|---|---|
| Banking / Banks | Financial Services | Banks—Diversified, Banks—Regional ONLY |
| Consumer Defensive / Consumer Staples | Consumer Defensive | All sub-industries |
| Healthcare | Healthcare | All sub-industries |
| Industrials | Industrials | All sub-industries |
| Technology / Tech | Technology | All sub-industries |
| Energy | Energy | All sub-industries |

2. **Check for existing hydration:**
```bash
KNOWLEDGE_DIR=$(bash scripts/fmp-api.sh knowledge-dir)
ls $KNOWLEDGE_DIR/sectors/<sector-slug>/_meta.md 2>/dev/null
```
If exists, warn the user: "Sector `<name>` was hydrated on `<date>` (version `<n>`). Re-hydrate will overwrite. Proceed?"

## Execution

Spawn the sector coordinator agent to run the hydration pipeline:

```
Use the Agent tool with subagent_type "general-purpose" and this prompt:

"You are the EdenFinTech Sector Coordinator. Read your instructions at
.claude/agents/sector-coordinator.md and follow them exactly.

Sector: {FMP sector name}
Scope: {narrow scope if applicable, e.g., 'Banks only — Diversified + Regional'}
Output path: $(bash scripts/fmp-api.sh knowledge-dir)/sectors/{sector-slug}/
Data dir: $(bash scripts/fmp-api.sh data-dir)

Run the full 3-phase hydration pipeline."
```

## After Hydration

Once the coordinator returns:
1. Present a summary: number of sub-sectors hydrated, total files created
2. Show the directory listing of `knowledge/sectors/<sector-slug>/`
3. Mention that the next `/scan-stocks` in this sector can reference these files (pipeline integration is future work — manual reference for now)

## Token Budget

| Sector Size | Estimated Cost |
|-------------|---------------|
| Small (2-3 sub-sectors, e.g., Banking) | ~50-100k tokens |
| Medium (4-6 sub-sectors) | ~100-200k tokens |
| Large (8+ sub-sectors) | ~200-400k tokens |

Warn the user about token cost for large sectors.
