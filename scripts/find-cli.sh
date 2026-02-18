#!/usr/bin/env bash
# find-cli.sh — Locate the codeledger CLI binary.
# Outputs the command to use, or exits 1 if not found.
set -euo pipefail

if command -v codeledger >/dev/null 2>&1; then
  echo "codeledger"
elif [ -x "node_modules/.bin/codeledger" ]; then
  echo "node_modules/.bin/codeledger"
elif command -v npx >/dev/null 2>&1 && npx codeledger --version >/dev/null 2>&1; then
  echo "npx codeledger"
else
  exit 1
fi
