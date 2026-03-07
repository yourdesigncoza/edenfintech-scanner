# EdenFinTech Scanner

NYSE deep value turnaround scanner. Multi-agent pipeline: screener filters broken-chart stocks through quantitative checks, then parallel analysts score survivors on valuation, catalysts, and moats. Outputs ranked reports with position sizing.

## Setup

1. Clone this repo and open it in Claude Code
2. Get an API key from [Financial Modeling Prep](https://financialmodelingprep.com/developer/docs/)
3. Set `FMP_API_KEY` in `data/.env`
4. Optional: set `GEMINI_API_KEY` for web-grounded research, `MASSIVE_API_KEY` for SEC risk factors

| Scan Type | API Calls | Tier Needed |
|-----------|-----------|-------------|
| Specific tickers (2-3) | ~20-40 | Free (250/day) |
| Sector-focused | ~50-150 | Free (250/day) |
| Full NYSE | ~500+ | Paid ($22/mo) |

## Quick Start

### 1. Hydrate sector knowledge (one-time per sector)

Pre-load sector-specific valuation approaches, turnaround precedents, and risk profiles. This makes scan analysis significantly better. Requires Gemini API key.

```
/sector-hydrate Banking
/sector-hydrate "Consumer Defensive"
/sector-hydrate Healthcare
```

Output: `knowledge/sectors/<sector-slug>/` — checked into the repo, reused across scans.

### 2. Run a scan

```
/scan-stocks                        # full NYSE scan (paid tier)
/scan-stocks consumer staples       # sector-focused
/scan-stocks CPS BABA HRL          # specific tickers (skips screening)
```

### 3. Review an existing holding (Step 8)

```
/review-holding CPS
/review-holding PYPL HRL
```

Outputs thesis status, catalyst tracking, forward-return refresh, and explicit sell-trigger checks.

### 4. Read the report

Reports save to `data/scans/{YYYY-MM-DD}-{scan-type}-scan-report.md`.
Structured JSON artifacts save alongside them in `data/scans/json/` and `docs/scans/json/`.

Each report contains:
- Executive summary with ranked candidates
- Per-stock analysis: valuation, catalysts, moats, risks
- Decision scores with position sizing recommendations
- Epistemic confidence ratings (how trustworthy is the estimate?)
- Deterministic markdown rendered from validated JSON structure

### 5. What to do next

After a scan completes, here's your decision tree:

**Score 65+ candidates (strong):**
1. Read the full analyst write-up in the report
2. Verify the catalyst thesis — is the catalyst real and time-bound?
3. Check `knowledge/current-portfolio.md` for theme overlap (50% single-theme cap)
4. Pull additional data: `bash scripts/fmp-api.sh income TICK` / `balance` / `cashflow`
5. If conviction holds, update `current-portfolio.md` and size per the score table

**Score 45-64 candidates (watchlist):**
1. Note the key catalyst the analyst identified
2. Set a price alert or calendar reminder to re-check
3. Re-scan the ticker in 1-3 months: `/scan-stocks TICK`

**Score < 45 or "Pass" candidates:**
1. Skip — the math doesn't work at current prices
2. May re-enter consideration if price drops another 20-30%

**No survivors from a sector scan:**
1. The sector may not have deep value opportunities right now
2. Try adjacent sectors or wait for a market pullback
3. Run `/scan-stocks` full NYSE to cast a wider net

**Challenging a result:**
- Ask Claude to drill into a specific stock: "Tell me more about TICK's valuation assumptions"
- Pull raw data: `bash scripts/fmp-api.sh screen-data TICK` (profile + metrics + ratios)
- Re-run with fresh data: `bash scripts/fmp-api.sh --fresh profile TICK`

### 5. Audit the scanner itself

After major changes to knowledge files, agents, or scoring logic:

```
/gemini-review
```

Produces a structured audit report with severity-rated findings, stress tests, and a confidence score. Saved to `data/result/`.

### 6. Run methodology regression harness

Use the canonical suite to detect methodology drift after rule/prompt/calculator changes:

- Suite: `docs/regression/methodology-canonical-suite.md`
- Case template: `docs/regression/methodology-regression-template.md`
- Changelog: `docs/regression/methodology-regression-changelog.md`

Review outcome categories:
- `no_drift`
- `soft_drift`
- `material_drift`
- `intentional_drift` (must be logged)

### 7. Structured Report Pipeline

Scan reports and holding reviews now support a JSON-first path:

- Templates:
  - `schemas/scan-report.template.json`
  - `schemas/holding-review.template.json`
- Schema references:
  - `schemas/scan-report.schema.json`
  - `schemas/holding-review.schema.json`
- Validator/renderer:
  - `python3 scripts/report_json.py validate-scan <json_path>`
  - `python3 scripts/report_json.py render-scan <json_path> <markdown_path>`
  - `python3 scripts/report_json.py validate-holding <json_path>`
  - `python3 scripts/report_json.py render-holding <json_path> <markdown_path>`

This is the local equivalent of structured outputs for Claude Code workflows: validate JSON first, then render markdown from the validated object.

## How It Works

```
/scan-stocks
    -> Orchestrator
        -> Screener (Phase 1: quantitative filtering)
            - Broken chart detection (60%+ off ATH)
            - Industry exclusion filter
            - 5-check filter: solvency, dilution, revenue, ROIC, valuation
            - Reduces thousands to 5-15 survivors
        -> Analyst agents (Phase 2: parallel, one per industry cluster)
            - Competitor comparison
            - Qualitative deep dive (moats, management, catalysts)
            - 4-input valuation: Revenue x FCF Margin x Multiple / Shares
            - Decision scoring + epistemic confidence
        -> Epistemic Reviewer (independent confidence assessment)
    -> Final ranked report with position sizing
```

### Scoring

```
adjusted_downside = downside_pct * (1 + (downside_pct / 100) * 0.5)
Score = (100 - adjusted_downside) * 0.45 + probability * 0.40 + min(cagr, 100) * 0.15
```

Epistemic confidence (1-5) adjusts effective probability via multiplier. Low confidence = smaller position regardless of score.

| Score | Max Position Size |
|-------|-------------------|
| 75+ | 15-20% |
| 65-74 | 10-15% |
| 55-64 | 6-10% |
| 45-54 | 3-6% |
| < 45 | 0% (Watchlist) |

### Hard Rules

- 30% CAGR hurdle (20%+ exception: top-tier CEO + 6yr+ runway)
- No catalysts = automatic pass (reject)
- Excluded industries hard filtered (`knowledge/excluded-industries.md`)
- Max 12 positions, 50% single-theme cap
- Scoring runs once — no revising inputs

## Ongoing Workflow

| When | Do |
|------|----|
| New sector to explore | `/sector-hydrate "Sector Name"` then `/scan-stocks sector name` |
| Regular scan cycle | `/scan-stocks` or sector-focused scan |
| Existing holding review | `/review-holding TICK` |
| Portfolio change | Update `knowledge/current-portfolio.md` |
| Spot-check a ticker | `/scan-stocks TICK` or `bash scripts/fmp-api.sh screen-data TICK` |
| After strategy/agent changes | `/gemini-review` |
| Cache getting stale | `bash scripts/fmp-api.sh cache-status` / `cache-clear` |

## FMP API Script

Direct access for ad-hoc queries. All calls cached transparently.

```bash
# Company data
bash scripts/fmp-api.sh profile CPS        # company profile
bash scripts/fmp-api.sh screen-data CPS     # batch: profile + metrics + ratios (3 calls)
bash scripts/fmp-api.sh income CPS          # 10yr income statement
bash scripts/fmp-api.sh balance CPS         # 10yr balance sheet
bash scripts/fmp-api.sh cashflow CPS        # 10yr cash flow
bash scripts/fmp-api.sh ratios CPS          # 10yr financial ratios
bash scripts/fmp-api.sh metrics CPS         # key metrics (ROIC, etc.)
bash scripts/fmp-api.sh ev CPS             # enterprise values
bash scripts/fmp-api.sh peers CPS          # industry peers
bash scripts/fmp-api.sh price-history CPS  # historical prices
bash scripts/fmp-api.sh sbc CPS            # stock-based compensation
bash scripts/fmp-api.sh shares CPS         # shares outstanding history
bash scripts/fmp-api.sh risk-factors CPS   # SEC 10-K risk factors (Massive.com)

# Screening
bash scripts/fmp-api.sh screener NYSE "Consumer Defensive"
bash scripts/fmp-api.sh list-nyse

# Cache management
bash scripts/fmp-api.sh cache-status       # fresh/stale counts, size
bash scripts/fmp-api.sh cache-clear        # wipe all cache
bash scripts/fmp-api.sh --fresh profile CPS  # bypass cache for one call
bash scripts/fmp-api.sh data-dir           # show data directory path
```

## Configuration

| File | Purpose |
|------|---------|
| `knowledge/current-portfolio.md` | Current holdings — update when portfolio changes |
| `knowledge/excluded-industries.md` | Hard-filtered industries (with exceptions) |
| `knowledge/scoring-formulas.md` | Scoring math, sizing rules, deployment scenarios |
| `knowledge/strategy-rules.md` | Complete 8-step strategy (source of truth) |
| `knowledge/valuation-guidelines.md` | FCF multiple baselines, heroic assumptions test |
| `knowledge/sectors/` | Hydrated sector knowledge (per sub-sector analysis) |

## Disclaimer

Research tool, not financial advice. Qualitative assessments (moats, management, probability) are LLM estimates. Valuation multiples involve judgment. Always verify reasoning independently.
