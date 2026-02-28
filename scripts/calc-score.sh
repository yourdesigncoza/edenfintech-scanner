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
  score <downside_pct> <probability_pct> <cagr_pct>
      Calculate decision score using the adjusted downside penalty curve.

  cagr <current_price> <target_price> <years>
      Calculate CAGR and check against 30% hurdle rate.

  valuation <revenue_billions> <fcf_margin_pct> <multiple> <shares_millions>
      Calculate target price from revenue, FCF margin, multiple, and share count.

  size <score> <cagr_pct> <probability_pct> <downside_pct>
      Determine max position size with all hard breakpoints applied.

  help
      Show this help text.

Examples:
  bash calc-score.sh score 30 65 39
  bash calc-score.sh cagr 227 607 3
  bash calc-score.sh valuation 2.3 12.0 22 10.0
  bash calc-score.sh size 63.3 39 65 30
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

case "$cmd" in

score)
    [[ $# -eq 3 ]] || err "score requires 3 args: <downside_pct> <probability_pct> <cagr_pct>"
    validate_number "downside_pct" "$1"
    validate_number "probability_pct" "$2"
    validate_number "cagr_pct" "$3"

    python3 -c "
import json

downside = float('$1')
probability = float('$2')
cagr = float('$3')

adjusted_downside = round(downside * (1 + (downside / 100) * 0.5), 2)
risk_component = round((100 - adjusted_downside) * 0.45, 2)
probability_component = round(probability * 0.40, 2)
return_component = round(min(cagr, 100) * 0.15, 2)
total_score = round(risk_component + probability_component + return_component, 2)

print(json.dumps({
    'downside_pct': downside,
    'adjusted_downside': adjusted_downside,
    'risk_component': risk_component,
    'probability_component': probability_component,
    'return_component': return_component,
    'total_score': total_score
}, indent=2))
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
    [[ $# -eq 4 ]] || err "size requires 4 args: <score> <cagr_pct> <probability_pct> <downside_pct>"
    validate_number "score" "$1"
    validate_number "cagr_pct" "$2"
    validate_number "probability_pct" "$3"
    validate_number "downside_pct" "$4"

    python3 -c "
import json

score = float('$1')
cagr = float('$2')
probability = float('$3')
downside = float('$4')

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

# Determine final size — lower of score-based and hard-breakpoint limits
if hard_cap == '0%' or score_based_max == '0%':
    final_max_size = '0%'
    investable = False
elif hard_cap is not None:
    # Parse the lower bound of score_based_max to compare
    score_lower = int(score_based_max.split('-')[0].replace('%', ''))
    hard_val = int(hard_cap.replace('%', ''))
    if hard_val <= score_lower:
        final_max_size = hard_cap
    else:
        final_max_size = score_based_max
    investable = True
else:
    final_max_size = score_based_max
    investable = score_based_max != '0%'

print(json.dumps({
    'score': score,
    'score_band': score_band,
    'score_based_max': score_based_max,
    'hard_breakpoint_cap': hard_cap,
    'hard_breakpoint_reason': hard_reason,
    'final_max_size': final_max_size,
    'investable': investable
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
