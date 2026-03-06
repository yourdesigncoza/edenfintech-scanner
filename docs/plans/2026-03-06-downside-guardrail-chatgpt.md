Here’s the **short operational spec** version for Claude Code Agent.

---

# Worst-Case Downside Framework — Operational Spec

## Objective

Standardize downside estimation so the same stock, run on the same day with the same data, produces roughly the same downside range unless facts materially differ.

Downside must be:

* data-anchored
* reproducible
* explainable
* conservative but credible

---

## Required Output

Every analysis must output:

* `primary_floor_method`
* `secondary_cross_check`
* `revenue_assumption`
* `margin_assumption`
* `multiple_assumption`
* `share_count_assumption`
* `floor_price`
* `downside_pct`
* `event_risk_override`
* `method_selection_reason`

---

## Allowed Floor Methods

### 1. Historical Trough Multiple

Use when the business has a meaningful public trading history and valuation compression is the main downside mechanism.

**Formula:**
`floor_price = (conservative_FCF * trough_multiple) / worst_case_share_count`

### 2. Historical Trough Fundamentals

Use when the business is cyclical or operational deterioration is the main downside mechanism.

**Formula:**
`floor_price = (trough_revenue * trough_margin * conservative_multiple) / worst_case_share_count`

### 3. Tangible Book / Asset Floor

Use for financials, lenders, insurers, or asset-heavy distressed businesses.

**Formula:**
`floor_price = tangible_book_per_share`
or approved asset proxy if tangible book is not suitable.

### 4. Event-Risk Override

Use when normal downside methods understate real risk.

**Trigger examples:**

* active litigation
* fraud allegation
* regulatory investigation
* solvency/refinancing stress
* governance collapse
* binary customer loss

This does not replace derivation. It forces a harsher floor methodology.

---

## Method Selection Logic

Use this order by default:

1. Historical Trough Multiple
2. Historical Trough Fundamentals
3. Tangible Book / Asset Floor
4. Event-Risk Override if triggered

### Selection rule

The analyst must choose:

* one `primary_floor_method`
* one `secondary_cross_check`

If no valid method fits, mark:

* `downside_status = manual_review_required`

Do not invent a narrative floor from scratch.

---

## Lookback Rules

### Historical data window

Use a **5-10 year lookback**, depending on data availability.

### Trough multiple

Use the **lowest credible historical trading multiple** in the lookback window.

### Trough fundamentals

Use:

* lowest credible revenue band
* lowest credible FCF or operating margin band

Do not use one-off anomaly values unless clearly justified.

---

## Input Rules

### Revenue assumption

Worst-case revenue must be one of:

* flat vs current/base year
* lowest recent historical revenue band
* moderate decline if event risk justifies it

### Margin assumption

Worst-case margin must be one of:

* lowest historical margin band
* compressed but historically observed level
* harsher level if event-risk override applies

### Multiple assumption

Allowed sources:

* historical trough multiple
* sector trough multiple
* methodology-approved conservative multiple

Not allowed:

* arbitrary multiple with no anchor

### Share count assumption

Default:

* current diluted share count

Use higher share count if:

* dilution risk exists
* buybacks likely pause
* capital stress exists

Do not assume aggressive future buybacks in a worst case unless already substantially executed.

---

## Cross-Check Rule

Each downside estimate must be checked against one secondary method where feasible.

Examples:

* trough multiple cross-checked against trough fundamentals
* trough fundamentals cross-checked against tangible book
* downside floor cross-checked against event-risk floor

### Flag threshold

Flag the result if either condition is true:

* downside differs by **10 percentage points or more**
* floor price differs by **20% or more**

If flagged:

* require explicit written justification
* otherwise mark `consistency_warning = true`

---

## Variance Control Rule

For the same stock on the same day, downside estimates should not materially diverge across scans without explanation.

### Material divergence

Any of the following:

* `>= 10 percentage points` downside difference
* `>= 20%` floor price difference
* different floor methods without stated reason

If divergence exists:

* classify as `analyst_variability`
* not as genuine signal
* require review or stricter anchoring

---

## Event-Risk Override Rules

Set `event_risk_override = true` if any of the following are active and unresolved:

* securities litigation
* fraud or accounting allegation
* regulatory enforcement/investigation
* liquidity or refinancing cliff
* major governance disruption
* customer concentration break
* covenant risk

### Override behavior

When override is true:

* do not rely only on “normal cyclical” downside
* apply harsher margin / multiple / dilution assumptions
* explain the path explicitly

---

## Prohibited Practices

Reject methodology compliance if downside is based on:

* unsupported “what if” narrative
* unanchored multiple
* unanchored margin collapse
* arbitrary share count change
* floor percentage without derivation path

If any of the above occurs:

* `methodology_compliant = false`

---

## Suggested Output Schema

```json
{
  "primary_floor_method": "historical_trough_multiple",
  "secondary_cross_check": "historical_trough_fundamentals",
  "revenue_assumption": 33000000000,
  "margin_assumption": 0.13,
  "multiple_assumption": 8.0,
  "share_count_assumption": 960000000,
  "floor_price": 35.75,
  "downside_pct": 23.6,
  "event_risk_override": false,
  "consistency_warning": false,
  "downside_status": "ok",
  "methodology_compliant": true,
  "method_selection_reason": "Historical trough multiple is meaningful due to long public trading history and asset-light model."
}
```

---

## Decision Rules Summary

### Accept downside estimate if:

* approved method used
* derivation path shown
* assumptions anchored
* cross-check within threshold or justified
* no prohibited practice detected

### Reject downside estimate if:

* narrative-only
* floor method missing
* multiple/margin/share count unsupported
* cross-check divergence unexplained

---

## Default Philosophy

The agent must not ask:

> what downside story sounds plausible?

The agent must ask:

> what downside floor is most conservative, credible, and reproducible from available data?
