#!/usr/bin/env bash
# FMP API helper for EdenFinTech Scanner (Stable API) — with transparent caching
# Usage: bash fmp-api.sh [--fresh] <command> [args...]

set -euo pipefail

# Load config — plugin root .env first, then persistent user config, then data dir .env (for API keys)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"

if [[ -f "$PLUGIN_ROOT/.env" ]]; then
    source "$PLUGIN_ROOT/.env"
fi
# Persistent user config — survives plugin cache refreshes
if [[ -z "${SCANNER_DATA_DIR:-}" && -f "$HOME/.config/edenfintech-scanner/.env" ]]; then
    source "$HOME/.config/edenfintech-scanner/.env"
fi
# Data dir .env — preferred location for API keys
DATA_DIR_ENV="${SCANNER_DATA_DIR:-$PLUGIN_ROOT/data}/.env"
if [[ -f "$DATA_DIR_ENV" ]]; then
    source "$DATA_DIR_ENV"
fi

if [[ -z "${FMP_API_KEY:-}" || "$FMP_API_KEY" == "your_api_key_here" ]]; then
    echo "ERROR: FMP_API_KEY not set."
    echo "Add your API keys to: ${SCANNER_DATA_DIR:-.}/.env (preferred) or $PLUGIN_ROOT/.env"
    echo "Get a key at: https://financialmodelingprep.com/developer/docs/"
    exit 1
fi

BASE="https://financialmodelingprep.com/stable"
MASSIVE_BASE="https://api.massive.com"

# --- Caching setup ---
DATA_DIR="${SCANNER_DATA_DIR:-$PLUGIN_ROOT/data}"
CACHE_DIR="$DATA_DIR/cache"

# Parse --fresh flag
FRESH=false
if [[ "${1:-}" == "--fresh" ]]; then
    FRESH=true
    shift
fi

cmd="${1:-help}"
shift || true

# TTL map (seconds)
declare -A TTL_MAP=(
    [screener]=604800      # 7 days
    [profile]=2592000      # 30 days
    [income]=7776000       # 90 days
    [balance]=7776000      # 90 days
    [cashflow]=7776000     # 90 days
    [ratios]=604800        # 7 days
    [metrics]=604800       # 7 days
    [price-history]=86400  # 1 day
    [ev]=604800            # 7 days
    [peers]=2592000        # 30 days
    [risk-factors]=7776000 # 90 days
)

# Core caching function
# Usage: cached_fetch <command> <cache_key> <url>
cached_fetch() {
    local cmd_name="$1"
    local cache_key="$2"
    local url="$3"
    local cache_file="$CACHE_DIR/$cmd_name/$cache_key.json"
    local ttl="${TTL_MAP[$cmd_name]:-604800}"

    # Check cache (unless --fresh)
    if [[ "$FRESH" == "false" && -f "$cache_file" ]]; then
        local file_age=$(( $(date +%s) - $(stat -c %Y "$cache_file") ))
        if (( file_age < ttl )); then
            cat "$cache_file"
            return 0
        fi
    fi

    # Live fetch
    mkdir -p "$(dirname "$cache_file")"
    local response
    response=$(curl -s "$url")

    # Skip caching empty/error responses
    if [[ -z "$response" || "$response" == "null" || "$response" == "{}" || "$response" == "[]" ]]; then
        echo "$response"
        return 0
    fi
    # Skip caching API error messages (JSON errors and premium/subscription text)
    if echo "$response" | grep -qiE '"Error Message"|Premium Query Parameter|not available under your current subscription'; then
        echo "$response"
        return 0
    fi

    echo "$response" | tee "$cache_file"
}

case "$cmd" in
    # Stock screener — filters by exchange, sector, market cap
    # Usage: fmp-api.sh screener [exchange] [sector]
    screener)
        exchange="${1:-NYSE}"
        sector="${2:-}"
        url="$BASE/company-screener?exchange=$exchange&isActivelyTrading=true&apikey=$FMP_API_KEY"
        cache_key="$exchange"
        if [[ -n "$sector" ]]; then
            url="$url&sector=$(echo "$sector" | sed 's/ /%20/g')"
            cache_key="${exchange}-$(echo "$sector" | sed 's/ /-/g; s/[^a-zA-Z0-9-]//g')"
        fi
        cached_fetch screener "$cache_key" "$url"
        ;;

    # Company profile (sector, industry, market cap, price, description)
    # Usage: fmp-api.sh profile TICKER
    profile)
        ticker="${1:?Usage: fmp-api.sh profile TICKER}"
        cached_fetch profile "$ticker" "$BASE/profile?symbol=$ticker&apikey=$FMP_API_KEY"
        ;;

    # Income statement (annual, last 10 years)
    # Usage: fmp-api.sh income TICKER
    income)
        ticker="${1:?Usage: fmp-api.sh income TICKER}"
        cached_fetch income "$ticker" "$BASE/income-statement?symbol=$ticker&period=annual&limit=10&apikey=$FMP_API_KEY"
        ;;

    # Balance sheet (annual, last 10 years)
    # Usage: fmp-api.sh balance TICKER
    balance)
        ticker="${1:?Usage: fmp-api.sh balance TICKER}"
        cached_fetch balance "$ticker" "$BASE/balance-sheet-statement?symbol=$ticker&period=annual&limit=10&apikey=$FMP_API_KEY"
        ;;

    # Cash flow statement (annual, last 10 years)
    # Usage: fmp-api.sh cashflow TICKER
    cashflow)
        ticker="${1:?Usage: fmp-api.sh cashflow TICKER}"
        cached_fetch cashflow "$ticker" "$BASE/cash-flow-statement?symbol=$ticker&period=annual&limit=10&apikey=$FMP_API_KEY"
        ;;

    # Financial ratios (annual, last 10 years)
    # Usage: fmp-api.sh ratios TICKER
    ratios)
        ticker="${1:?Usage: fmp-api.sh ratios TICKER}"
        cached_fetch ratios "$ticker" "$BASE/ratios?symbol=$ticker&period=annual&limit=10&apikey=$FMP_API_KEY"
        ;;

    # Key metrics (includes ROIC, P/E, debt ratios, etc.)
    # Usage: fmp-api.sh metrics TICKER
    metrics)
        ticker="${1:?Usage: fmp-api.sh metrics TICKER}"
        cached_fetch metrics "$ticker" "$BASE/key-metrics?symbol=$ticker&apikey=$FMP_API_KEY"
        ;;

    # Historical daily price (for ATH calculation)
    # Usage: fmp-api.sh price-history TICKER
    price-history)
        ticker="${1:?Usage: fmp-api.sh price-history TICKER}"
        cached_fetch price-history "$ticker" "$BASE/historical-price-eod/light?symbol=$ticker&apikey=$FMP_API_KEY"
        ;;

    # Enterprise value (annual)
    # Usage: fmp-api.sh ev TICKER
    ev)
        ticker="${1:?Usage: fmp-api.sh ev TICKER}"
        cached_fetch ev "$ticker" "$BASE/enterprise-values?symbol=$ticker&period=annual&limit=10&apikey=$FMP_API_KEY"
        ;;

    # Stock peers (same sector/industry)
    # Usage: fmp-api.sh peers TICKER
    peers)
        ticker="${1:?Usage: fmp-api.sh peers TICKER}"
        cached_fetch peers "$ticker" "$BASE/stock-peers?symbol=$ticker&apikey=$FMP_API_KEY"
        ;;

    # SBC data from cash flow (reuses cashflow cache, python3 formats output)
    # Usage: fmp-api.sh sbc TICKER
    sbc)
        ticker="${1:?Usage: fmp-api.sh sbc TICKER}"
        cached_fetch cashflow "$ticker" "$BASE/cash-flow-statement?symbol=$ticker&period=annual&limit=10&apikey=$FMP_API_KEY" | \
            python3 -c "
import sys, json
data = json.load(sys.stdin)
if isinstance(data, dict): data = data.get('data', data)
if isinstance(data, list):
    for row in data:
        print(f\"{row.get('date','?')}: SBC=\${row.get('stockBasedCompensation',0):,.0f}\")
"
        ;;

    # Shares outstanding history (not cached — uses python3 formatting)
    # Usage: fmp-api.sh shares TICKER
    shares)
        ticker="${1:?Usage: fmp-api.sh shares TICKER}"
        cached_fetch ev "$ticker" "$BASE/enterprise-values?symbol=$ticker&period=annual&limit=10&apikey=$FMP_API_KEY" | \
            python3 -c "
import sys, json
data = json.load(sys.stdin)
if isinstance(data, dict): data = data.get('data', data)
if isinstance(data, list):
    for row in data:
        print(f\"{row.get('date','?')}: shares={row.get('numberOfShares',0):,.0f}\")
"
        ;;

    # All screening data in one batch (profile + ratios + metrics)
    # Uses shared cache — subsequent individual calls are free
    # Usage: fmp-api.sh screen-data TICKER
    screen-data)
        ticker="${1:?Usage: fmp-api.sh screen-data TICKER}"
        echo "=== PROFILE ==="
        cached_fetch profile "$ticker" "$BASE/profile?symbol=$ticker&apikey=$FMP_API_KEY"
        echo ""
        echo "=== KEY METRICS ==="
        cached_fetch metrics "$ticker" "$BASE/key-metrics?symbol=$ticker&apikey=$FMP_API_KEY"
        echo ""
        echo "=== RATIOS ==="
        cached_fetch ratios "$ticker" "$BASE/ratios?symbol=$ticker&period=annual&limit=10&apikey=$FMP_API_KEY"
        ;;

    # SEC 10-K risk factors via Massive.com (supplementary)
    # Usage: fmp-api.sh risk-factors TICKER
    risk-factors)
        ticker="${1:?Usage: fmp-api.sh risk-factors TICKER}"
        if [[ -z "${MASSIVE_API_KEY:-}" ]]; then
            echo "SKIP: MASSIVE_API_KEY not set. Risk factors unavailable."
            exit 0
        fi
        cached_fetch risk-factors "$ticker" \
            "$MASSIVE_BASE/stocks/filings/vX/risk-factors?ticker=$ticker&limit=100&sort=filing_date.desc&apiKey=$MASSIVE_API_KEY"
        ;;

    # List all NYSE stocks (reuses screener cache)
    # Usage: fmp-api.sh list-nyse
    list-nyse)
        cached_fetch screener "NYSE" "$BASE/company-screener?exchange=NYSE&isActivelyTrading=true&limit=5000&apikey=$FMP_API_KEY"
        ;;

    # Show cache status — fresh/stale counts, total size
    # Usage: fmp-api.sh cache-status
    cache-status)
        if [[ ! -d "$CACHE_DIR" ]]; then
            echo "Cache directory not initialized yet: $CACHE_DIR"
            exit 0
        fi
        echo "Cache directory: $CACHE_DIR"
        echo ""
        total_files=0
        total_size=0
        now=$(date +%s)
        for cmd_dir in "$CACHE_DIR"/*/; do
            [[ -d "$cmd_dir" ]] || continue
            cmd_name=$(basename "$cmd_dir")
            ttl="${TTL_MAP[$cmd_name]:-604800}"
            fresh=0
            stale=0
            dir_size=0
            for f in "$cmd_dir"*.json; do
                [[ -f "$f" ]] || continue
                file_age=$(( now - $(stat -c %Y "$f") ))
                fsize=$(stat -c %s "$f")
                dir_size=$((dir_size + fsize))
                if (( file_age < ttl )); then
                    fresh=$((fresh + 1))
                else
                    stale=$((stale + 1))
                fi
            done
            count=$((fresh + stale))
            if (( count > 0 )); then
                total_files=$((total_files + count))
                total_size=$((total_size + dir_size))
                printf "  %-15s %3d files (%d fresh, %d stale)  %s\n" \
                    "$cmd_name" "$count" "$fresh" "$stale" "$(numfmt --to=iec "$dir_size" 2>/dev/null || echo "${dir_size}B")"
            fi
        done
        echo ""
        echo "Total: $total_files files, $(numfmt --to=iec "$total_size" 2>/dev/null || echo "${total_size}B")"
        ;;

    # Clear cache — all or specific command
    # Usage: fmp-api.sh cache-clear [command]
    cache-clear)
        target="${1:-}"
        if [[ -n "$target" ]]; then
            if [[ -d "$CACHE_DIR/$target" ]]; then
                rm -rf "$CACHE_DIR/$target"
                echo "Cleared cache for: $target"
            else
                echo "No cache found for: $target"
            fi
        else
            if [[ -d "$CACHE_DIR" ]]; then
                rm -rf "$CACHE_DIR"
                echo "Cleared all cache"
            else
                echo "No cache to clear"
            fi
        fi
        ;;

    # Echo data directory path (for agents to discover)
    # Usage: fmp-api.sh data-dir
    data-dir)
        echo "$DATA_DIR"
        ;;

    # Usage: fmp-api.sh knowledge-dir
    # Returns knowledge directory path, syncing new/updated files from plugin on each call
    knowledge-dir)
        KNOWLEDGE_DIR="$DATA_DIR/knowledge"
        (
            flock -x 200 2>/dev/null || true
            mkdir -p "$KNOWLEDGE_DIR"
            # -u = only copy if source is newer; preserves user edits to existing files
            cp -ru "$PLUGIN_ROOT/knowledge/"* "$KNOWLEDGE_DIR/" 2>/dev/null || true
        ) 200>"$DATA_DIR/.knowledge.lock" 2>/dev/null
        echo "$KNOWLEDGE_DIR"
        ;;

    help|*)
        echo "EdenFinTech FMP API Helper (Stable API) — with caching"
        echo ""
        echo "Usage: bash fmp-api.sh [--fresh] <command> [args...]"
        echo ""
        echo "Options:"
        echo "  --fresh                     Bypass cache, fetch live data"
        echo ""
        echo "Data Commands:"
        echo "  screener [exchange] [sector]  Stock screener (default: NYSE)"
        echo "  profile TICKER                Company profile"
        echo "  income TICKER                 Income statement (10yr)"
        echo "  balance TICKER                Balance sheet (10yr)"
        echo "  cashflow TICKER               Cash flow statement (10yr)"
        echo "  ratios TICKER                 Financial ratios (10yr)"
        echo "  metrics TICKER                Key metrics incl. ROIC (10yr)"
        echo "  price-history TICKER          Historical prices"
        echo "  ev TICKER                     Enterprise values (10yr)"
        echo "  peers TICKER                  Stock peers"
        echo "  sbc TICKER                    Stock-based compensation"
        echo "  shares TICKER                 Shares outstanding history"
        echo "  screen-data TICKER            All screening data (batch)"
        echo "  list-nyse                     List all NYSE stocks"
        echo ""
        echo "Massive.com Commands (supplementary — requires MASSIVE_API_KEY):"
        echo "  risk-factors TICKER           SEC 10-K risk factor disclosures"
        echo ""
        echo "Cache Commands:"
        echo "  cache-status                  Show cache stats (fresh/stale/size)"
        echo "  cache-clear [command]         Clear all cache or specific command"
        echo "  data-dir                      Show data directory path"
        echo "  knowledge-dir                 Show knowledge directory path (auto-bootstraps)"
        echo ""
        echo "Cache TTLs: screener/ratios/metrics/ev=7d, profile/peers=30d,"
        echo "            income/balance/cashflow/risk-factors=90d, price-history=1d"
        echo ""
        echo "Config: Set SCANNER_DATA_DIR in $PLUGIN_ROOT/.env or ~/.config/edenfintech-scanner/.env"
        echo "        Set FMP_API_KEY and MASSIVE_API_KEY in \$SCANNER_DATA_DIR/.env"
        ;;
esac
