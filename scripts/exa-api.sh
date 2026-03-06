#!/usr/bin/env bash
# Exa.ai API wrapper for EdenFinTech Scanner sub-agents
# Uses official exa_py SDK. Evaluating as alternative to Perplexity.
#
# Usage: bash exa-api.sh ask "your question here"
#        bash exa-api.sh search "your search query"
#        bash exa-api.sh search --type deep "complex multi-hop query"
#        bash exa-api.sh deep "question needing deep reasoning"

set -euo pipefail

# Load config — same chain as fmp-api.sh / perplexity-api.sh
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

# --- Parse global flags and command before API key check ---
FRESH=false
if [[ "${1:-}" == "--fresh" ]]; then
    FRESH=true
    shift
fi

COMMAND="${1:-help}"
shift || true

# Help doesn't need an API key
if [[ "$COMMAND" == "help" ]]; then
    :
elif [[ -z "${EXA_API_KEY:-}" ]]; then
    echo "ERROR: EXA_API_KEY not set."
    echo "Add to: ${SCANNER_DATA_DIR:-.}/.env"
    echo "Get your key at: https://dashboard.exa.ai/api-keys"
    exit 1
fi

# --- Caching ---
DATA_DIR="${SCANNER_DATA_DIR:-$PLUGIN_ROOT/data}"
CACHE_DIR="$DATA_DIR/cache/exa"
CACHE_TTL_DAYS=1
mkdir -p "$CACHE_DIR"

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

call_exa_search() {
    local query="$1"
    local search_type="${2:-auto}"
    local num_results="${3:-10}"

    local response
    response=$(EXA_KEY="$EXA_API_KEY" EXA_QUERY="$query" EXA_TYPE="$search_type" EXA_NUM="$num_results" \
        python3 -c "
import os, sys
from exa_py import Exa

exa = Exa(os.environ['EXA_KEY'])
try:
    result = exa.search(
        os.environ['EXA_QUERY'],
        type=os.environ['EXA_TYPE'],
        num_results=int(os.environ['EXA_NUM']),
    )
except Exception as e:
    print(f'ERROR: Exa API: {e}', flush=True)
    sys.exit(1)

for i, r in enumerate(result.results, 1):
    title = r.title or 'No title'
    url = r.url or ''
    score = getattr(r, 'score', 0) or 0
    date = (r.published_date or '')[:10]
    print(f'### [{i}] {title}')
    print(f'URL: {url}')
    if date:
        print(f'Date: {date}')
    print(f'Score: {score:.3f}')
    print()
    highlights = getattr(r, 'highlights', None) or []
    if highlights:
        for h in highlights[:3]:
            print(f'> {h}')
            print()
    elif getattr(r, 'text', None):
        text = r.text[:2000]
        print(text)
        if len(r.text) > 2000:
            print('...[truncated]')
        print()
" 2>&1)

    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        echo "$response" >&2
        return 1
    fi

    echo "$response"
}

call_exa_answer() {
    local query="$1"

    local response
    response=$(EXA_KEY="$EXA_API_KEY" EXA_QUERY="$query" \
        python3 -c "
import os, sys
from exa_py import Exa

exa = Exa(os.environ['EXA_KEY'])
try:
    result = exa.answer(os.environ['EXA_QUERY'], text=True)
except Exception as e:
    print(f'ERROR: Exa API: {e}', flush=True)
    sys.exit(1)

print(result.answer)

if hasattr(result, 'citations') and result.citations:
    print()
    print('## Sources')
    for i, c in enumerate(result.citations, 1):
        if hasattr(c, 'url'):
            title = getattr(c, 'title', '') or ''
            url = c.url or ''
            if title:
                print(f'[{i}] {title} -- {url}')
            else:
                print(f'[{i}] {url}')
        else:
            print(f'[{i}] {c}')
" 2>&1)

    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        echo "$response" >&2
        return 1
    fi

    echo "$response"
}

call_exa_contents() {
    local urls_json="$1"

    local response
    response=$(EXA_KEY="$EXA_API_KEY" EXA_URLS="$urls_json" \
        python3 -c "
import json, os, sys
from exa_py import Exa

exa = Exa(os.environ['EXA_KEY'])
urls = json.loads(os.environ['EXA_URLS'])
try:
    result = exa.get_contents(urls, text=True)
except Exception as e:
    print(f'ERROR: Exa API: {e}', flush=True)
    sys.exit(1)

for i, r in enumerate(result.results, 1):
    title = r.title or 'No title'
    url = r.url or ''
    print(f'### [{i}] {title}')
    print(f'URL: {url}')
    print()
    text = (r.text or '')[:5000]
    print(text)
    if len(r.text or '') > 5000:
        print('...[truncated]')
    print()
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
        query="$*"
        if [[ -z "$query" ]]; then
            echo "Usage: exa-api.sh ask \"question\""
            exit 1
        fi
        key=$(cache_key "ask:$query")
        if ! check_cache "$key"; then
            result=$(call_exa_answer "$query")
            save_cache "$key" "$result"
            echo "$result"
        fi
        ;;

    search)
        search_type="auto"
        num_results=10
        while [[ "${1:-}" == --* ]]; do
            case "$1" in
                --type)
                    search_type="$2"
                    shift 2
                    ;;
                --num)
                    num_results="$2"
                    shift 2
                    ;;
                *)
                    echo "Unknown option: $1"
                    exit 1
                    ;;
            esac
        done
        query="$*"
        if [[ -z "$query" ]]; then
            echo "Usage: exa-api.sh search [--type auto|neural|deep|deep-reasoning] [--num N] \"query\""
            exit 1
        fi
        key=$(cache_key "search:$search_type:$num_results:$query")
        if ! check_cache "$key"; then
            result=$(call_exa_search "$query" "$search_type" "$num_results")
            save_cache "$key" "$result"
            echo "$result"
        fi
        ;;

    deep)
        query="$*"
        if [[ -z "$query" ]]; then
            echo "Usage: exa-api.sh deep \"complex question requiring deep reasoning\""
            exit 1
        fi
        key=$(cache_key "deep:$query")
        if ! check_cache "$key"; then
            result=$(call_exa_search "$query" "deep-reasoning" "10")
            save_cache "$key" "$result"
            echo "$result"
        fi
        ;;

    contents)
        urls_json="${1:-}"
        if [[ -z "$urls_json" ]]; then
            echo "Usage: exa-api.sh contents '[\"url1\", \"url2\"]'"
            exit 1
        fi
        key=$(cache_key "contents:$urls_json")
        if ! check_cache "$key"; then
            result=$(call_exa_contents "$urls_json")
            save_cache "$key" "$result"
            echo "$result"
        fi
        ;;

    help)
        echo "Exa.ai API wrapper for EdenFinTech Scanner"
        echo ""
        echo "Usage: bash exa-api.sh [--fresh] <command> [args...]"
        echo ""
        echo "Commands:"
        echo "  ask \"question\"                              AI answer with citations (/answer)"
        echo "  search [--type T] [--num N] \"query\"         Web search with highlights (/search)"
        echo "  deep \"question\"                             Deep reasoning search (deep-reasoning type)"
        echo "  contents '[\"url1\",\"url2\"]'                 Extract content from URLs (/contents)"
        echo "  help                                        Show this help"
        echo ""
        echo "Search types: auto (default), neural, fast, instant, deep, deep-reasoning"
        echo ""
        echo "Examples:"
        echo "  bash exa-api.sh ask \"What is Boston Beer's Twisted Tea market share trend?\""
        echo "  bash exa-api.sh search --type deep \"BRBR Premier Protein competitive position 2026\""
        echo "  bash exa-api.sh deep \"Consumer defensive turnaround precedents last 5 years\""
        echo "  bash exa-api.sh contents '[\"https://sec.gov/filing/123\"]'"
        echo ""
        echo "Environment: EXA_API_KEY required in \$SCANNER_DATA_DIR/.env"
        echo "Cache: \$SCANNER_DATA_DIR/cache/exa/ (1-day TTL, --fresh to bypass)"
        echo "Requires: pip3 install exa-py"
        ;;

    *)
        echo "Unknown command: $COMMAND"
        echo "Run 'bash exa-api.sh help' for usage."
        exit 1
        ;;
esac
