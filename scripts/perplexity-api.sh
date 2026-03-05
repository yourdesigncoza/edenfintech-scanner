#!/usr/bin/env bash
# Perplexity API wrapper for EdenFinTech Scanner sub-agents
# MCP tools don't propagate to sub-agents, so this provides Perplexity access via Bash.
#
# Usage: bash perplexity-api.sh ask "your question here"
#        bash perplexity-api.sh search "your search query"
#        bash perplexity-api.sh ask --recency week "recent news about X"

set -euo pipefail

# Load config — same chain as fmp-api.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"

if [[ -f "$PLUGIN_ROOT/.env" ]]; then
    source "$PLUGIN_ROOT/.env"
fi
if [[ -z "${SCANNER_DATA_DIR:-}" && -f "$HOME/.config/edenfintech-scanner/.env" ]]; then
    source "$HOME/.config/edenfintech-scanner/.env"
fi
DATA_DIR_ENV="${SCANNER_DATA_DIR:-$PLUGIN_ROOT/data}/.env"
if [[ -f "$DATA_DIR_ENV" ]]; then
    source "$DATA_DIR_ENV"
fi

# Fallback: read from user-level Claude config (where MCP server has it)
if [[ -z "${PERPLEXITY_API_KEY:-}" ]]; then
    if command -v python3 &>/dev/null && [[ -f "$HOME/.claude.json" ]]; then
        PERPLEXITY_API_KEY=$(python3 -c "
import json
with open('$HOME/.claude.json') as f:
    d = json.load(f)
srv = d.get('mcpServers', {}).get('perplexity', {})
print(srv.get('env', {}).get('PERPLEXITY_API_KEY', ''))
" 2>/dev/null || true)
    fi
fi

if [[ -z "${PERPLEXITY_API_KEY:-}" ]]; then
    echo "ERROR: PERPLEXITY_API_KEY not set."
    echo "Add to: ${SCANNER_DATA_DIR:-.}/.env or configure via 'claude mcp add perplexity'"
    exit 1
fi

API_URL="https://api.perplexity.ai/chat/completions"

# --- Caching ---
DATA_DIR="${SCANNER_DATA_DIR:-$PLUGIN_ROOT/data}"
CACHE_DIR="$DATA_DIR/cache/perplexity"
CACHE_TTL_DAYS=1
mkdir -p "$CACHE_DIR"

FRESH=false
if [[ "${1:-}" == "--fresh" ]]; then
    FRESH=true
    shift
fi

COMMAND="${1:-help}"
shift || true

# --- Functions ---

cache_key() {
    echo "$*" | md5sum | cut -d' ' -f1
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

call_perplexity() {
    local model="$1"
    local query="$2"
    local recency="${3:-}"
    local system_msg="${4:-Be precise and concise. Include source URLs inline with claims.}"

    local response
    response=$(PPLX_MODEL="$model" PPLX_QUERY="$query" PPLX_RECENCY="$recency" PPLX_SYSTEM="$system_msg" \
        python3 -c "
import json, os, urllib.request, urllib.error

payload = {
    'model': os.environ['PPLX_MODEL'],
    'messages': [
        {'role': 'system', 'content': os.environ['PPLX_SYSTEM']},
        {'role': 'user', 'content': os.environ['PPLX_QUERY']}
    ]
}
recency = os.environ.get('PPLX_RECENCY', '')
if recency:
    payload['search_recency_filter'] = recency

data = json.dumps(payload).encode()
req = urllib.request.Request(
    '${API_URL}',
    data=data,
    headers={
        'Authorization': 'Bearer ${PERPLEXITY_API_KEY}',
        'Content-Type': 'application/json'
    }
)
try:
    with urllib.request.urlopen(req, timeout=60) as resp:
        d = json.loads(resp.read())
except urllib.error.HTTPError as e:
    body = e.read().decode()
    try:
        err = json.loads(body)
        msg = err.get('error', {}).get('message', body)
    except:
        msg = body
    print(f'ERROR: Perplexity API ({e.code}): {msg}', flush=True)
    raise SystemExit(1)

content = d['choices'][0]['message']['content']
print(content)
citations = d.get('citations', [])
if citations:
    print()
    print('## Sources')
    for i, url in enumerate(citations, 1):
        print(f'[{i}] {url}')
" 2>&1)

    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        echo "$response" >&2
        return 1
    fi

    echo "$response"
}

# --- Commands ---

case "$COMMAND" in
    ask)
        recency=""
        if [[ "${1:-}" == "--recency" ]]; then
            recency="$2"
            shift 2
        fi
        query="$*"
        if [[ -z "$query" ]]; then
            echo "Usage: perplexity-api.sh ask [--recency hour|day|week|month|year] \"question\""
            exit 1
        fi
        key=$(cache_key "ask:$recency:$query")
        if ! check_cache "$key"; then
            result=$(call_perplexity "sonar-pro" "$query" "$recency")
            save_cache "$key" "$result"
            echo "$result"
        fi
        ;;

    search)
        recency=""
        if [[ "${1:-}" == "--recency" ]]; then
            recency="$2"
            shift 2
        fi
        query="$*"
        if [[ -z "$query" ]]; then
            echo "Usage: perplexity-api.sh search [--recency hour|day|week|month|year] \"query\""
            exit 1
        fi
        key=$(cache_key "search:$recency:$query")
        if ! check_cache "$key"; then
            result=$(call_perplexity "sonar" "$query" "$recency" "Return factual search results with URLs. Be concise.")
            save_cache "$key" "$result"
            echo "$result"
        fi
        ;;

    reason)
        query="$*"
        if [[ -z "$query" ]]; then
            echo "Usage: perplexity-api.sh reason \"complex question requiring analysis\""
            exit 1
        fi
        key=$(cache_key "reason:$query")
        if ! check_cache "$key"; then
            result=$(call_perplexity "sonar-reasoning-pro" "$query" "")
            save_cache "$key" "$result"
            echo "$result"
        fi
        ;;

    help)
        echo "Perplexity API wrapper for EdenFinTech Scanner"
        echo ""
        echo "Usage: bash perplexity-api.sh [--fresh] <command> [args...]"
        echo ""
        echo "Commands:"
        echo "  ask [--recency R] \"question\"   AI answer with citations (sonar-pro)"
        echo "  search [--recency R] \"query\"    Web search results (sonar)"
        echo "  reason \"question\"               Deep reasoning (sonar-reasoning-pro)"
        echo "  help                            Show this help"
        echo ""
        echo "Recency filters: hour, day, week, month, year"
        echo ""
        echo "Examples:"
        echo "  bash perplexity-api.sh ask \"What is Kraft Heinz's current debt-to-equity ratio?\""
        echo "  bash perplexity-api.sh ask --recency month \"recent FDA enforcement actions food companies\""
        echo "  bash perplexity-api.sh search \"CAMELS rating regional banks 2025\""
        ;;

    *)
        echo "Unknown command: $COMMAND"
        echo "Run 'bash perplexity-api.sh help' for usage."
        exit 1
        ;;
esac
