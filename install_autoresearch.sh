#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${AUTORESEARCH_BASE_URL:-https://ai-ecommerce-workshop.vercel.app}"
INSTALL_DIR="${AUTORESEARCH_HOME:-$HOME/autoresearch-starter-kit}"
FORCE=0
VERIFY=1
INIT_GIT=1

usage() {
  cat <<'USAGE'
Install the AI for Ecommerce Autoresearch starter kit.

Usage:
  curl -fsSL https://ai-ecommerce-workshop.vercel.app/install_autoresearch.sh | bash

Options:
  --dir PATH       Install to PATH instead of ~/autoresearch-starter-kit
  --base-url URL   Download assets from URL instead of the workshop site
  --force          Move any existing install to a timestamped backup first
  --no-git         Skip baseline Git repository setup
  --no-verify      Skip the Node smoke tests
  -h, --help       Show this help
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir)
      INSTALL_DIR="${2:?Missing path after --dir}"
      shift 2
      ;;
    --base-url)
      BASE_URL="${2:?Missing URL after --base-url}"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --no-git)
      INIT_GIT=0
      shift
      ;;
    --no-verify)
      VERIFY=0
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

need_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    return 1
  fi
}

need_command curl
need_command unzip
need_command node
if [[ "$INIT_GIT" -eq 1 ]]; then
  need_command git
fi

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

ZIP_URL="${BASE_URL%/}/autoresearch-starter-kit.zip"
ZIP_PATH="$TMP_DIR/autoresearch-starter-kit.zip"

echo "Installing Autoresearch starter kit..."
echo "Source: $ZIP_URL"
echo "Target: $INSTALL_DIR"

curl -fsSL "$ZIP_URL" -o "$ZIP_PATH"
unzip -q "$ZIP_PATH" -d "$TMP_DIR"

if [[ ! -d "$TMP_DIR/autoresearch-starter-kit" ]]; then
  echo "Downloaded archive did not contain autoresearch-starter-kit/" >&2
  exit 1
fi

if [[ -e "$INSTALL_DIR" ]]; then
  if [[ "$FORCE" -ne 1 ]]; then
    echo "Target already exists: $INSTALL_DIR" >&2
    echo "Rerun with --force to move it to a backup first, or use --dir PATH." >&2
    exit 1
  fi
  BACKUP_DIR="${INSTALL_DIR}.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Existing install found. Moving it to: $BACKUP_DIR"
  mv "$INSTALL_DIR" "$BACKUP_DIR"
fi

mkdir -p "$(dirname "$INSTALL_DIR")"
mv "$TMP_DIR/autoresearch-starter-kit" "$INSTALL_DIR"

if [[ "$INIT_GIT" -eq 1 ]]; then
  (
    cd "$INSTALL_DIR"
    git init -q
    if ! git config user.name >/dev/null 2>&1; then
      git config user.name "Workshop Attendee"
    fi
    if ! git config user.email >/dev/null 2>&1; then
      git config user.email "workshop@example.local"
    fi
    git add .
    git commit -qm "baseline autoresearch starter" || true
  )
fi

if [[ "$VERIFY" -eq 1 ]]; then
  (
    cd "$INSTALL_DIR"
    ./scripts/check.sh
  )
fi

if [[ "$INIT_GIT" -eq 1 ]]; then
  cat <<EOF

Autoresearch starter kit installed.

Next:
  cd "$INSTALL_DIR"
  # Pick one track:
  ./scripts/setup-run.sh response-curves
  # or:
  ./scripts/setup-run.sh demand-forecast

Then paste this into Claude Code or Codex:
  Read program.md and the selected track program.md. Continue the autoresearch loop.

EOF
else
  cat <<EOF

Autoresearch starter kit installed without Git setup.

Next:
  cd "$INSTALL_DIR"
  ./scripts/check.sh

Git is required for the full autoresearch keep/discard loop.

EOF
fi
