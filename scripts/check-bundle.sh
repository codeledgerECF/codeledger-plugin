#!/usr/bin/env bash
# check-bundle.sh — PreToolUse hook: remind agent about active bundle on Edit/Write.
# Only fires once per session (uses a marker file to avoid spamming).
set -euo pipefail

# Read tool name from stdin (JSON hook input)
TOOL_NAME=""
if command -v jq >/dev/null 2>&1; then
  TOOL_NAME=$(jq -r '.tool_name // empty' 2>/dev/null) || true
fi

# Only trigger on file-editing tools
case "$TOOL_NAME" in
  Edit|Write|MultiEdit|NotebookEdit) ;;
  *) exit 0 ;;
esac

MARKER=".codeledger/.hook-reminded"
if [ -f "$MARKER" ]; then
  exit 0
fi

if [ -f ".codeledger/active-bundle.md" ]; then
  mkdir -p .codeledger
  touch "$MARKER"
  echo "CodeLedger: Active context bundle at .codeledger/active-bundle.md — check it for relevant files, excerpts, and dependency relationships before editing."
fi
