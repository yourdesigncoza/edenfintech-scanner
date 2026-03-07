#!/usr/bin/env bash
# EdenFinTech Scanner — Decision Score Calculator
# Usage: bash calc-score.sh <command> [args...]
# Deterministic math for analyst agents — replaces LLM text-generation arithmetic.

set -euo pipefail

cmd="${1:-help}"
shift || true

usage() {
    cat <<'EOF'
EdenFinTech Scanner — Decision Score Calculator

Usage: bash calc-score.sh <command> [args...]

Commands:
  score <downside_pct> <probability_pct> <cagr_pct> [confidence]
      Calculate decision score using the adjusted downside penalty curve.
      If confidence (1-5) provided, applies PCS multiplier to probability first.

  cagr <current_price> <target_price> <years>
      Calculate CAGR and check against 30% hurdle rate.

  valuation <revenue_billions> <fcf_margin_pct> <multiple> <shares_millions>
      Calculate target price from revenue, FCF margin, multiple, and share count.

  size <score> <cagr_pct> <probability_pct> <downside_pct> [confidence] [binary_flag]
      Determine max position size with all hard breakpoints applied.
      If confidence (1-5) provided, applies confidence-based size cap.
      If binary_flag is "binary", applies binary outcome override (max 5% if confidence <= 3).

  effective-prob <base_probability_pct> <confidence>
      Apply PCS multiplier to base probability. Returns effective probability.
      Confidence must be 1-5.

  floor <revenue_b> <margin_pct> <multiple> <shares_m> <current_price>
      Calculate worst-case floor price from trough inputs.
      Uses same 4-input formula as valuation, plus downside % from current price.
      Trough inputs = historical worst margins/multiples from FMP data.

  momentum <val1> <val2> <val3> <val4> <val5>
      Assess CAGR momentum from 5 annual data points (oldest to newest).
      Computes rolling 3-year CAGRs and determines trend direction.
      Use for revenue, FCF/share, or any annual metric.

  rev-share-trend <rev1> <rev2> <rev3> <rev4> <rev5> <shr1> <shr2> <shr3> <shr4> <shr5>
      Compute 5-year revenue/share series with trend and CAGR summary.
      Inputs are annual values oldest to newest.

  median <val1> [val2 ...]
      Compute median for a numeric series. Useful for ROIC median checks.

  solvency-snapshot <cash> <current_debt> <long_term_debt> <fcf>
      Return standardized solvency summary and heuristic flags for Step 2.

  rough-hurdle <current_price> <revenue_b> <fcf_margin_pct> <multiple> <shares_m> <years>
      Quick screening valuation to estimate target price and implied CAGR band.
      Used for Step 2 valuation pre-check; not a replacement for Step 5 valuation.

  forward-return <current_price> <revenue_b> <fcf_margin_pct> <multiple> <shares_m> <years>
      Refresh forward return from current price using valuation inputs.
      Returns target price, forward CAGR, and hurdle/sell-guardrail checks.

  revenue-floor <current_revenue_b> <min_5y_revenue_b> <revenue_cagr_5y_pct>
      Apply deterministic growth-company revenue floor bound for downside calibration.

  margin-floor <m1> <m2> <m3> <m4> <m5>
      Select calibrated trough FCF margin from 5-year series with outlier handling.

  help
      Show this help text.

Examples:
  bash calc-score.sh score 30 65 39
  bash calc-score.sh score 30 65 39 3          # with confidence multiplier
  bash calc-score.sh cagr 227 607 3
  bash calc-score.sh valuation 2.3 12.0 22 10.0
  bash calc-score.sh size 63.3 39 65 30
  bash calc-score.sh size 63.3 39 65 30 3      # with confidence cap
  bash calc-score.sh size 63.3 39 65 30 3 binary  # with binary override
  bash calc-score.sh effective-prob 65 3        # → 55.25%
  bash calc-score.sh floor 2.2 7.0 10 130 17.52    # trough floor price + downside %
  bash calc-score.sh momentum 1100 1000 950 1050 1150  # 5yr revenue trend
  bash calc-score.sh rev-share-trend 1200 1180 1220 1260 1320 100 101 102 103 104
  bash calc-score.sh median 4.1 8.9 6.0 2.3 7.4
  bash calc-score.sh solvency-snapshot 750 420 980 160
  bash calc-score.sh rough-hurdle 15.25 2.4 11 16 120 3
  bash calc-score.sh forward-return 42.1 8.7 18 16 980 3
  bash calc-score.sh revenue-floor 8.7 4.1 17
  bash calc-score.sh margin-floor -9 2 4 3 5
EOF
}

err() {
    echo "ERROR: $1" >&2
    exit 1
}

validate_number() {
    local name="$1" val="$2"
    if ! python3 -c "float('$val')" 2>/dev/null; then
        err "$name must be a number, got: $val"
    fi
}

validate_pct() {
    local name="$1" val="$2"
    validate_number "$name" "$val"
    python3 -c "
v = float('$val')
if v > 0 and v < 1:
    import sys
    print(f'WARNING: {\"$name\"} = {v} looks like a decimal — expected percentage (e.g., 30 not 0.30)', file=sys.stderr)
"
}

PCS_MULTIPLIER_PY='
def pcs_multiplier(confidence):
    table = {5: 1.00, 4: 0.95, 3: 0.85, 2: 0.70, 1: 0.50}
    c = int(confidence)
    if c < 1 or c > 5:
        raise ValueError(f"confidence must be 1-5, got: {c}")
    return table[c]
'

case "$cmd" in

effective-prob)
    [[ $# -eq 2 ]] || err "effective-prob requires 2 args: <base_probability_pct> <confidence>"
    validate_number "base_probability_pct" "$1"
    validate_number "confidence" "$2"

    python3 -c "
import json
${PCS_MULTIPLIER_PY}

base = float('$1')
confidence = int(float('$2'))
mult = pcs_multiplier(confidence)
effective = round(base * mult, 2)

print(json.dumps({
    'base_probability': base,
    'confidence': confidence,
    'multiplier': mult,
    'effective_probability': effective
}, indent=2))
"
    ;;

score)
    [[ $# -ge 3 && $# -le 4 ]] || err "score requires 3-4 args: <downside_pct> <probability_pct> <cagr_pct> [confidence]"
    validate_pct "downside_pct" "$1"
    validate_pct "probability_pct" "$2"
    validate_pct "cagr_pct" "$3"
    [[ $# -ge 4 ]] && validate_number "confidence" "$4"

    python3 -c "
import json
${PCS_MULTIPLIER_PY}

downside = float('$1')
base_probability = float('$2')
cagr = float('$3')
confidence = int(float('${4:-0}')) if '${4:-}' else None

if confidence is not None:
    mult = pcs_multiplier(confidence)
    probability = round(base_probability * mult, 2)
else:
    mult = None
    probability = base_probability

adjusted_downside = round(downside * (1 + (downside / 100) * 0.5), 2)
risk_component = round((100 - adjusted_downside) * 0.45, 2)
probability_component = round(probability * 0.40, 2)
return_component = round(min(cagr, 100) * 0.15, 2)
total_score = round(risk_component + probability_component + return_component, 2)

result = {
    'downside_pct': downside,
    'adjusted_downside': adjusted_downside,
    'risk_component': risk_component,
    'probability_component': probability_component,
    'return_component': return_component,
    'total_score': total_score
}
if confidence is not None:
    result['base_probability'] = base_probability
    result['confidence'] = confidence
    result['multiplier'] = mult
    result['effective_probability'] = probability

print(json.dumps(result, indent=2))
"
    ;;

cagr)
    [[ $# -eq 3 ]] || err "cagr requires 3 args: <current_price> <target_price> <years>"
    validate_number "current_price" "$1"
    validate_number "target_price" "$2"
    validate_number "years" "$3"

    python3 -c "
import json

current = float('$1')
target = float('$2')
years = float('$3')

if current <= 0:
    raise ValueError('current_price must be positive')
if years <= 0:
    raise ValueError('years must be positive')

cagr_pct = round(((target / current) ** (1 / years) - 1) * 100, 2)
hurdle = 30

print(json.dumps({
    'current_price': current,
    'target_price': target,
    'years': years,
    'cagr_pct': cagr_pct,
    'meets_hurdle': cagr_pct >= hurdle,
    'hurdle': hurdle
}, indent=2))
"
    ;;

valuation)
    [[ $# -eq 4 ]] || err "valuation requires 4 args: <revenue_billions> <fcf_margin_pct> <multiple> <shares_millions>"
    validate_number "revenue_billions" "$1"
    validate_number "fcf_margin_pct" "$2"
    validate_number "multiple" "$3"
    validate_number "shares_millions" "$4"

    python3 -c "
import json

revenue_b = float('$1')
fcf_margin_pct = float('$2')
multiple = float('$3')
shares_m = float('$4')

if shares_m <= 0:
    raise ValueError('shares_millions must be positive')

fcf_margin = fcf_margin_pct / 100
fcf_b = round(revenue_b * fcf_margin, 4)
# target_price = (revenue_b * fcf_margin * multiple * 1e9) / (shares_m * 1e6)
# simplifies to: (fcf_b * multiple * 1000) / shares_m
target_price = round((fcf_b * multiple * 1000) / shares_m, 2)

print(json.dumps({
    'revenue_b': revenue_b,
    'fcf_margin_pct': fcf_margin_pct,
    'fcf_b': round(fcf_b, 4),
    'multiple': multiple,
    'shares_m': shares_m,
    'target_price': target_price
}, indent=2))
"
    ;;

size)
    [[ $# -ge 4 && $# -le 6 ]] || err "size requires 4-6 args: <score> <cagr_pct> <probability_pct> <downside_pct> [confidence] [binary]"
    validate_number "score" "$1"
    validate_pct "cagr_pct" "$2"
    validate_pct "probability_pct" "$3"
    validate_pct "downside_pct" "$4"
    [[ $# -ge 5 ]] && validate_number "confidence" "$5"

    python3 -c "
import json

score = float('$1')
cagr = float('$2')
probability = float('$3')
downside = float('$4')
confidence = int(float('${5:-0}')) if '${5:-}' else None
binary_flag = '${6:-}' == 'binary'

# Score-based sizing
if score >= 75:
    score_band = '75+'
    score_based_max = '15-20%'
elif score >= 65:
    score_band = '65-74'
    score_based_max = '10-15%'
elif score >= 55:
    score_band = '55-64'
    score_based_max = '6-10%'
elif score >= 45:
    score_band = '45-54'
    score_based_max = '3-6%'
else:
    score_band = '<45'
    score_based_max = '0%'

# Hard breakpoints
hard_cap = None
hard_reason = None

if cagr < 30:
    hard_cap = '0%'
    hard_reason = 'CAGR < 30%'
elif probability < 60:
    hard_cap = '0%'
    hard_reason = 'probability < 60%'
elif downside >= 100:
    hard_cap = '3%'
    hard_reason = 'downside = 100% (total loss possible)'
elif downside >= 80:
    hard_cap = '5%'
    hard_reason = 'downside 80-99%'

# Confidence-based size cap (Layer 3)
confidence_cap = None
confidence_cap_reason = None
if confidence is not None:
    cap_table = {5: None, 4: 12, 3: 8, 2: 5, 1: 0}
    if confidence < 1 or confidence > 5:
        raise ValueError(f'confidence must be 1-5, got: {confidence}')
    cap_val = cap_table[confidence]
    if cap_val is not None:
        confidence_cap = f'{cap_val}%'
        confidence_cap_reason = f'confidence {confidence}/5 → max {cap_val}%'
        if cap_val == 0:
            confidence_cap_reason = f'confidence 1/5 → watchlist only'

# Binary outcome override
binary_override = None
if binary_flag and confidence is not None and confidence <= 3:
    binary_override = '5%'

# Determine final size — lowest of all limits
def parse_lower(size_str):
    if size_str is None:
        return 999
    return int(size_str.split('-')[0].replace('%', ''))

candidates = [
    ('score', score_based_max),
    ('hard_breakpoint', hard_cap),
    ('confidence', confidence_cap),
    ('binary_override', binary_override),
]

# Start with score-based
if score_based_max == '0%' or (hard_cap and hard_cap == '0%') or (confidence_cap and confidence_cap == '0%'):
    final_max_size = '0%'
    investable = False
else:
    # Find the most restrictive non-None cap
    active_caps = [(name, val) for name, val in candidates if val is not None]
    if not active_caps:
        final_max_size = score_based_max
    else:
        min_name, min_val = min(active_caps, key=lambda x: parse_lower(x[1]))
        final_max_size = min_val
    investable = final_max_size != '0%'

result = {
    'score': score,
    'score_band': score_band,
    'score_based_max': score_based_max,
    'hard_breakpoint_cap': hard_cap,
    'hard_breakpoint_reason': hard_reason,
    'final_max_size': final_max_size,
    'investable': investable
}
if confidence is not None:
    result['confidence'] = confidence
    result['confidence_cap'] = confidence_cap
    result['confidence_cap_reason'] = confidence_cap_reason
if binary_override is not None:
    result['binary_override'] = binary_override
    result['binary_override_reason'] = f'non-binary outcome + confidence {confidence}/5 ≤ 3 → max 5%'

print(json.dumps(result, indent=2))
"
    ;;

momentum)
    [[ $# -eq 5 ]] || err "momentum requires 5 args: <val1> <val2> <val3> <val4> <val5> (oldest to newest)"
    for i in 1 2 3 4 5; do
        validate_number "val$i" "${!i}"
    done

    python3 -c "
import json

vals = [float('$1'), float('$2'), float('$3'), float('$4'), float('$5')]

# Rolling 3-year CAGRs: periods [0-2], [1-3], [2-4]
def cagr_3yr(start, end):
    if start <= 0:
        return None  # can't compute CAGR from zero/negative base
    return round(((end / start) ** (1.0 / 3.0) - 1) * 100, 2)

period1 = cagr_3yr(vals[0], vals[2])  # year 1 to year 3
period2 = cagr_3yr(vals[1], vals[3])  # year 2 to year 4
period3 = cagr_3yr(vals[2], vals[4])  # year 3 to year 5

cagrs = [p for p in [period1, period2, period3] if p is not None]

if len(cagrs) < 2:
    trend = 'insufficient_data'
    reasoning = 'Cannot compute enough rolling CAGRs (zero/negative base values)'
elif cagrs[-1] > cagrs[0] + 2:
    trend = 'strengthening'
    reasoning = f'Latest rolling CAGR ({cagrs[-1]}%) > earliest ({cagrs[0]}%) by {round(cagrs[-1] - cagrs[0], 2)}pp'
elif cagrs[-1] < cagrs[0] - 2:
    trend = 'weakening'
    reasoning = f'Latest rolling CAGR ({cagrs[-1]}%) < earliest ({cagrs[0]}%) by {round(cagrs[0] - cagrs[-1], 2)}pp'
elif all(c < 0 for c in cagrs):
    trend = 'weakening'
    reasoning = f'All rolling CAGRs negative ({cagrs[0]}% to {cagrs[-1]}%) — persistent decline'
else:
    trend = 'flat'
    reasoning = f'Rolling CAGRs within 2pp band ({cagrs[0]}% to {cagrs[-1]}%)'

# Also check direction of last 2 years (simple growth)
yoy_latest = round(((vals[4] / vals[3]) - 1) * 100, 2) if vals[3] > 0 else None
yoy_prior = round(((vals[3] / vals[2]) - 1) * 100, 2) if vals[2] > 0 else None

result = {
    'values': vals,
    'rolling_cagr_pct': {
        'period_1_to_3': period1,
        'period_2_to_4': period2,
        'period_3_to_5': period3,
    },
    'yoy_growth_pct': {
        'latest': yoy_latest,
        'prior': yoy_prior,
    },
    'trend': trend,
    'reasoning': reasoning,
}

# Gate recommendation for borderline stocks
if trend == 'strengthening':
    result['gate'] = 'PROCEED'
elif trend == 'flat':
    result['gate'] = 'PROCEED_WITH_CAUTION'
    result['note'] = 'Flat momentum — check for catalysts before full analysis'
elif trend == 'weakening':
    result['gate'] = 'EARLY_EXIT'
    result['note'] = 'Borderline CAGR with weakening momentum — no evidence of accelerating growth'
else:
    result['gate'] = 'PROCEED_WITH_CAUTION'
    result['note'] = 'Insufficient data for momentum assessment'

print(json.dumps(result, indent=2))
"
    ;;

rev-share-trend)
    [[ $# -eq 10 ]] || err "rev-share-trend requires 10 args: <rev1> <rev2> <rev3> <rev4> <rev5> <shr1> <shr2> <shr3> <shr4> <shr5>"
    for i in 1 2 3 4 5 6 7 8 9 10; do
        validate_number "arg$i" "${!i}"
    done

    python3 -c "
import json

revenues = [float('$1'), float('$2'), float('$3'), float('$4'), float('$5')]
shares = [float('$6'), float('$7'), float('$8'), float('$9'), float('${10}')]

if any(s <= 0 for s in shares):
    raise ValueError('all share values must be positive')

rev_per_share = [round(revenues[i] / shares[i], 6) for i in range(5)]
start_rps = rev_per_share[0]
end_rps = rev_per_share[-1]

if start_rps <= 0:
    cagr = None
else:
    cagr = round(((end_rps / start_rps) ** (1.0 / 4.0) - 1.0) * 100, 2)

total_change_pct = round(((end_rps / start_rps) - 1.0) * 100, 2) if start_rps > 0 else None

if cagr is None:
    trend = 'insufficient_data'
elif cagr > 2:
    trend = 'improving'
elif cagr < -2:
    trend = 'deteriorating'
else:
    trend = 'flat'

result = {
    'revenues': revenues,
    'shares': shares,
    'revenue_per_share': rev_per_share,
    'rev_per_share_cagr_5y_pct': cagr,
    'rev_per_share_total_change_pct': total_change_pct,
    'trend': trend,
}

if trend == 'deteriorating':
    result['gate'] = 'DILUTION_RISK'
elif trend == 'flat':
    result['gate'] = 'BORDERLINE'
else:
    result['gate'] = 'CLEAR_OR_IMPROVING'

print(json.dumps(result, indent=2))
"
    ;;

median)
    [[ $# -ge 1 ]] || err "median requires at least 1 numeric arg: <val1> [val2 ...]"
    for val in "$@"; do
        validate_number "value" "$val"
    done

    python3 -c "
import json
import statistics

vals = [float(x) for x in '$*'.split()]
med = round(statistics.median(vals), 4)

print(json.dumps({
    'count': len(vals),
    'values': vals,
    'median': med
}, indent=2))
"
    ;;

solvency-snapshot)
    [[ $# -eq 4 ]] || err "solvency-snapshot requires 4 args: <cash> <current_debt> <long_term_debt> <fcf>"
    validate_number "cash" "$1"
    validate_number "current_debt" "$2"
    validate_number "long_term_debt" "$3"
    validate_number "fcf" "$4"

    python3 -c "
import json

cash = float('$1')
current_debt = float('$2')
long_term_debt = float('$3')
fcf = float('$4')

total_debt = current_debt + long_term_debt
net_debt = total_debt - cash
cash_to_current_debt = None if current_debt <= 0 else round(cash / current_debt, 2)
cash_to_total_debt = None if total_debt <= 0 else round(cash / total_debt, 2)
debt_to_fcf = None if fcf <= 0 else round(total_debt / fcf, 2)

flags = []
if current_debt > 0 and cash < current_debt:
    flags.append('cash_below_current_debt')
if fcf <= 0:
    flags.append('negative_or_zero_fcf')
if debt_to_fcf is not None and debt_to_fcf > 6:
    flags.append('high_debt_to_fcf')
if total_debt > 0 and cash_to_total_debt is not None and cash_to_total_debt < 0.25:
    flags.append('low_cash_coverage')

if len(flags) == 0:
    risk_level = 'low'
elif len(flags) <= 2:
    risk_level = 'moderate'
else:
    risk_level = 'high'

print(json.dumps({
    'cash': cash,
    'current_debt': current_debt,
    'long_term_debt': long_term_debt,
    'total_debt': total_debt,
    'fcf': fcf,
    'net_debt': round(net_debt, 2),
    'cash_to_current_debt': cash_to_current_debt,
    'cash_to_total_debt': cash_to_total_debt,
    'debt_to_fcf': debt_to_fcf,
    'risk_level': risk_level,
    'flags': flags
}, indent=2))
"
    ;;

rough-hurdle)
    [[ $# -eq 6 ]] || err "rough-hurdle requires 6 args: <current_price> <revenue_b> <fcf_margin_pct> <multiple> <shares_m> <years>"
    validate_number "current_price" "$1"
    validate_number "revenue_b" "$2"
    validate_number "fcf_margin_pct" "$3"
    validate_number "multiple" "$4"
    validate_number "shares_m" "$5"
    validate_number "years" "$6"

    python3 -c "
import json

current_price = float('$1')
revenue_b = float('$2')
fcf_margin_pct = float('$3')
multiple = float('$4')
shares_m = float('$5')
years = float('$6')

if current_price <= 0:
    raise ValueError('current_price must be positive')
if shares_m <= 0:
    raise ValueError('shares_m must be positive')
if years <= 0:
    raise ValueError('years must be positive')

fcf_b = revenue_b * (fcf_margin_pct / 100.0)
target_price = round((fcf_b * multiple * 1000.0) / shares_m, 2)
cagr_pct = round(((target_price / current_price) ** (1.0 / years) - 1.0) * 100.0, 2)

if cagr_pct >= 30:
    band = 'CLEAR_PASS'
elif cagr_pct >= 25:
    band = 'BORDERLINE_PASS'
else:
    band = 'FAIL'

print(json.dumps({
    'current_price': current_price,
    'revenue_b': revenue_b,
    'fcf_margin_pct': fcf_margin_pct,
    'multiple': multiple,
    'shares_m': shares_m,
    'years': years,
    'target_price': target_price,
    'implied_cagr_pct': cagr_pct,
    'screening_band': band
}, indent=2))
"
    ;;

forward-return)
    [[ $# -eq 6 ]] || err "forward-return requires 6 args: <current_price> <revenue_b> <fcf_margin_pct> <multiple> <shares_m> <years>"
    validate_number "current_price" "$1"
    validate_number "revenue_b" "$2"
    validate_number "fcf_margin_pct" "$3"
    validate_number "multiple" "$4"
    validate_number "shares_m" "$5"
    validate_number "years" "$6"

    python3 -c "
import json

current_price = float('$1')
revenue_b = float('$2')
fcf_margin_pct = float('$3')
multiple = float('$4')
shares_m = float('$5')
years = float('$6')

if current_price <= 0:
    raise ValueError('current_price must be positive')
if shares_m <= 0:
    raise ValueError('shares_m must be positive')
if years <= 0:
    raise ValueError('years must be positive')

fcf_b = revenue_b * (fcf_margin_pct / 100.0)
target_price = round((fcf_b * multiple * 1000.0) / shares_m, 2)
forward_cagr_pct = round(((target_price / current_price) ** (1.0 / years) - 1.0) * 100.0, 2)

hurdle_30 = forward_cagr_pct >= 30
rapid_move_guardrail = forward_cagr_pct >= 15
low_forward_return_warning = forward_cagr_pct < 10

print(json.dumps({
    'current_price': current_price,
    'revenue_b': revenue_b,
    'fcf_margin_pct': fcf_margin_pct,
    'multiple': multiple,
    'shares_m': shares_m,
    'years': years,
    'target_price': target_price,
    'forward_cagr_pct': forward_cagr_pct,
    'meets_30pct_hurdle': hurdle_30,
    'meets_15pct_guardrail': rapid_move_guardrail,
    'below_10pct_warning': low_forward_return_warning
}, indent=2))
"
    ;;

revenue-floor)
    [[ $# -eq 3 ]] || err "revenue-floor requires 3 args: <current_revenue_b> <min_5y_revenue_b> <revenue_cagr_5y_pct>"
    validate_number "current_revenue_b" "$1"
    validate_number "min_5y_revenue_b" "$2"
    validate_number "revenue_cagr_5y_pct" "$3"

    python3 -c "
import json

current_rev = float('$1')
min_rev_5y = float('$2')
rev_cagr_5y = float('$3')

if current_rev <= 0 or min_rev_5y <= 0:
    raise ValueError('revenue values must be positive')

bound_triggered = False
rule = 'default_min_5y'

# Growth-company bound:
# If 5y CAGR >= 15% and min_5y is < 70% of current scale, use 70% floor.
bounded_floor = round(current_rev * 0.70, 4)
selected = min_rev_5y

if rev_cagr_5y >= 15 and min_rev_5y < bounded_floor:
    selected = bounded_floor
    bound_triggered = True
    rule = 'growth_revenue_bound_70pct_current'

print(json.dumps({
    'current_revenue_b': current_rev,
    'min_5y_revenue_b': min_rev_5y,
    'revenue_cagr_5y_pct': rev_cagr_5y,
    'bounded_floor_70pct_current_b': bounded_floor,
    'selected_revenue_floor_b': round(selected, 4),
    'rule': rule,
    'triggered': bound_triggered
}, indent=2))
"
    ;;

margin-floor)
    [[ $# -eq 5 ]] || err "margin-floor requires 5 args: <m1> <m2> <m3> <m4> <m5>"
    for i in 1 2 3 4 5; do
        validate_number "m$i" "${!i}"
    done

    python3 -c "
import json

margins = [float('$1'), float('$2'), float('$3'), float('$4'), float('$5')]
sorted_m = sorted(margins)
lowest = sorted_m[0]
second_lowest = sorted_m[1]

outlier_triggered = False
rule = 'default_min_5y'
selected = lowest

# Working-capital outlier adjustment:
# If lowest is >=8pp below second-lowest, treat as anomaly and use second-lowest.
if (second_lowest - lowest) >= 8:
    selected = second_lowest
    outlier_triggered = True
    rule = 'margin_outlier_adjustment_second_lowest'

print(json.dumps({
    'margins_pct': margins,
    'lowest_margin_pct': lowest,
    'second_lowest_margin_pct': second_lowest,
    'selected_margin_floor_pct': selected,
    'rule': rule,
    'triggered': outlier_triggered
}, indent=2))
"
    ;;

floor)
    [[ $# -eq 5 ]] || err "floor requires 5 args: <revenue_b> <margin_pct> <multiple> <shares_m> <current_price>"
    validate_number "revenue_billions" "$1"
    validate_pct "fcf_margin_pct" "$2"
    validate_number "multiple" "$3"
    validate_number "shares_millions" "$4"
    validate_number "current_price" "$5"

    python3 -c "
import json

revenue_b = float('$1')
fcf_margin_pct = float('$2')
multiple = float('$3')
shares_m = float('$4')
current_price = float('$5')

if shares_m <= 0:
    raise ValueError('shares_millions must be positive')
if current_price <= 0:
    raise ValueError('current_price must be positive')

fcf_margin = fcf_margin_pct / 100
fcf_b = round(revenue_b * fcf_margin, 4)
floor_price = round((fcf_b * multiple * 1000) / shares_m, 2)
downside_pct = round(((current_price - floor_price) / current_price) * 100, 2)

print(json.dumps({
    'revenue_b': revenue_b,
    'fcf_margin_pct': fcf_margin_pct,
    'fcf_b': round(fcf_b, 4),
    'multiple': multiple,
    'shares_m': shares_m,
    'current_price': current_price,
    'floor_price': floor_price,
    'downside_pct': downside_pct
}, indent=2))
"
    ;;

help)
    usage
    ;;

*)
    err "Unknown command: $cmd. Run 'bash calc-score.sh help' for usage."
    ;;

esac
