#!/usr/bin/env bash
# check-bundle.sh — PreToolUse hook: remind agent about active bundle on Edit/Write.
# Only fires once per session (uses a marker file to avoid spamming).
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CL_SID=$("${PLUGIN_ROOT}/scripts/resolve-session.sh" 2>/dev/null || true)

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

if [ -n "$CL_SID" ]; then
  MARKER=".codeledger/sessions/$CL_SID/.hook-reminded"
  BUNDLE=".codeledger/sessions/$CL_SID/active-bundle.md"
else
  MARKER=".codeledger/.hook-reminded"
  BUNDLE=".codeledger/active-bundle.md"
fi

if [ -f "$MARKER" ]; then
  exit 0
fi

if [ -f "$BUNDLE" ]; then
  mkdir -p "$(dirname "$MARKER")"
  touch "$MARKER"
  echo "CodeLedger: Active context bundle at $BUNDLE — check it for relevant files, excerpts, and dependency relationships before editing."
fi
