#!/usr/bin/env bash
# SessionStart hook — welcome banner for EdenFinTech Scanner
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# --- Gather dynamic info ---
VERSION="0.9.4"

# API key status
FMP_STATUS="not set"
GEMINI_STATUS="not set"
if [[ -f "$PROJECT_ROOT/data/.env" ]]; then
    source "$PROJECT_ROOT/data/.env"
    [[ -n "${FMP_API_KEY:-}" ]] && FMP_STATUS="OK"
    [[ -n "${GEMINI_API_KEY:-}" ]] && GEMINI_STATUS="OK"
fi

# Portfolio count
HOLDINGS=0
if [[ -f "$PROJECT_ROOT/knowledge/current-portfolio.md" ]]; then
    HOLDINGS=$(grep -c '^|.*|.*|.*|.*|.*|.*|' "$PROJECT_ROOT/knowledge/current-portfolio.md" 2>/dev/null || echo 0)
    HOLDINGS=$((HOLDINGS > 1 ? HOLDINGS - 1 : 0))  # subtract header row
fi

# Last scan
LAST_SCAN="none"
if [[ -d "$PROJECT_ROOT/data/scans" ]]; then
    LATEST=$(ls -t "$PROJECT_ROOT/data/scans/"*-scan-report.md 2>/dev/null | head -1)
    if [[ -n "$LATEST" ]]; then
        LAST_SCAN=$(basename "$LATEST" | grep -oP '^\d{4}-\d{2}-\d{2}' || echo "unknown")
    fi
fi

# --- Build banner ---
# Using #85a9ff = RGB(133,169,255) via ANSI true color
BLUE='\033[38;2;133;169;255m'
DIM='\033[2m'
BOLD='\033[1m'
R='\033[0m'

escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

BANNER="${BLUE}${BOLD}
 ███████╗██████╗ ███████╗███╗   ██╗
 ██╔════╝██╔══██╗██╔════╝████╗  ██║
 █████╗  ██║  ██║█████╗  ██╔██╗ ██║
 ██╔══╝  ██║  ██║██╔══╝  ██║╚██╗██║
 ███████╗██████╔╝███████╗██║ ╚████║
 ╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═══╝${R}
${BLUE}  Deep Value Turnaround Scanner${R} ${DIM}v${VERSION}${R}

${DIM}────────────────────────────────────────${R}

  ${BOLD}/scan-stocks${R}          Full NYSE or sector scan
  ${BOLD}/sector-hydrate${R}       Build sector knowledge
  ${BOLD}/gemini-review${R}        Audit methodology

${DIM}────────────────────────────────────────${R}
  FMP: ${FMP_STATUS} ${DIM}|${R} Gemini: ${GEMINI_STATUS} ${DIM}|${R} Holdings: ${HOLDINGS} ${DIM}|${R} Last scan: ${LAST_SCAN}
"

ESCAPED=$(escape_for_json "$BANNER")

cat <<EOF
{
  "additional_context": "${ESCAPED}",
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "${ESCAPED}"
  }
}
EOF

exit 0
