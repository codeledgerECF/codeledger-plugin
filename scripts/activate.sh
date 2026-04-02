#!/usr/bin/env bash
# activate.sh — SessionStart hook: initialize CodeLedger and warm the repo index.
# Runs `codeledger init` if not initialized, then `codeledger activate --quiet`.
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CL_CMD=$("${PLUGIN_ROOT}/scripts/find-cli.sh" 2>/dev/null) || {
  echo "CodeLedger: CLI not installed. Run: npm install -g @codeledger/cli"
  exit 0
}

# Auto-initialize if no config exists
if [ ! -f ".codeledger/config.json" ]; then
  $CL_CMD init --quiet 2>/dev/null || true
fi

CL_SID=$("${PLUGIN_ROOT}/scripts/resolve-session.sh" 2>/dev/null || true)
if [ -z "$CL_SID" ]; then
  CL_SID=$($CL_CMD session-init --quiet 2>/dev/null) || true
fi

# Activate: scan if stale (>1hr), write the active bundle for this session when available.
if [ -n "$CL_SID" ]; then
  $CL_CMD activate --quiet --stale-after 3600 --session "$CL_SID" 2>/dev/null || true
else
  $CL_CMD activate --quiet --stale-after 3600 2>/dev/null || true
fi
