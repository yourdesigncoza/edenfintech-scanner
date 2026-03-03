# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Claude Code plugin that implements an on-demand NYSE stock scanner using the EdenFinTech deep value turnaround strategy. Not a traditional codebase — it's a multi-agent pipeline defined in markdown, with a single bash script for API access.

## Architecture

```
/scan-stocks skill (entry point)
    → orchestrator agent (coordinator)
        → screener agent (Phase 1: quantitative filtering, Steps 1-2)
        → analyst agents (Phase 2: deep analysis, Steps 3-6, one per industry cluster, parallel)
    → final ranked report saved to $SCANNER_DATA_DIR/scans/ (+ docs/scans/)
```

- **Skill** (`skills/scan-stocks/SKILL.md`): Entry point. Parses user input (full scan / sector / specific tickers), checks FMP API key, spawns orchestrator via Task tool with `subagent_type: "general-purpose"`.
- **Orchestrator** (`agents/orchestrator.md`): Dispatches screener, groups survivors by industry cluster, spawns parallel analyst agents (one per cluster), compiles final report. Has Task tool access to spawn sub-agents.
- **Screener** (`agents/screener.md`): Steps 1-2. Broken-chart detection (60%+ off ATH), industry exclusions, 5-check filter (solvency, dilution, revenue growth, ROIC, valuation). Should reduce thousands to 5-15 survivors. No Task tool — leaf agent.
- **Analyst** (`agents/analyst.md`): Steps 3-6. Competitor comparison, qualitative deep dive (moats, management, catalysts), 4-input valuation model, decision scoring. Hard rule: no catalysts = automatic pass. No Task tool — leaf agent.
- **Knowledge files** (`$SCANNER_DATA_DIR/knowledge/`): Strategy rules, scoring formulas, excluded industries, current portfolio holdings, valuation guidelines. Agents resolve path via `bash scripts/fmp-api.sh knowledge-dir`. Source copies in `knowledge/` for git tracking; runtime reads from data dir.
- **Sector knowledge** (`$SCANNER_DATA_DIR/knowledge/sectors/`): Per-sector hydrated knowledge files produced by `/sector-hydrate`. Sub-sector analysis, regulation, valuation approaches, evidence requirements. Registry at `_registry.md`.
- **Sector Coordinator** (`agents/sector-coordinator.md`): Orchestrates sector hydration — discovers sub-sectors via FMP + Perplexity, spawns parallel researchers, synthesizes output. Has Task tool.
- **Sector Researcher** (`agents/sector-researcher.md`): Leaf agent for sector research. 2-phase: (A) fires 8 parallel `perplexity_ask` queries for cited facts, (B) Claude synthesizes results into structured output. No Task tool.
- **FMP API script** (`scripts/fmp-api.sh`): Bash wrapper around Financial Modeling Prep **Stable API** (`https://financialmodelingprep.com/stable`). All data fetching goes through this.
- **Plugin manifest** (`.claude-plugin/marketplace.json`): Plugin metadata for Claude Code plugin system.

Data flows between agents via Task tool prompt/response — the orchestrator passes scan parameters down and collects structured markdown results back.

## Key Conventions

- All agent/skill files use `${CLAUDE_PLUGIN_ROOT}` for script/agent paths. Knowledge files use `$KNOWLEDGE_DIR` (resolved via `bash scripts/fmp-api.sh knowledge-dir`) which points to `$SCANNER_DATA_DIR/knowledge/`. Never hardcode absolute paths.
- API keys live in `$SCANNER_DATA_DIR/.env` (survives plugin cache refreshes). Plugin root `.env` only has `SCANNER_DATA_DIR`. Free tier: 250 req/day (sector scans). Paid tier needed for full NYSE scans.
- Scan reports save to `$SCANNER_DATA_DIR/scans/{YYYY-MM-DD}-{scan-type}-scan-report.md` (primary), with copies to `docs/scans/` and `/home/laudes/zoot/projects/strategy_EdenFinTech/docs/scans/`. Naming: `full-nyse`, `consumer-defensive`, or `CPS-BABA-HRL`.
- Strategy has hard rules that must never be bypassed: 30% CAGR hurdle, no-catalysts = pass, excluded industries list, 12-position max, 50% single-theme cap.
- Agent YAML frontmatter defines tool permissions: orchestrator has `Task`, screener/analyst do not. All agents have `Bash`, `Read`, `Write`, `Grep`, `Glob`, `WebSearch`, `WebFetch`.

## FMP API Script Details

```bash
bash scripts/fmp-api.sh <command> [args...]
```

Commands: `screener`, `profile`, `income`, `balance`, `cashflow`, `ratios`, `metrics`, `price-history`, `ev`, `peers`, `sbc`, `shares`, `screen-data`, `list-nyse`, `risk-factors`.

Rate limit awareness:
- `screen-data` makes **3 API calls** per ticker (profile + metrics + ratios) — budget accordingly.
- `list-nyse` returns up to 5000 stocks in one call.
- `screener` accepts optional exchange and sector args: `screener NYSE "Consumer Defensive"`.
- `sbc` and `shares` pipe JSON through python3 for formatting.

## Testing / Running

```bash
# Verify FMP API key is configured
bash scripts/fmp-api.sh help

# Test a single API call
bash scripts/fmp-api.sh profile CPS

# Invoke the full scan pipeline (from Claude Code)
/scan-stocks                        # full NYSE scan
/scan-stocks consumer staples       # sector-focused scan
/scan-stocks CPS BABA HRL          # specific ticker analysis (skips screening)

# Hydrate sector knowledge (requires Perplexity MCP)
/sector-hydrate Banking             # narrow: Diversified + Regional Banks
/sector-hydrate Healthcare          # full sector
/sector-hydrate "Consumer Defensive"
```

## Editing Knowledge Files

- `knowledge/current-portfolio.md` — Update whenever holdings change. Orchestrator reads this for portfolio impact analysis.
- `knowledge/excluded-industries.md` — Hard filter. Note the exceptions section (auto parts OK, fintech OK, cell towers OK, medical devices OK).
- `knowledge/scoring-formulas.md` — Decision scoring math, position sizing breakpoints, deployment scenarios.
- `knowledge/strategy-rules.md` — Complete 8-step strategy reference. Source of truth for all agent behavior.
- `knowledge/valuation-guidelines.md` — FCF multiple baselines by industry, heroic assumptions test, simplicity principle.

## Caching

All FMP API calls are transparently cached to `$SCANNER_DATA_DIR/cache/` (default: separate git repo at `/home/laudes/zoot/projects/edenfintech-scanner-data/`). Same interface, no agent changes needed.

**Cache structure:** `cache/<command>/<TICKER>.json` (screener uses `<exchange>[-<sector>].json`)

**TTLs:** screener/ratios/metrics/ev = 7d, profile/peers = 30d, income/balance/cashflow/risk-factors = 90d, price-history = 1d

**Key behaviors:**
- `--fresh` flag bypasses cache: `bash scripts/fmp-api.sh --fresh profile CPS`
- `screen-data` shares cache with individual `profile`/`metrics`/`ratios` calls
- `sbc` reuses `cashflow` cache, `shares` reuses `ev` cache, `list-nyse` reuses `screener NYSE` cache
- Empty/error responses are never cached

**Cache management commands:**
- `cache-status` — fresh/stale counts per command, total size
- `cache-clear [command]` — wipe all or specific command cache
- `data-dir` — echo data directory path

## Massive.com Integration (Supplementary)

SEC 10-K risk factor data via Massive.com, used as post-scan enrichment only:
- `risk-factors TICKER` — Categorized risk disclosures (90d cache)
- Requires `MASSIVE_API_KEY` in `.env` — get from https://massive.com/dashboard/api-keys
- Free tier: 5 req/min — only called for top 2-4 candidates after ranking, with manual approval
- Orchestrator pauses at Step 5b, presents shortlist, waits for user approval before hydrating
- If shortlist > 10 candidates, halts and flags filtering needs tightening
- If key not set, enrichment step is silently skipped

## Scoring Formula Quick Reference

```
adjusted_downside = downside_pct * (1 + (downside_pct / 100) * 0.5)
Score = (100 - adjusted_downside) * 0.45 + probability * 0.40 + min(cagr, 100) * 0.15
```

Position sizing weights: downside 50% / probability 35% / CAGR 15%. Hard caps: CAGR < 30% or probability < 60% → size 0%. Downside 80-99% → max 5%. Downside 100% → max 3%.
