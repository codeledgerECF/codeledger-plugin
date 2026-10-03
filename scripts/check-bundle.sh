#!/usr/bin/env bash
# check-bundle.sh — PreToolUse hook: remind agent about active bundle on Edit/Write.
# Only fires once per session (uses a marker file to avoid spamming).
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# Hook input arrives as JSON on stdin; keep it for the session resolver.
if [ ! -t 0 ]; then CL_HOOK_INPUT="$(cat 2>/dev/null || true)"; else CL_HOOK_INPUT=""; fi
export CL_HOOK_INPUT
CL_SID=$("${PLUGIN_ROOT}/scripts/resolve-session.sh" 2>/dev/null || true)

# Tool name from the JSON hook input
TOOL_NAME=""
if command -v jq >/dev/null 2>&1; then
  TOOL_NAME=$(printf '%s' "$CL_HOOK_INPUT" | jq -r '.tool_name // empty' 2>/dev/null) || true
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
