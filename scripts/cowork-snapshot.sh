#!/usr/bin/env bash
# cowork-snapshot.sh — Write a progress snapshot for session continuity.
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CL_CMD=$("${PLUGIN_ROOT}/scripts/find-cli.sh" 2>/dev/null) || {
  echo "CodeLedger: CLI not installed. Run: npm install -g @codeledger/cli"
  exit 0
}

$CL_CMD cowork-snapshot "$@"
echo "CodeLedger: Progress snapshot written to .codeledger/progress-snapshot.json — read it after compaction to re-orient."
