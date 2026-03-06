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
