#!/usr/bin/env bash
# find-cli.sh — Locate the codeledger CLI binary.
# Outputs the command to use, or exits 1 if not found.
set -euo pipefail

if command -v codeledger >/dev/null 2>&1; then
  echo "codeledger"
elif [ -x "node_modules/.bin/codeledger" ]; then
  echo "node_modules/.bin/codeledger"
else
  # Dev mode: check the monorepo sibling
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  MONO_CLI="${SCRIPT_DIR}/../../codeledger-blackbox/packages/cli/dist/index.js"
  if [ -f "$MONO_CLI" ]; then
    echo "node $MONO_CLI"
  elif command -v npx >/dev/null 2>&1 && npx codeledger --version >/dev/null 2>&1; then
    echo "npx codeledger"
  else
    exit 1
  fi
fi
