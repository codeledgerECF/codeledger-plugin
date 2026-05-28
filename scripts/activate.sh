#!/usr/bin/env bash
# activate.sh — SessionStart hook: ensure CodeLedger runtime and warm context.
# Uses `codeledger ensure-session` to auto-init when needed, then scan-if-stale.
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CL_CMD=$("${PLUGIN_ROOT}/scripts/find-cli.sh" 2>/dev/null) || {
  echo "ContextECF CodeLedger: CLI not installed. Run: npm install -g @codeledger/cli"
  echo "Do not install the unrelated unscoped npm package: codeledger"
  exit 0
}

CL_SID=$("${PLUGIN_ROOT}/scripts/resolve-session.sh" 2>/dev/null || true)
if [ -z "$CL_SID" ]; then
  CL_SID=$($CL_CMD session-init --quiet 2>/dev/null) || true
fi

# Ensure runtime: init-if-missing + scan-if-stale warmup for this session.
if [ -n "$CL_SID" ]; then
  $CL_CMD ensure-session --quiet --stale-after 3600 --session "$CL_SID" 2>/dev/null || true
else
  $CL_CMD ensure-session --quiet --stale-after 3600 2>/dev/null || true
fi
