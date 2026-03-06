# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## What This Is

An on-demand NYSE stock scanner using the EdenFinTech deep value turnaround strategy. A multi-agent pipeline defined in markdown, with bash scripts for API access. Runs as a native Claude Code project (not a plugin).

## Architecture

```
/scan-stocks skill (entry point)
    -> orchestrator agent (coordinator)
        -> screener agent (Phase 1: quantitative filtering, Steps 1-2)
        -> analyst agents (Phase 2: deep analysis, Steps 3-6, one per industry cluster, parallel)
    -> final ranked report saved to data/scans/ (+ docs/scans/)
```

- **Skill** (`.claude/skills/scan-stocks/SKILL.md`): Entry point. Parses user input (full scan / sector / specific tickers), checks FMP API key, spawns orchestrator via Task tool.
- **Orchestrator** (`.claude/agents/orchestrator.md`): Dispatches screener, groups survivors by industry cluster, spawns parallel analyst agents (one per cluster), compiles final report. Has Task tool access.
- **Screener** (`.claude/agents/screener.md`): Steps 1-2. Broken-chart detection (60%+ off ATH), industry exclusions, 5-check filter (solvency, dilution, revenue growth, ROIC, valuation). No Task tool — leaf agent.
- **Analyst** (`.claude/agents/analyst.md`): Steps 3-6. Competitor comparison, qualitative deep dive (moats, management, catalysts), 4-input valuation model, decision scoring. No Task tool — leaf agent.
- **Knowledge files** (`knowledge/`): Strategy rules, scoring formulas, excluded industries, current portfolio holdings, valuation guidelines. Read directly from project root.
- **Sector knowledge** (`knowledge/sectors/`): Per-sector hydrated knowledge files produced by `/sector-hydrate`. Registry at `_registry.md`.
- **Sector Coordinator** (`.claude/agents/sector-coordinator.md`): Orchestrates sector hydration. Has Task tool.
- **Sector Researcher** (`.claude/agents/sector-researcher.md`): Leaf agent for sector research. 2-phase: Gemini Grounded Search queries then Claude synthesis.
- **FMP API script** (`scripts/fmp-api.sh`): Bash wrapper around Financial Modeling Prep **Stable API** (`https://financialmodelingprep.com/stable`).
- **Gemini Grounded Search script** (`scripts/gemini-search.sh`): Bash wrapper around Gemini API with Google Search grounding. Free tier: 500 req/day (Flash), 1500/day (Pro). Cached to `data/cache/gemini-search/` (1-day TTL).
- **Perplexity API script** (`scripts/perplexity-api.sh`): Retained as fallback. Cached to `data/cache/perplexity/` (1-day TTL).

Data flows between agents via Task tool prompt/response.

## Key Conventions

- All agent/skill files use project-relative paths: `scripts/`, `.claude/agents/`, `knowledge/`. Never hardcode absolute paths.
- API keys live in `data/.env`. Free tier: 250 req/day (sector scans). Paid tier needed for full NYSE scans.
- Scan reports save to `data/scans/{YYYY-MM-DD}-{scan-type}-scan-report.md` (primary), with copies to `docs/scans/` and `/home/laudes/zoot/projects/strategy_EdenFinTech/docs/scans/`. Naming: `full-nyse`, `consumer-defensive`, or `CPS-BABA-HRL`.
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

## Gemini Grounded Search Details

```bash
bash scripts/gemini-search.sh <command> [args...]
```

Commands: `ask [--model flash|pro|flash2]`, `usage`, `help`. Use `--fresh` to bypass cache.

API key resolution chain: `data/.env` -> `~/.claude.json` (reads from Gemini MCP server config).

**Free tier limits:** 500 req/day (Flash), 1500 req/day (Pro). Usage tracked daily — run `bash scripts/gemini-search.sh usage` to check.

## Perplexity API Script (Fallback)

```bash
bash scripts/perplexity-api.sh <command> [args...]
```

Retained as fallback if Gemini quota is exhausted. Commands: `ask`, `search`, `reason`.

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

# Hydrate sector knowledge
/sector-hydrate Banking             # narrow: Diversified + Regional Banks
/sector-hydrate Healthcare          # full sector
/sector-hydrate "Consumer Defensive"
```

## Editing Knowledge Files

- `knowledge/current-portfolio.md` — Update whenever holdings change.
- `knowledge/excluded-industries.md` — Hard filter. Note the exceptions section.
- `knowledge/scoring-formulas.md` — Decision scoring math, position sizing breakpoints.
- `knowledge/strategy-rules.md` — Complete 8-step strategy reference. Source of truth.
- `knowledge/valuation-guidelines.md` — FCF multiple baselines by industry.

## Caching

All FMP API calls are transparently cached to `data/cache/`. Same interface, no agent changes needed.

**Cache structure:** `cache/<command>/<TICKER>.json` (screener uses `<exchange>[-<sector>].json`)

**TTLs:** screener/ratios/metrics/ev = 7d, profile/peers = 30d, income/balance/cashflow/risk-factors = 90d, price-history = 1d

**Key behaviors:**
- `--fresh` flag bypasses cache: `bash scripts/fmp-api.sh --fresh profile CPS`
- `screen-data` shares cache with individual `profile`/`metrics`/`ratios` calls
- Empty/error responses are never cached

**Cache management commands:**
- `cache-status` — fresh/stale counts per command, total size
- `cache-clear [command]` — wipe all or specific command cache
- `data-dir` — echo data directory path

## Massive.com Integration (Supplementary)

SEC 10-K risk factor data via Massive.com, used as post-scan enrichment only:
- `risk-factors TICKER` — Categorized risk disclosures (90d cache)
- Requires `MASSIVE_API_KEY` in `data/.env`
- Free tier: 5 req/min — only called for top 2-4 candidates after ranking, with manual approval

## Scoring Formula Quick Reference

```
adjusted_downside = downside_pct * (1 + (downside_pct / 100) * 0.5)
Score = (100 - adjusted_downside) * 0.45 + probability * 0.40 + min(cagr, 100) * 0.15
```

Position sizing weights: downside 50% / probability 35% / CAGR 15%. Hard caps: CAGR < 30% or probability < 60% -> size 0%. Downside 80-99% -> max 5%. Downside 100% -> max 3%.
