#!/usr/bin/env bash
# resolve-session.sh — Resolve the active CodeLedger session ID for plugin hooks.
#
# Order: CODELEDGER_SESSION, then the Claude Code hook payload (CL_HOOK_INPUT,
# set by the calling hook script, which owns stdin), then the legacy PID marker.
# The payload's session_id is mapped by `codeledger hooks claude resolve-session`,
# the same resolver the CLI-installed hooks use, so concurrent tabs never share
# a session.
set -euo pipefail

if [ -n "${CODELEDGER_SESSION:-}" ]; then
  printf '%s\n' "$CODELEDGER_SESSION"
  exit 0
fi

if [ -n "${CL_HOOK_INPUT:-}" ]; then
  PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
  CL_CMD=$("${PLUGIN_ROOT}/scripts/find-cli.sh" 2>/dev/null) || CL_CMD=""
  if [ -n "$CL_CMD" ]; then
    SESSION_ID="$(printf '%s' "$CL_HOOK_INPUT" | $CL_CMD hooks claude resolve-session 2>/dev/null || true)"
    if [ -n "$SESSION_ID" ]; then
      printf '%s\n' "$SESSION_ID"
      exit 0
    fi
  fi
fi

PPID_VALUE="${PPID:-}"
if [ -n "$PPID_VALUE" ]; then
  MARKER=".codeledger/.current-session-pid-${PPID_VALUE}"
  if [ -f "$MARKER" ]; then
    SESSION_ID="$(cat "$MARKER" 2>/dev/null || true)"
    if [ -n "$SESSION_ID" ]; then
      printf '%s\n' "$SESSION_ID"
      exit 0
    fi
  fi
fi

exit 0
