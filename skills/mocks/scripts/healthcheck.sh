#!/usr/bin/env bash
set -euo pipefail

# Imposter mock server health check script.
# Checks if the mock server is running and healthy.
#
# Usage:
#   ./healthcheck.sh [--host HOST] [--port PORT]
#
# Outputs JSON to stdout:
#   {"status":"healthy|unhealthy|unreachable","url":"...","http_code":200,"response_time_ms":42}
#
# Exit codes:
#   0 - healthy
#   1 - unhealthy or unreachable

HOST="localhost"
PORT="8080"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --host) HOST="$2"; shift 2 ;;
        --port) PORT="$2"; shift 2 ;;
        --help)
            echo "Usage: $0 [--host HOST] [--port PORT]"
            echo ""
            echo "Check if an Imposter mock server is running and healthy."
            echo ""
            echo "Options:"
            echo "  --host HOST  Server hostname (default: localhost)"
            echo "  --port PORT  Server port (default: 8080)"
            echo "  --help       Show this help message"
            exit 0
            ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
done

URL="http://${HOST}:${PORT}/system/status"

if ! command -v curl &>/dev/null; then
    echo '{"status":"error","message":"curl is required but not installed"}' >&2
    exit 1
fi

START_MS=$(date +%s%3N 2>/dev/null || python3 -c 'import time; print(int(time.time()*1000))')

HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' --connect-timeout 5 --max-time 10 "$URL" 2>/dev/null) || HTTP_CODE="000"

END_MS=$(date +%s%3N 2>/dev/null || python3 -c 'import time; print(int(time.time()*1000))')
ELAPSED_MS=$(( END_MS - START_MS ))

if [[ "$HTTP_CODE" == "000" ]]; then
    echo "{\"status\":\"unreachable\",\"url\":\"${URL}\",\"http_code\":0,\"response_time_ms\":${ELAPSED_MS}}"
    exit 1
elif [[ "$HTTP_CODE" == "200" ]]; then
    echo "{\"status\":\"healthy\",\"url\":\"${URL}\",\"http_code\":${HTTP_CODE},\"response_time_ms\":${ELAPSED_MS}}"
    exit 0
else
    echo "{\"status\":\"unhealthy\",\"url\":\"${URL}\",\"http_code\":${HTTP_CODE},\"response_time_ms\":${ELAPSED_MS}}"
    exit 1
fi
