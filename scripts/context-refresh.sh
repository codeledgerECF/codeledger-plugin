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

PARSED="$(printf '%s' "$PAYLOAD" | node -e '
let raw = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", (chunk) => { raw += chunk; });
function norm(value) {
  if (typeof value === "string") return value.trim().replace(/\s+/g, " ");
  if (Array.isArray(value)) return value.map(norm).filter(Boolean).join(" ").trim();
  if (value && typeof value === "object") return norm(value.text ?? value.message ?? value.content ?? value.input ?? "");
  return "";
}
function readMessages(payload) {
  if (!Array.isArray(payload.messages)) return [];
  return payload.messages
    .map((entry) => ({
      role: norm(entry?.role ?? entry?.sender ?? entry?.author ?? "").toLowerCase(),
      text: norm(entry?.content ?? entry?.text ?? entry?.message ?? entry),
    }))
    .filter((entry) => entry.text);
}
function lastUserText(messages) {
  for (let index = messages.length - 1; index >= 0; index -= 1) {
    if (messages[index].role === "user" || messages[index].role === "human") return messages[index].text;
  }
  return "";
}
function previousAssistantText(payload) {
  const direct = [
    payload.previous_assistant_task,
    payload.assistant_proposed_task,
    payload.previous_assistant_message,
    payload.previousAssistantMessage,
    payload.assistant_message,
    payload.assistantMessage,
  ].map(norm).find(Boolean);
  if (direct) return direct;
  const messages = readMessages(payload);
  let lastUserIndex = -1;
  for (let index = messages.length - 1; index >= 0; index -= 1) {
    if (messages[index].role === "user" || messages[index].role === "human") {
      lastUserIndex = index;
      break;
    }
  }
  if (lastUserIndex <= 0) return "";
  for (let index = lastUserIndex - 1; index >= 0; index -= 1) {
    if (messages[index].role === "assistant" || messages[index].role === "model") return messages[index].text;
  }
  return "";
}
process.stdin.on("end", () => {
  try {
    const payload = JSON.parse(raw || "{}");
    const messages = readMessages(payload);
    const candidates = [
      payload.prompt,
      payload.user_prompt,
      payload.message,
      payload.text,
      payload.input,
      payload.transcript?.text,
      lastUserText(messages),
    ];
    const prompt = candidates.map(norm).find(Boolean) ?? "";
    const assistantTask = previousAssistantText(payload);
    process.stdout.write(JSON.stringify({ prompt, assistantTask }));
  } catch {
    process.stdout.write("{\"prompt\":\"\",\"assistantTask\":\"\"}");
  }
});
')" || true

PROMPT="$(printf '%s' "$PARSED" | node -e '
let raw = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", (chunk) => { raw += chunk; });
process.stdin.on("end", () => {
  try {
    const parsed = JSON.parse(raw || "{}");
    process.stdout.write(typeof parsed.prompt === "string" ? parsed.prompt : "");
  } catch {
    process.stdout.write("");
  }
});
')" || true

ASSISTANT_TASK="$(printf '%s' "$PARSED" | node -e '
let raw = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", (chunk) => { raw += chunk; });
process.stdin.on("end", () => {
  try {
    const parsed = JSON.parse(raw || "{}");
    process.stdout.write(typeof parsed.assistantTask === "string" ? parsed.assistantTask : "");
  } catch {
    process.stdout.write("");
  }
});
')" || true

if [ -z "$PROMPT" ]; then
  exit 0
fi

EFFECTIVE_TASK="$PROMPT"
if printf '%s' "$PROMPT" | grep -Eiq '^(yes|yes please|yep|yeah|ok|okay|sure|sounds good|looks good|please do|do it|go ahead|continue|carry on|proceed|approved|sgtm|ship it|merge it|thanks|thank you|cool|great|nice|works for me|that works)[.! ]*$' \
  && printf '%s' "$ASSISTANT_TASK" | grep -Eiq '(fix|add|update|implement|refactor|debug|investigate|review|test|document|docs|wire|connect|integrate|remove|rename|optimize|improve|support|enable|disable|create|build|scaffold|generate|migrate|verify|audit|analyze|triage|check|repair|harden|rewrite|cleanup|ensure|align|sync|refresh|ship|release|`|\.ts|\.tsx|\.js|\.jsx|\.json|bundle|runtime|session|hook)'
then
  EFFECTIVE_TASK="$ASSISTANT_TASK"
fi

mkdir -p .codeledger/runtime

CL_SID=$("${PLUGIN_ROOT}/scripts/resolve-session.sh" 2>/dev/null || true)

# Apply the same meaningful-task rule used by hooks and ambient wrappers.
if [ -n "$CL_SID" ]; then
  if [ -n "$ASSISTANT_TASK" ]; then
    $CL_CMD auto-refresh --quiet --prompt "$PROMPT" --assistant-proposed-task "$ASSISTANT_TASK" --session "$CL_SID" >/dev/null 2>&1 || true
  else
    $CL_CMD auto-refresh --quiet --prompt "$PROMPT" --session "$CL_SID" >/dev/null 2>&1 || true
  fi
else
  if [ -n "$ASSISTANT_TASK" ]; then
    $CL_CMD auto-refresh --quiet --prompt "$PROMPT" --assistant-proposed-task "$ASSISTANT_TASK" >/dev/null 2>&1 || true
  else
    $CL_CMD auto-refresh --quiet --prompt "$PROMPT" >/dev/null 2>&1 || true
  fi
fi

# Persist the latest plugin-facing retrieval state for agents to inspect during the session.
if [ -n "$CL_SID" ]; then
  $CL_CMD broker refresh --task "$EFFECTIVE_TASK" --session "$CL_SID" --json > .codeledger/runtime/latest-broker-refresh.json 2>/dev/null || true
else
  $CL_CMD broker refresh --task "$EFFECTIVE_TASK" --json > .codeledger/runtime/latest-broker-refresh.json 2>/dev/null || true
fi
$CL_CMD broker current --json > .codeledger/runtime/latest-broker-current.json 2>/dev/null || true
$CL_CMD broker timeline --limit 10 --json > .codeledger/runtime/latest-broker-timeline.json 2>/dev/null || true
printf '%s\n' '{"schema_version":"codeledger/broker-first/v1","policy":"broker_first","refresh_artifact":".codeledger/runtime/latest-broker-refresh.json","current_artifact":".codeledger/runtime/latest-broker-current.json","timeline_artifact":".codeledger/runtime/latest-broker-timeline.json","raw_search":"fallback_after_broker_insufficient"}' > .codeledger/runtime/latest-broker-contract.json 2>/dev/null || true
