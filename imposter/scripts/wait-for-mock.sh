#!/usr/bin/env bash
set -euo pipefail

# Wait for an Imposter mock server to become ready.
# Polls the /system/status endpoint until the server responds with HTTP 200
# or the timeout is reached.
#
# Usage:
#   ./wait-for-mock.sh [--host HOST] [--port PORT] [--timeout SECONDS] [--interval SECONDS]
#
# Outputs JSON to stdout:
#   {"status":"ready|timeout","url":"...","elapsed_seconds":5,"attempts":5}
#
# Progress messages are written to stderr.
#
# Exit codes:
#   0 - server is ready
#   1 - timeout reached

HOST="localhost"
PORT="8080"
TIMEOUT=30
INTERVAL=1

while [[ $# -gt 0 ]]; do
    case "$1" in
        --host) HOST="$2"; shift 2 ;;
        --port) PORT="$2"; shift 2 ;;
        --timeout) TIMEOUT="$2"; shift 2 ;;
        --interval) INTERVAL="$2"; shift 2 ;;
        --help)
            echo "Usage: $0 [--host HOST] [--port PORT] [--timeout SECONDS] [--interval SECONDS]"
            echo ""
            echo "Wait for an Imposter mock server to become ready."
            echo ""
            echo "Options:"
            echo "  --host HOST          Server hostname (default: localhost)"
            echo "  --port PORT          Server port (default: 8080)"
            echo "  --timeout SECONDS    Maximum time to wait (default: 30)"
            echo "  --interval SECONDS   Time between checks (default: 1)"
            echo "  --help               Show this help message"
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

ATTEMPTS=0
ELAPSED=0

echo "Waiting for Imposter at ${URL} (timeout: ${TIMEOUT}s)..." >&2

while [[ $ELAPSED -lt $TIMEOUT ]]; do
    ATTEMPTS=$((ATTEMPTS + 1))

    HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' --connect-timeout 3 --max-time 5 "$URL" 2>/dev/null) || HTTP_CODE="000"

    if [[ "$HTTP_CODE" == "200" ]]; then
        echo "Server is ready after ${ELAPSED}s (${ATTEMPTS} attempts)" >&2
        echo "{\"status\":\"ready\",\"url\":\"${URL}\",\"elapsed_seconds\":${ELAPSED},\"attempts\":${ATTEMPTS}}"
        exit 0
    fi

    echo "  Attempt ${ATTEMPTS}: server not ready (HTTP ${HTTP_CODE}), retrying in ${INTERVAL}s..." >&2
    sleep "$INTERVAL"
    ELAPSED=$((ELAPSED + INTERVAL))
done

echo "Timeout after ${TIMEOUT}s (${ATTEMPTS} attempts)" >&2
echo "{\"status\":\"timeout\",\"url\":\"${URL}\",\"elapsed_seconds\":${ELAPSED},\"attempts\":${ATTEMPTS}}"
exit 1
