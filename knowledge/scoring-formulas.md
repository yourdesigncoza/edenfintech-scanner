# Scoring Formulas

## Decision Scoring (Buy/Don't Buy)

Used to compare opportunities and decide whether to invest.

| Input | Weight | Description |
|-------|--------|-------------|
| Reasonable worst case downside | 45% | % decline in share price if thesis is wrong |
| Base case probability | 40% | Likelihood base case valuation (or better) plays out |
| Base case CAGR | 15% | Annual return implied by base case |

### Downside Penalty Curve

Downside risk is scored on a non-linear curve:
- Moving from 20% downside to 30% carries ~1.5x the penalty the raw numbers suggest
- High-risk stocks are punished disproportionately more
- A stock with 60% downside is dramatically worse than one with 30% (not just "twice as bad")

### Scoring Formula

```
Score = (100 - adjusted_downside) * 0.45 + probability * 0.40 + min(cagr, 100) * 0.15
```

Where `adjusted_downside` applies the 1.5x penalty curve:
```
adjusted_downside = downside_pct * (1 + (downside_pct / 100) * 0.5)
```

Example: 30% downside → adjusted = 30 * 1.15 = 34.5. 60% downside → adjusted = 60 * 1.30 = 78.

## Position Sizing

Used to determine how much capital goes into each position.

| Input | Weight | Description |
|-------|--------|-------------|
| Estimated % downside (worst case) | 50% | Higher weight than decision scoring |
| Estimated probability base case happens | 35% | |
| CAGR from base case | 15% | |

### Hard Breakpoints (Override Everything)

| Condition | Result |
|-----------|--------|
| Expected CAGR below 30% | Position size = 0% (no investment) |
| Probability of base case below 60% | Position size = 0% (no investment) |
| Downside risk of 80-99% | Position capped at 5% |
| Downside risk of 100% (total loss possible) | Position capped at 3% |

### Portfolio-Level Rules

| Rule | Limit |
|------|-------|
| Maximum positions | 12 |
| Maximum single catalyst/theme exposure | 50% |
| Normal leverage | 15% |
| Leverage at S&P -10% | 20% |
| Leverage at S&P -15% | 25% |
| Leverage at S&P -25% | 30% |

## Valuation Formula

```
Revenue x FCF Margin x FCF Multiple / Shares Outstanding = Price Target
```

### CAGR Calculation

```
CAGR = ((target_price / current_price) ^ (1 / years)) - 1
```

### Hurdle Rate

- Primary: 30% annual CAGR minimum
- Exception: 20%+ acceptable IF top-tier CEO + 6yr+ runway (smaller position)

## Deployment Scenarios

### Scenario 1: Cash Available
- Compare new idea's score to best existing position that still has room to add
- Higher score gets the capital

### Scenario 2: No Cash Available
1. Does any current position have forward returns below 15%/year? If yes AND new position has lower downside risk → sell for new idea
2. If no position below 15% → need 40+ point score gap to justify swap

### Scenario 3: No Cash + Already Maxed on Theme
- Compare new idea to weakest holding within same theme only
- Apply Scenario 2 rules

## Sell Triggers

| Trigger | Condition |
|---------|-----------|
| Target reached | Forward returns fall below 30% hurdle |
| Rapid move | Forward returns fall below 10-15%/year |
| Thesis broken | Fundamental business change (not price change) |
