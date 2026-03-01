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

Build structured sector knowledge files for use in future scans. Uses Gemini deep research to produce per-sub-sector analysis covering metrics, valuation approaches, turnaround precedents, risk profiles, and evidence requirements.

## Invocation

Parse the user's input to determine the sector:

- `/sector-hydrate Banking` → hydrate the Banking sector (narrow: Diversified + Regional Banks)
- `/sector-hydrate "Consumer Defensive"` → hydrate Consumer Defensive
- `/sector-hydrate Healthcare` → hydrate Healthcare

## Prerequisites

Verify Gemini MCP is available — sector hydration relies on `gemini-deep-research` for primary research:

```
Test by calling: mcp__gemini__gemini-query with prompt "test" and model "flash"
```

If Gemini is unavailable, inform the user that sector hydration requires the Gemini MCP server.

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
ls ${CLAUDE_PLUGIN_ROOT}/knowledge/sectors/<sector-slug>/_meta.md 2>/dev/null
```
If exists, warn the user: "Sector `<name>` was hydrated on `<date>` (version `<n>`). Re-hydrate will overwrite. Proceed?"

## Execution

Spawn the sector coordinator agent to run the hydration pipeline:

```
Use the Agent tool with subagent_type "general-purpose" and this prompt:

"You are the EdenFinTech Sector Coordinator. Read your instructions at
${CLAUDE_PLUGIN_ROOT}/agents/sector-coordinator.md and follow them exactly.

Sector: {FMP sector name}
Scope: {narrow scope if applicable, e.g., 'Banks only — Diversified + Regional'}
Output path: ${CLAUDE_PLUGIN_ROOT}/knowledge/sectors/{sector-slug}/
Data dir: $(bash ${CLAUDE_PLUGIN_ROOT}/scripts/fmp-api.sh data-dir)

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
