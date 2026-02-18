#!/usr/bin/env bash
# session-progress.sh — PreCompact hook: write ground-truth progress snapshot.
# This snapshot survives context compaction and helps the agent re-orient.
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CL_CMD=$("${PLUGIN_ROOT}/scripts/find-cli.sh" 2>/dev/null) || {
  exit 0
}

$CL_CMD session-progress --quiet 2>/dev/null || true
echo "CodeLedger: Session progress snapshot written to .codeledger/session-progress.md — read it after compaction to see what was accomplished."
