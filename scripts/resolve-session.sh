#!/usr/bin/env bash
# resolve-session.sh — Resolve the active CodeLedger session ID for plugin hooks.
set -euo pipefail

if [ -n "${CODELEDGER_SESSION:-}" ]; then
  printf '%s\n' "$CODELEDGER_SESSION"
  exit 0
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
