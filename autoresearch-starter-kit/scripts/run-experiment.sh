#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TRACK="${1:-}"

usage() {
  cat <<'USAGE'
Run one autoresearch experiment and append its metric to results.tsv.

Usage:
  ./scripts/run-experiment.sh response-curves [status] [description]
  ./scripts/run-experiment.sh demand-forecast [status] [description]

Status is usually pending, keep, discard, or crash.
USAGE
}

case "$TRACK" in
  response-curves|demand-forecast)
    ;;
  -h|--help|"")
    usage
    exit 0
    ;;
  *)
    echo "Unknown track: $TRACK" >&2
    usage >&2
    exit 2
    ;;
esac

shift || true
STATUS="${1:-pending}"
if [[ $# -gt 0 ]]; then
  shift
fi
DESCRIPTION="${*:-manual run}"

case "$STATUS" in
  pending|keep|discard|crash)
    ;;
  *)
    echo "Unknown status: $STATUS" >&2
    echo "Use pending, keep, discard, or crash." >&2
    exit 2
    ;;
esac

cd "$ROOT_DIR"

RESULTS="$TRACK/results.tsv"
LOG="$TRACK/run.log"
HEADER=$'commit\tportfolio_wmape\ttime_seconds\tstatus\tdescription'

if [[ ! -s "$RESULTS" ]]; then
  printf '%s\n' "$HEADER" > "$RESULTS"
fi

if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  COMMIT="$(git rev-parse --short HEAD)"
else
  COMMIT="nogit"
fi

if node "$TRACK/train.js" > "$LOG" 2>&1; then
  WMAPE="$(awk -F: '/^portfolio_wmape:/ { gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit }' "$LOG")"
  ELAPSED_SECONDS="$(awk -F: '/^time_seconds:/ { gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit }' "$LOG")"

  if [[ -z "$WMAPE" || -z "$ELAPSED_SECONDS" ]]; then
    printf '%s\t0.000000\t0.00\tcrash\t%s\n' "$COMMIT" "$DESCRIPTION" >> "$RESULTS"
    echo "Experiment finished but the metric could not be parsed." >&2
    tail -n 40 "$LOG" >&2
    exit 1
  fi

  printf '%s\t%s\t%s\t%s\t%s\n' "$COMMIT" "$WMAPE" "$ELAPSED_SECONDS" "$STATUS" "$DESCRIPTION" >> "$RESULTS"
  cat "$LOG"
  echo
  echo "Logged result in $RESULTS"
else
  printf '%s\t0.000000\t0.00\tcrash\t%s\n' "$COMMIT" "$DESCRIPTION" >> "$RESULTS"
  echo "Experiment crashed. Last log lines:" >&2
  tail -n 40 "$LOG" >&2 || true
  exit 1
fi
