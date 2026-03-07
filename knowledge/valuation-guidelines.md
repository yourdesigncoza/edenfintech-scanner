# Valuation Guidelines

Reference for analyst agents when building the 4-input valuation model.

## Industry FCF Multiple Baselines

| Industry Type | Baseline FCF Multiple | Notes |
|---------------|----------------------|-------|
| Cyclical/Industrials | 12-15x | Lower due to downturn risk, regardless of quality |
| Consumer Staples | 25-28x | Durable brands, stable cash flows justify premium |
| Healthcare | Higher than cyclicals | Regulation, development timelines, cost to bring products to market |
| China/Geopolitical | Apply discount | e.g., 18x instead of low 20s for a business that would be 25x if US-based |

## Multiple Adjustment Factors

**Adjust UP for:**
- Above-average ROIC/ROCE + durable competitive advantages (moats)
- Faster growth than industry peers
- Improving fundamentals (margin expansion, deleveraging)

**Adjust DOWN for:**
- Above-average leverage relative to peers or own history
- Elevated risks (regulatory, geopolitical, cyclical)
- Deteriorating fundamentals (declining margins, rising debt, losing market share)

### Discount Schedule

Apply these discounts cumulatively from the industry baseline multiple:

| Condition | Discount |
|-----------|----------|
| Revenue or volume declining 2+ consecutive years | -3x to -5x |
| Above-average leverage vs peers (debt/equity > industry median) | -2x to -4x |
| Regulatory, geopolitical, or structural risk | -2x to -3x |
| Limited pricing power (commodity product, private label pressure) | -1x to -3x |
| Secular industry headwind (not full decline — that fails Step 1) | -2x to -4x |

Discounts are cumulative. Example: a Consumer Staples stock (baseline 25-28x) with declining revenue (-4x) and a secular headwind (-3x) starts at ~18-21x, not 22-25x.

Always show the discount path in the analysis: baseline → each applicable discount → resulting multiple.

### Consistency Rule

Within a single scan, no candidate's FCF multiple may deviate by more than 5x from the scan's median multiple without explicit written justification in the valuation section. If the justification cannot be articulated in 2 sentences, the multiple is wrong — revise it.

## The Simplicity Principle

> "I don't use complex models, and I don't believe you need them. An investable idea should be obvious."

> "If the valuation requires heroic assumptions to work, the idea isn't obvious enough."

A valuation is "heroic" if ANY of:
- Revenue growth required is 3x the industry average
- FCF margin estimate exceeds the company's 10-year peak
- FCF multiple exceeds the company's historical median by more than 50%

## Worst-Case Heroic Optimism Test

The Heroic Optimism test applies specifically to worst-case floor estimates. A worst-case floor is "heroically optimistic" if ANY of:
- Trough revenue used is above the company's actual lowest trailing-12-month revenue in 5yr FMP history
- Trough FCF margin used is above the company's actual lowest annual FCF margin in 5yr FMP history
- Trough FCF multiple used is above the industry baseline (before any discount schedule adjustments)
- The analyst adjusted the mechanical floor price UPWARD without documenting why trough conditions are implausible

When a Heroic Optimism flag is triggered, the analyst MUST provide a 1-2 sentence justification. If the justification cannot be articulated clearly, use the mechanical floor without adjustment.

Note: This test is separate from the existing base-case simplicity principle above. The base-case test checks for heroic assumptions in the price target. This test checks for heroic assumptions in the worst case (floor).

## Downside Calibration Policy (Phase 5)

Goal: keep downside deterministic while avoiding mechanically extreme "Frankenstein" floors in known edge cases.

### Default Rule (still primary)

Use trough anchors from 5-year history:
- revenue: minimum 5-year TTM revenue
- FCF margin: minimum 5-year annual FCF margin
- multiple: industry baseline minus discounts
- shares: current diluted shares

### Approved Deterministic Exceptions

Only these exceptions are allowed:

1. `growth_revenue_bound_70pct_current`
- Trigger: 5-year revenue CAGR >= 15% AND minimum 5-year revenue < 70% of current revenue
- Action: use `max(min_5y_revenue, 70% of current revenue)` as trough revenue
- Deterministic helper: `calc-score.sh revenue-floor`

2. `margin_outlier_adjustment_second_lowest`
- Trigger: lowest 5-year FCF margin is >= 8 percentage points below second-lowest
- Action: use second-lowest margin as trough margin
- Deterministic helper: `calc-score.sh margin-floor`

### Audit Requirement

When exception(s) are used, analysts must state:
- rule name
- trigger condition
- helper output (JSON)

Any unlisted downside adjustment is non-compliant.

## TBV Cross-Check

After computing the worst-case floor price, cross-check against tangible book value per share (TBV/share) from the FMP balance sheet.

| Condition | Action |
|-----------|--------|
| Floor > 2x TBV/share | Flag for review -- floor may be too optimistic for asset-heavy companies |
| TBV/share is negative | Note in trough path -- negative TBV suggests structural solvency risk, floor should reflect this |
| Floor < TBV/share | No flag needed -- pessimistic floor is acceptable (asymmetric override) |

TBV = Total Assets - Total Liabilities - Intangible Assets - Goodwill. Use the most recent quarterly balance sheet from FMP.

The TBV cross-check is a sanity check, not a binding constraint. Asset-light businesses (software, services) may legitimately have floors far above TBV. The flag prompts review, not automatic rejection.

## Position Sizing Note

Position sizing applies to NEW capital allocation only. Existing positions that have grown beyond target size are governed by sell rules (Step 8), not sizing rules.
