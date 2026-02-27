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
    → final ranked report saved to docs/scans/
```

- **Skill** (`skills/scan-stocks/SKILL.md`): Entry point. Parses user input (full scan / sector / specific tickers), checks FMP API key, spawns orchestrator via Task tool.
- **Orchestrator** (`agents/orchestrator.md`): Dispatches screener, groups survivors by industry cluster, spawns parallel analyst agents (one per cluster), compiles final report.
- **Screener** (`agents/screener.md`): Steps 1-2. Broken-chart detection (60%+ off ATH), industry exclusions, 5-check filter (solvency, dilution, revenue growth, ROIC, valuation). Should reduce thousands to 5-15 survivors.
- **Analyst** (`agents/analyst.md`): Steps 3-6. Competitor comparison, qualitative deep dive (moats, management, catalysts), 4-input valuation model, decision scoring. Hard rule: no catalysts = automatic pass.
- **Knowledge files** (`knowledge/`): Strategy rules, scoring formulas, excluded industries, current portfolio holdings. Agents read these at runtime via `${CLAUDE_PLUGIN_ROOT}/knowledge/`.
- **FMP API script** (`scripts/fmp-api.sh`): Bash wrapper around Financial Modeling Prep API v3. All data fetching goes through this. Commands: screener, profile, income, balance, cashflow, ratios, metrics, price-history, ev, peers, sbc, shares, screen-data, list-nyse.

## Key Conventions

- All agent/skill files use `${CLAUDE_PLUGIN_ROOT}` for paths — never hardcode absolute paths.
- FMP API key lives in `.env` (not committed). Free tier: 250 req/day (sector scans). Paid tier needed for full NYSE scans.
- Scan reports save to `docs/scans/{YYYY-MM-DD}-scan-report.md` and optionally to `/home/laudes/zoot/projects/strategy_EdenFinTech/docs/scans/`.
- Strategy has hard rules that must never be bypassed: 30% CAGR hurdle, no-catalysts = pass, excluded industries list, 12-position max, 50% single-theme cap.

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
```

## Editing Knowledge Files

- `knowledge/current-portfolio.md` — Update whenever holdings change. Orchestrator reads this for portfolio impact analysis.
- `knowledge/excluded-industries.md` — Hard filter. Note the exceptions section (auto parts OK, fintech OK, cell towers OK, medical devices OK).
- `knowledge/scoring-formulas.md` — Decision scoring math, position sizing breakpoints, deployment scenarios.
- `knowledge/strategy-rules.md` — Complete 8-step strategy reference. Source of truth for all agent behavior.

## Scoring Formula Quick Reference

```
adjusted_downside = downside_pct * (1 + (downside_pct / 100) * 0.5)
Score = (100 - adjusted_downside) * 0.45 + probability * 0.40 + min(cagr, 100) * 0.15
```

Position sizing weights: downside 50% / probability 35% / CAGR 15%. Hard caps: CAGR < 30% or probability < 60% → size 0%. Downside 80-99% → max 5%. Downside 100% → max 3%.
