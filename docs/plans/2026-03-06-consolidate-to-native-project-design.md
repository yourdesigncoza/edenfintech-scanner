# Design: Consolidate Plugin to Native Claude Code Project

**Date:** 2026-03-06
**Goal:** Eliminate the 3-location workflow (source repo + data repo + plugin cache) and replace with a single-repo, edit-and-run setup.

## Current Pain

1. Edit code in source repo → must bump version + `/plugin` update → plugin cache refreshes → can now run scan
2. Data lives in separate repo (`edenfintech-scanner-data/`) — one more location to manage
3. 19 stale plugin cache versions accumulating at `~/.claude/plugins/cache/edenfintech-scanner/`

## Design

### New Structure

```
edenfintech-scanner/
├── .claude/
│   ├── agents/              ← moved from agents/ (native agent discovery)
│   ├── skills/              ← moved from skills/ (native /command discovery)
│   ├── hooks.json           ← NEW: registers SessionStart hook
│   └── settings.json        ← project settings if needed
├── hooks/
│   └── session-start.sh     ← NEW: welcome banner script
├── scripts/                 ← unchanged (fmp-api.sh, gemini-search.sh, etc.)
├── knowledge/               ← unchanged, now read directly (no copy-to-data)
├── data/                    ← .gitignore'd (replaces edenfintech-scanner-data/)
│   ├── .env                 ← API keys (FMP, Gemini, Perplexity, Massive)
│   ├── cache/               ← FMP + Gemini + Perplexity response cache
│   ├── scans/               ← primary scan report storage
│   ├── research/            ← sector research outputs
│   ├── result/              ← Gemini review results
│   └── logs/
├── docs/
│   └── scans/               ← git-tracked scan report copies
├── CLAUDE.md                ← updated to reflect new structure
├── .gitignore               ← add data/
└── README.md
```

### Key Changes

| Before | After |
|--------|-------|
| `${CLAUDE_PLUGIN_ROOT}/scripts/` | `scripts/` (project-relative) |
| `${CLAUDE_PLUGIN_ROOT}/agents/` | `.claude/agents/` (native discovery) |
| `$SCANNER_DATA_DIR` env chain | `data/` (hardcoded default in scripts) |
| `knowledge-dir` copies to data dir | Returns `knowledge/` directly |
| `.claude-plugin/marketplace.json` | Deleted — not a plugin anymore |
| `.env` with `SCANNER_DATA_DIR=...` | `.env` with just env overrides (optional) |
| Plugin cache at `~/.claude/plugins/cache/` | Deleted entirely |

### Script Changes

All 4 bash scripts (`fmp-api.sh`, `gemini-search.sh`, `perplexity-api.sh`, `exa-api.sh`) get simplified env loading:

```bash
# Before: 3-level env chain (plugin root → ~/.config → data dir)
# After: simple — data/.env for API keys, ./data as default data dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$PROJECT_ROOT/data"
if [[ -f "$DATA_DIR/.env" ]]; then source "$DATA_DIR/.env"; fi
```

The `knowledge-dir` command simplifies to just `echo "$PROJECT_ROOT/knowledge"` — no more sync/copy logic.

### Welcome Banner

SessionStart hook displays ASCII art banner with `#85a9ff` blue (ANSI true color: `\033[38;2;133;169;255m`).

Dynamic elements:
- Version (from CLAUDE.md or hardcoded)
- API key status (checks data/.env)
- Portfolio count (counts entries in knowledge/current-portfolio.md)
- Last scan date (most recent file in data/scans/)

### Data Migration

Copy from `edenfintech-scanner-data/` into `data/`:
- `cache/` — preserved API response cache
- `scans/` — past scan reports
- `research/` — sector research
- `result/` — Gemini review results
- `.env` — API keys
- `knowledge/` — NOT copied (source `knowledge/` is now canonical)

### Cleanup

1. Unregister plugin from `~/.claude/plugins/installed_plugins.json`
2. Disable in `~/.claude/settings.json` → `enabledPlugins`
3. Delete `~/.claude/plugins/cache/edenfintech-scanner/` (all 19 versions)
4. Delete `.claude-plugin/` directory from source repo
5. Old `edenfintech-scanner-data/` repo can be archived after confirming migration

### Risks

- **Sub-agents and relative paths**: Agents spawned via Task tool inherit the cwd. Since we always run from project root, `scripts/` resolves correctly. Same as current behavior where `${CLAUDE_PLUGIN_ROOT}` resolved to the cache dir.
- **No more `~/.config/edenfintech-scanner/.env` fallback**: Simplification. API keys live in one place: `data/.env`.
