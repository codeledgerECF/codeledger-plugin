#!/usr/bin/env bash
# context-refresh.sh — UserPromptSubmit hook: refresh CodeLedger context for meaningful prompts.
# Reads the prompt payload from stdin, asks CodeLedger to apply the meaningful-task rule,
# and stores the latest broker refresh result for plugin-aware agents.
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CL_CMD=$("${PLUGIN_ROOT}/scripts/find-cli.sh" 2>/dev/null) || exit 0

PAYLOAD="$(cat 2>/dev/null || true)"
if [ -z "$PAYLOAD" ]; then
  exit 0
fi

PROMPT="$(printf '%s' "$PAYLOAD" | node -e '
let raw = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", (chunk) => { raw += chunk; });
process.stdin.on("end", () => {
  try {
    const payload = JSON.parse(raw || "{}");
    const candidates = [
      payload.prompt,
      payload.user_prompt,
      payload.message,
      payload.text,
      payload.input,
      payload.transcript?.text,
    ];
    const value = candidates.find((entry) => typeof entry === "string" && entry.trim());
    process.stdout.write(value ? value.trim() : "");
  } catch {
    process.stdout.write("");
  }
});
')" || true

if [ -z "$PROMPT" ]; then
  exit 0
fi

mkdir -p .codeledger/runtime

CL_SID=$("${PLUGIN_ROOT}/scripts/resolve-session.sh" 2>/dev/null || true)

# Apply the same meaningful-task rule used by hooks and ambient wrappers.
if [ -n "$CL_SID" ]; then
  $CL_CMD auto-refresh --quiet --prompt "$PROMPT" --session "$CL_SID" >/dev/null 2>&1 || true
else
  $CL_CMD auto-refresh --quiet --prompt "$PROMPT" >/dev/null 2>&1 || true
fi

# Persist the latest plugin-facing retrieval state for agents to inspect during the session.
if [ -n "$CL_SID" ]; then
  $CL_CMD broker refresh --task "$PROMPT" --session "$CL_SID" --json > .codeledger/runtime/latest-broker-refresh.json 2>/dev/null || true
else
  $CL_CMD broker refresh --task "$PROMPT" --json > .codeledger/runtime/latest-broker-refresh.json 2>/dev/null || true
fi
$CL_CMD broker current --json > .codeledger/runtime/latest-broker-current.json 2>/dev/null || true
$CL_CMD broker timeline --limit 10 --json > .codeledger/runtime/latest-broker-timeline.json 2>/dev/null || true
