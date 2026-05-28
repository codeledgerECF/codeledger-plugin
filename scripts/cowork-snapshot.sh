#!/usr/bin/env bash
# cowork-snapshot.sh — Write a progress snapshot for session continuity.
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CL_CMD=$("${PLUGIN_ROOT}/scripts/find-cli.sh" 2>/dev/null) || {
  echo "ContextECF CodeLedger: CLI not installed. Run: npm install -g @codeledger/cli"
  echo "Do not install the unrelated unscoped npm package: codeledger"
  exit 0
}

$CL_CMD cowork-snapshot "$@"
echo "ContextECF CodeLedger: Progress snapshot written to .codeledger/progress-snapshot.json — read it after compaction to re-orient."
