#!/usr/bin/env bash
# cowork-start.sh — Start a Cowork session with knowledge-scored context selection.
# Initializes CodeLedger if needed, then runs cowork-start with the given intent.
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CL_CMD=$("${PLUGIN_ROOT}/scripts/find-cli.sh" 2>/dev/null) || {
  echo "ContextECF CodeLedger: CLI not installed. Run: npm install -g @codeledger/cli"
  echo "Do not install the unrelated unscoped npm package: codeledger"
  exit 0
}

# Auto-initialize if no config exists
if [ ! -f ".codeledger/config.json" ]; then
  $CL_CMD init --quiet 2>/dev/null || true
fi

$CL_CMD cowork-start "$@"
