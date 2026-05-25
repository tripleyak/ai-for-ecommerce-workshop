#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TRACK="${1:-}"
TAG="${2:-$(date +%Y%m%d-%H%M)}"

usage() {
  cat <<'USAGE'
Create a MacBook-local autoresearch run branch and record a baseline.

Usage:
  ./scripts/setup-run.sh response-curves [run-tag]
  ./scripts/setup-run.sh demand-forecast [run-tag]
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

cd "$ROOT_DIR"

if ! command -v git >/dev/null 2>&1; then
  echo "Missing required command: git" >&2
  exit 1
fi

CURRENT_GIT_ROOT=""
if git rev-parse --show-toplevel >/dev/null 2>&1; then
  CURRENT_GIT_ROOT="$(git rev-parse --show-toplevel)"
fi

if [[ "$CURRENT_GIT_ROOT" != "$ROOT_DIR" ]]; then
  git init -q
fi

if ! git config user.name >/dev/null 2>&1; then
  git config user.name "Workshop Attendee"
fi

if ! git config user.email >/dev/null 2>&1; then
  git config user.email "workshop@example.local"
fi

if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  git add .
  git commit -qm "baseline autoresearch starter"
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "The starter kit has uncommitted changes. Commit or discard them before starting a new run." >&2
  git status --short >&2
  exit 1
fi

BRANCH="autoresearch/${TRACK}-${TAG}"

if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "Run branch already exists: $BRANCH" >&2
  exit 1
fi

git checkout -b "$BRANCH" >/dev/null
printf 'commit\tportfolio_wmape\ttime_seconds\tstatus\tdescription\n' > "$TRACK/results.tsv"
git add "$TRACK/results.tsv"
git commit -qm "start $TRACK autoresearch run $TAG" || true

"$ROOT_DIR/scripts/run-experiment.sh" "$TRACK" keep "baseline"
git add "$TRACK/results.tsv"
git commit -qm "record $TRACK baseline" || true

cat <<EOF

Autoresearch run ready.

Branch: $BRANCH
Track:  $TRACK

Next:
  Read program.md and $TRACK/program.md.
  Edit only $TRACK/train.js.
  Commit the attempted change.
  Run ./scripts/run-experiment.sh $TRACK pending "short description"

EOF
