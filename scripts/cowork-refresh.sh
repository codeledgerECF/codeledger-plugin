#!/usr/bin/env bash
# cowork-refresh.sh — Re-score the context bundle with an updated intent.
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CL_CMD=$("${PLUGIN_ROOT}/scripts/find-cli.sh" 2>/dev/null) || {
  echo "CodeLedger: CLI not installed. Run: npm install -g @codeledger/cli"
  exit 0
}

$CL_CMD cowork-refresh "$@"
