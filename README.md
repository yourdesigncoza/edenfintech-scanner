# EdenFinTech Scanner

On-demand NYSE stock scanner for Claude Code using the EdenFinTech deep value turnaround strategy.

Multi-agent pipeline: screener filters NYSE stocks (60%+ off ATH, solvency, growth checks), then parallel analyst agents score survivors on valuation, catalysts, and moats. Outputs ranked reports with position sizing.

## Setup

1. Install as a Claude Code plugin
2. Get an API key from [Financial Modeling Prep](https://financialmodelingprep.com/developer/docs/)
3. Create `.env` in the plugin root:
   ```
   FMP_API_KEY=your_key_here
   ```

### API Tier Requirements

| Scan Type | API Calls | Tier Needed |
|-----------|-----------|-------------|
| Specific tickers (2-3) | ~20-40 | Free (250/day) |
| Sector-focused | ~50-150 | Free (250/day) |
| Full NYSE | ~500+ | Paid |

## Usage

From Claude Code:

```
/scan-stocks                        # full NYSE scan
/scan-stocks consumer staples       # sector-focused scan
/scan-stocks CPS BABA HRL          # specific ticker analysis (skips screening)
```

Reports are saved to `$SCANNER_DATA_DIR/scans/{YYYY-MM-DD}-{scan-type}-scan-report.md`.

## How It Works

```
/scan-stocks (skill entry point)
    -> Orchestrator (coordinator)
        -> Screener (Phase 1: quantitative filtering)
            - Broken chart detection (60%+ off ATH)
            - Industry exclusion filter
            - 5-check filter: solvency, dilution, revenue growth, ROIC, valuation
            - Reduces thousands to 5-15 survivors
        -> Analyst agents (Phase 2: deep analysis, one per industry cluster, parallel)
            - Competitor comparison
            - Qualitative deep dive (moats, management, catalysts)
            - 4-input valuation model (Revenue x FCF Margin x Multiple / Shares)
            - Decision scoring with position sizing
    -> Final ranked report
```

### Strategy Hard Rules

These are non-negotiable and cannot be bypassed:

- **30% CAGR hurdle** on base case (20%+ exception only with top-tier CEO + 6yr+ runway)
- **No catalysts = automatic pass** (reject)
- **Excluded industries** are hard filtered (see `knowledge/excluded-industries.md`)
- **Max 12 positions**, 50% single-theme cap
- **Score < 45 = no investment** (watchlist only)
- **Scoring runs once** — no revising inputs to get a better number

### Scoring Formula

```
adjusted_downside = downside_pct * (1 + (downside_pct / 100) * 0.5)
Score = (100 - adjusted_downside) * 0.45 + probability * 0.40 + min(cagr, 100) * 0.15
```

| Score | Max Position Size |
|-------|-------------------|
| 75+ | 15-20% |
| 65-74 | 10-15% |
| 55-64 | 6-10% |
| 45-54 | 3-6% |
| < 45 | 0% (Watchlist) |

## Configuration

### Knowledge Files

Edit these to customize strategy behavior:

| File | Purpose |
|------|---------|
| `knowledge/current-portfolio.md` | Current holdings — update when portfolio changes |
| `knowledge/excluded-industries.md` | Hard-filtered industries (with exceptions) |
| `knowledge/scoring-formulas.md` | Scoring math, sizing rules, deployment scenarios |
| `knowledge/strategy-rules.md` | Complete 8-step strategy (source of truth) |
| `knowledge/valuation-guidelines.md` | FCF multiple baselines, heroic assumptions test |

### FMP API Script

Direct API access for ad-hoc queries:

```bash
bash scripts/fmp-api.sh profile CPS       # company profile
bash scripts/fmp-api.sh income CPS         # 10yr income statement
bash scripts/fmp-api.sh balance CPS        # 10yr balance sheet
bash scripts/fmp-api.sh cashflow CPS       # 10yr cash flow
bash scripts/fmp-api.sh ratios CPS         # 10yr financial ratios
bash scripts/fmp-api.sh metrics CPS        # key metrics (ROIC, etc.)
bash scripts/fmp-api.sh price-history CPS  # historical prices
bash scripts/fmp-api.sh ev CPS             # enterprise values
bash scripts/fmp-api.sh peers CPS          # industry peers
bash scripts/fmp-api.sh sbc CPS            # stock-based compensation
bash scripts/fmp-api.sh shares CPS         # shares outstanding history
bash scripts/fmp-api.sh screen-data CPS    # batch: profile + metrics + ratios (3 API calls)
bash scripts/fmp-api.sh screener NYSE "Consumer Defensive"  # sector screener
bash scripts/fmp-api.sh list-nyse          # all NYSE stocks
```

## Disclaimer

This is a research tool, not financial advice. Qualitative assessments (moats, management, probability) are LLM estimates. Valuation multiples involve judgment. Always verify reasoning independently.
