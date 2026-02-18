#!/usr/bin/env bash
# session-summary.sh — Stop hook: show session-end metrics and clean up.
# Prints recall, precision, and token savings, then removes transient files.
set -euo pipefail

# Clean up the one-shot reminder marker
rm -f .codeledger/.hook-reminded

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CL_CMD=$("${PLUGIN_ROOT}/scripts/find-cli.sh" 2>/dev/null) || {
  echo 'Tip: Run "codeledger activate --task \"your next task\"" to generate context for your next task.'
  exit 0
}

$CL_CMD session-summary 2>/dev/null || true

# Clean up transient session files
rm -f .codeledger/.session-start-ref .codeledger/.activate-ref .codeledger/session-progress.md

echo 'Tip: Run "codeledger activate --task \"your next task\"" to refresh context for your next task.'
