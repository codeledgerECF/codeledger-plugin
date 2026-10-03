#!/usr/bin/env bash
# activate.sh — SessionStart hook: ensure CodeLedger runtime and warm context.
# Uses `codeledger ensure-session` to auto-init when needed, then scan-if-stale.
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CL_CMD=$("${PLUGIN_ROOT}/scripts/find-cli.sh" 2>/dev/null) || {
  echo "ContextECF CodeLedger: CLI not installed. Run: npm install -g @codeledger/cli"
  echo "Do not install the unrelated unscoped npm package: codeledger"
  exit 0
}

# Hook input arrives as JSON on stdin; keep it for the session resolver.
if [ ! -t 0 ]; then CL_HOOK_INPUT="$(cat 2>/dev/null || true)"; else CL_HOOK_INPUT=""; fi
export CL_HOOK_INPUT

# Establish this conversation's session from the Claude session_id (also
# exports CODELEDGER_SESSION for Bash tool calls via CLAUDE_ENV_FILE).
CL_SID=""
if [ -n "$CL_HOOK_INPUT" ] && [ -z "${CODELEDGER_SESSION:-}" ]; then
  CL_SID=$(printf '%s' "$CL_HOOK_INPUT" | $CL_CMD hooks claude session-start 2>/dev/null) || CL_SID=""
fi
if [ -z "$CL_SID" ]; then
  CL_SID=$("${PLUGIN_ROOT}/scripts/resolve-session.sh" 2>/dev/null || true)
fi
if [ -z "$CL_SID" ]; then
  CL_SID=$($CL_CMD session-init --quiet 2>/dev/null) || true
fi

# Ensure runtime: init-if-missing + scan-if-stale warmup for this session.
if [ -n "$CL_SID" ]; then
  $CL_CMD ensure-session --quiet --stale-after 3600 --session "$CL_SID" 2>/dev/null || true
else
  $CL_CMD ensure-session --quiet --stale-after 3600 2>/dev/null || true
fi
