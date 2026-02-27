#!/usr/bin/env bash
# FMP API helper for EdenFinTech Scanner
# Usage: bash fmp-api.sh <command> [args...]

set -euo pipefail

# Load API key
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"

if [[ -f "$PLUGIN_ROOT/.env" ]]; then
    source "$PLUGIN_ROOT/.env"
fi

if [[ -z "${FMP_API_KEY:-}" || "$FMP_API_KEY" == "your_api_key_here" ]]; then
    echo "ERROR: FMP_API_KEY not set. Edit $PLUGIN_ROOT/.env with your API key."
    echo "Get a key at: https://financialmodelingprep.com/developer/docs/"
    exit 1
fi

BASE_URL="https://financialmodelingprep.com/api/v3"

cmd="${1:-help}"
shift || true

case "$cmd" in
    # Get stock screener results — filters by exchange, price drop, market cap
    # Usage: fmp-api.sh screener [exchange] [sector]
    screener)
        exchange="${1:-NYSE}"
        sector="${2:-}"
        url="$BASE_URL/stock-screener?exchange=$exchange&isActivelyTrading=true&apikey=$FMP_API_KEY"
        if [[ -n "$sector" ]]; then
            url="$url&sector=$(echo "$sector" | sed 's/ /%20/g')"
        fi
        curl -s "$url"
        ;;

    # Get company profile (sector, industry, market cap, price, description)
    # Usage: fmp-api.sh profile TICKER
    profile)
        ticker="${1:?Usage: fmp-api.sh profile TICKER}"
        curl -s "$BASE_URL/profile/$ticker?apikey=$FMP_API_KEY"
        ;;

    # Get income statement (annual, last 10 years)
    # Usage: fmp-api.sh income TICKER
    income)
        ticker="${1:?Usage: fmp-api.sh income TICKER}"
        curl -s "$BASE_URL/income-statement/$ticker?period=annual&limit=10&apikey=$FMP_API_KEY"
        ;;

    # Get balance sheet (annual, last 10 years)
    # Usage: fmp-api.sh balance TICKER
    balance)
        ticker="${1:?Usage: fmp-api.sh balance TICKER}"
        curl -s "$BASE_URL/balance-sheet-statement/$ticker?period=annual&limit=10&apikey=$FMP_API_KEY"
        ;;

    # Get cash flow statement (annual, last 10 years)
    # Usage: fmp-api.sh cashflow TICKER
    cashflow)
        ticker="${1:?Usage: fmp-api.sh cashflow TICKER}"
        curl -s "$BASE_URL/cash-flow-statement/$ticker?period=annual&limit=10&apikey=$FMP_API_KEY"
        ;;

    # Get key financial ratios (annual, last 10 years)
    # Usage: fmp-api.sh ratios TICKER
    ratios)
        ticker="${1:?Usage: fmp-api.sh ratios TICKER}"
        curl -s "$BASE_URL/ratios/$ticker?period=annual&limit=10&apikey=$FMP_API_KEY"
        ;;

    # Get key metrics (includes ROIC, FCF per share, etc.)
    # Usage: fmp-api.sh metrics TICKER
    metrics)
        ticker="${1:?Usage: fmp-api.sh metrics TICKER}"
        curl -s "$BASE_URL/key-metrics/$ticker?period=annual&limit=10&apikey=$FMP_API_KEY"
        ;;

    # Get historical daily price (last 5 years for ATH calculation)
    # Usage: fmp-api.sh price-history TICKER
    price-history)
        ticker="${1:?Usage: fmp-api.sh price-history TICKER}"
        curl -s "$BASE_URL/historical-price-full/$ticker?serietype=line&apikey=$FMP_API_KEY"
        ;;

    # Get enterprise value (annual)
    # Usage: fmp-api.sh ev TICKER
    ev)
        ticker="${1:?Usage: fmp-api.sh ev TICKER}"
        curl -s "$BASE_URL/enterprise-values/$ticker?period=annual&limit=10&apikey=$FMP_API_KEY"
        ;;

    # Get stock peers (same sector/industry)
    # Usage: fmp-api.sh peers TICKER
    peers)
        ticker="${1:?Usage: fmp-api.sh peers TICKER}"
        curl -s "$BASE_URL/stock_peers?symbol=$ticker&apikey=$FMP_API_KEY"
        ;;

    # Get SBC data from cash flow (stockBasedCompensation field)
    # Usage: fmp-api.sh sbc TICKER
    sbc)
        ticker="${1:?Usage: fmp-api.sh sbc TICKER}"
        curl -s "$BASE_URL/cash-flow-statement/$ticker?period=annual&limit=5&apikey=$FMP_API_KEY" | \
            python3 -c "
import sys, json
data = json.load(sys.stdin)
for row in data:
    rev_url = '$BASE_URL/income-statement/$ticker?period=annual&limit=5&apikey=$FMP_API_KEY'
    print(f\"{row.get('date','?')}: SBC=\${row.get('stockBasedCompensation',0):,.0f}\")
"
        ;;

    # Get shares outstanding history
    # Usage: fmp-api.sh shares TICKER
    shares)
        ticker="${1:?Usage: fmp-api.sh shares TICKER}"
        curl -s "$BASE_URL/enterprise-values/$ticker?period=annual&limit=10&apikey=$FMP_API_KEY" | \
            python3 -c "
import sys, json
data = json.load(sys.stdin)
for row in data:
    print(f\"{row.get('date','?')}: shares={row.get('numberOfShares',0):,.0f}\")
"
        ;;

    # Get all data needed for screening in one batch (profile + ratios + metrics)
    # Usage: fmp-api.sh screen-data TICKER
    screen-data)
        ticker="${1:?Usage: fmp-api.sh screen-data TICKER}"
        echo "=== PROFILE ==="
        curl -s "$BASE_URL/profile/$ticker?apikey=$FMP_API_KEY"
        echo ""
        echo "=== KEY METRICS ==="
        curl -s "$BASE_URL/key-metrics/$ticker?period=annual&limit=10&apikey=$FMP_API_KEY"
        echo ""
        echo "=== RATIOS ==="
        curl -s "$BASE_URL/ratios/$ticker?period=annual&limit=10&apikey=$FMP_API_KEY"
        ;;

    # List all NYSE stocks (for full scan)
    # Usage: fmp-api.sh list-nyse
    list-nyse)
        curl -s "$BASE_URL/stock/list?apikey=$FMP_API_KEY" | \
            python3 -c "
import sys, json
data = json.load(sys.stdin)
nyse = [s for s in data if s.get('exchangeShortName') == 'NYSE' and s.get('type') == 'stock']
print(json.dumps(nyse))
"
        ;;

    help|*)
        echo "EdenFinTech FMP API Helper"
        echo ""
        echo "Usage: bash fmp-api.sh <command> [args...]"
        echo ""
        echo "Commands:"
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
        echo "Config: Set FMP_API_KEY in $PLUGIN_ROOT/.env"
        ;;
esac
