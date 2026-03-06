#!/usr/bin/env bash
# Gemini Grounded Search wrapper for EdenFinTech Scanner sub-agents
# Uses Google Search grounding via Gemini API. Free tier: 500 req/day (Flash), 1500/day (Pro).
#
# Usage: bash gemini-search.sh ask "your question here"
#        bash gemini-search.sh ask --model pro "complex question"

set -euo pipefail

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$PROJECT_ROOT/data"
if [[ -f "$DATA_DIR/.env" ]]; then source "$DATA_DIR/.env"; fi

# Fallback: read from Claude MCP config
if [[ -z "${GEMINI_API_KEY:-}" ]]; then
    if command -v python3 &>/dev/null && [[ -f "$HOME/.claude.json" ]]; then
        GEMINI_API_KEY=$(python3 -c "
import json
with open('$HOME/.claude.json') as f:
    d = json.load(f)
srv = d.get('mcpServers', {}).get('gemini', {})
for a in srv.get('args', []):
    if 'GEMINI_API_KEY' in str(a):
        print(str(a).split('=', 1)[1])
        break
" 2>/dev/null || true)
    fi
fi

# --- Parse global flags and command ---
FRESH=false
if [[ "${1:-}" == "--fresh" ]]; then
    FRESH=true
    shift
fi

COMMAND="${1:-help}"
shift || true

if [[ "$COMMAND" == "help" ]]; then
    :
elif [[ -z "${GEMINI_API_KEY:-}" ]]; then
    echo "ERROR: GEMINI_API_KEY not set."
    echo "Add to: data/.env"
    echo "Get your key at: https://aistudio.google.com/apikey"
    exit 1
fi

# --- Caching & Usage Tracking ---
CACHE_DIR="$DATA_DIR/cache/gemini-search"
USAGE_DIR="$DATA_DIR/cache/gemini-search/usage"
CACHE_TTL_DAYS=1
FREE_LIMIT_FLASH=500
FREE_LIMIT_PRO=1500
PAID_RATE_PER_1K=35  # $35 per 1000 grounded prompts
mkdir -p "$CACHE_DIR" "$USAGE_DIR"

# --- Functions ---

cache_key() {
    echo "$*" | md5sum | cut -d' ' -f1
}

# Track daily API usage per model
track_usage() {
    local model="$1"
    local today
    today=$(date +%Y-%m-%d)
    local usage_file="$USAGE_DIR/${today}.log"
    echo "$(date +%H:%M:%S) $model" >> "$usage_file"
}

get_daily_count() {
    local model_filter="${1:-}"
    local today
    today=$(date +%Y-%m-%d)
    local usage_file="$USAGE_DIR/${today}.log"
    if [[ ! -f "$usage_file" ]]; then
        echo 0
        return
    fi
    if [[ -n "$model_filter" ]]; then
        local c
        c=$(grep -c "$model_filter" "$usage_file" 2>/dev/null) || true
        echo "${c:-0}"
    else
        wc -l < "$usage_file" 2>/dev/null || echo 0
    fi
}

check_usage_warning() {
    local model="$1"
    local limit
    if [[ "$model" == *"pro"* ]]; then
        limit=$FREE_LIMIT_PRO
    else
        limit=$FREE_LIMIT_FLASH
    fi
    local count
    count=$(get_daily_count "$model")
    local remaining=$(( limit - count ))

    if (( count >= limit )); then
        local overage=$(( count - limit + 1 ))
        local cost
        cost=$(echo "scale=4; $overage * $PAID_RATE_PER_1K / 1000" | bc)
        echo "WARNING: Exceeded free tier ($count/$limit). Estimated paid cost today: \$$cost" >&2
    elif (( remaining <= 50 )); then
        echo "NOTICE: Approaching free tier limit ($count/$limit, $remaining remaining)" >&2
    fi
}

check_cache() {
    local key="$1"
    local cache_file="$CACHE_DIR/${key}.json"
    if [[ "$FRESH" == "true" ]]; then
        return 1
    fi
    if [[ -f "$cache_file" ]]; then
        local age_days
        age_days=$(( ($(date +%s) - $(stat -c %Y "$cache_file")) / 86400 ))
        if (( age_days < CACHE_TTL_DAYS )); then
            cat "$cache_file"
            return 0
        fi
    fi
    return 1
}

save_cache() {
    local key="$1"
    local data="$2"
    echo "$data" > "$CACHE_DIR/${key}.json"
}

call_gemini_grounded() {
    local query="$1"
    local model="${2:-gemini-2.5-flash}"

    # Check and warn about usage limits before making the call
    check_usage_warning "$model"

    local api_url="https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${GEMINI_API_KEY}"

    local tmpfile
    tmpfile=$(mktemp)

    GEMINI_QUERY="$query" python3 -c "
import json, os
print(json.dumps({
    'contents': [{'parts': [{'text': os.environ['GEMINI_QUERY']}]}],
    'tools': [{'google_search': {}}],
    'generationConfig': {
        'temperature': 0.2,
        'maxOutputTokens': 4096
    }
}))
" > "$tmpfile" 2>/dev/null

    local response
    response=$(curl -s -w "\n__HTTP_CODE__%{http_code}" \
        -X POST "$api_url" \
        -H "Content-Type: application/json" \
        -d @"$tmpfile" 2>&1)
    rm -f "$tmpfile"

    local http_code
    http_code=$(echo "$response" | grep "__HTTP_CODE__" | sed 's/__HTTP_CODE__//')
    local body
    body=$(echo "$response" | grep -v "__HTTP_CODE__")

    if [[ "$http_code" != "200" ]]; then
        local error_msg
        error_msg=$(echo "$body" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    print(d.get('error', {}).get('message', json.dumps(d)))
except:
    print(sys.stdin.read())
" 2>/dev/null || echo "$body")
        echo "ERROR: Gemini API ($http_code): $error_msg" >&2
        return 1
    fi

    local parsed
    parsed=$(GEMINI_MODEL="$model" python3 -c "
import json, sys, os

d = json.load(sys.stdin)
model = os.environ.get('GEMINI_MODEL', 'unknown')
candidates = d.get('candidates', [])
if not candidates:
    print('ERROR: No candidates in response')
    sys.exit(1)

candidate = candidates[0]
content = candidate.get('content', {})
parts = content.get('parts', [])

for part in parts:
    if 'text' in part:
        print(part['text'])

metadata = candidate.get('groundingMetadata', {})

queries = metadata.get('webSearchQueries', [])
if queries:
    print()
    print('## Search Queries Used')
    for q in queries:
        print(f'- {q}')

chunks = metadata.get('groundingChunks', [])
if chunks:
    print()
    print('## Sources')
    for i, chunk in enumerate(chunks, 1):
        web = chunk.get('web', {})
        title = web.get('title', 'No title')
        uri = web.get('uri', '')
        print(f'[{i}] {title} -- {uri}')

usage = d.get('usageMetadata', {})
if usage:
    prompt_tokens = usage.get('promptTokenCount', 0)
    output_tokens = usage.get('candidatesTokenCount', 0)
    total = usage.get('totalTokenCount', 0)
    print(f'\n(tokens: {prompt_tokens} in, {output_tokens} out, {total} total | model: {model})')
" <<< "$body" 2>&1)

    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        echo "ERROR: Failed to parse response" >&2
        echo "$body" >&2
        return 1
    fi

    # Track successful API call
    track_usage "$model"

    echo "$parsed"
}

# --- Commands ---

case "$COMMAND" in
    ask)
        model="gemini-2.5-flash"
        if [[ "${1:-}" == "--model" ]]; then
            case "$2" in
                pro) model="gemini-2.5-pro" ;;
                flash) model="gemini-2.5-flash" ;;
                flash2) model="gemini-2.0-flash" ;;
                *) model="$2" ;;
            esac
            shift 2
        fi
        query="$*"
        if [[ -z "$query" ]]; then
            echo "Usage: gemini-search.sh ask [--model flash|pro|flash2] \"question\""
            exit 1
        fi
        key=$(cache_key "ask:$model:$query")
        if ! check_cache "$key"; then
            result=$(call_gemini_grounded "$query" "$model")
            save_cache "$key" "$result"
            echo "$result"
        fi
        ;;

    usage)
        today=$(date +%Y-%m-%d)
        flash_count=$(get_daily_count "flash")
        pro_count=$(get_daily_count "pro")
        total_count=$(get_daily_count)
        echo "=== Gemini Grounded Search Usage ==="
        echo "Date: $today"
        echo ""
        echo "Today's API calls:"
        echo "  Flash models: $flash_count / $FREE_LIMIT_FLASH free"
        echo "  Pro models:   $pro_count / $FREE_LIMIT_PRO free"
        echo "  Total:        $total_count"
        echo ""
        # Check if any day exceeded free tier
        flash_over=$(( flash_count > FREE_LIMIT_FLASH ? flash_count - FREE_LIMIT_FLASH : 0 ))
        pro_over=$(( pro_count > FREE_LIMIT_PRO ? pro_count - FREE_LIMIT_PRO : 0 ))
        total_over=$(( flash_over + pro_over ))
        if (( total_over > 0 )); then
            cost=$(echo "scale=4; $total_over * $PAID_RATE_PER_1K / 1000" | bc)
            echo "PAID USAGE: $total_over queries over free tier = \$$cost estimated"
        else
            echo "Status: Within free tier"
        fi
        echo ""
        # Show weekly history
        echo "--- Last 7 days ---"
        for i in $(seq 0 6); do
            d=$(date -d "$today -${i} days" +%Y-%m-%d 2>/dev/null || date -v-${i}d +%Y-%m-%d 2>/dev/null)
            f="$USAGE_DIR/${d}.log"
            if [[ -f "$f" ]]; then
                count=$(wc -l < "$f")
                echo "  $d: $count queries"
            fi
        done
        ;;

    help)
        echo "Gemini Grounded Search wrapper for EdenFinTech Scanner"
        echo ""
        echo "Usage: bash gemini-search.sh [--fresh] <command> [args...]"
        echo ""
        echo "Commands:"
        echo "  ask [--model M] \"question\"   Grounded search answer with citations"
        echo "  usage                         Show daily/weekly API usage and cost tracking"
        echo "  help                          Show this help"
        echo ""
        echo "Models: flash (default, 500 free/day), pro (1500 free/day), flash2 (gemini-2.0-flash)"
        echo ""
        echo "Examples:"
        echo "  bash gemini-search.sh ask \"What is Boston Beer's Twisted Tea market share trend?\""
        echo "  bash gemini-search.sh ask --model pro \"EL Beauty Reimagined turnaround progress 2026\""
        echo ""
        echo "Environment: GEMINI_API_KEY required (auto-reads from ~/.claude.json MCP config)"
        echo "Cache: data/cache/gemini-search/ (1-day TTL, --fresh to bypass)"
        echo "Free tier: 500 req/day (Flash), 1500 req/day (Pro)"
        ;;

    *)
        echo "Unknown command: $COMMAND"
        echo "Run 'bash gemini-search.sh help' for usage."
        exit 1
        ;;
esac
