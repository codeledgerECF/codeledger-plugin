#!/usr/bin/env bash
# setup-local.sh — Set up CodeLedger plugin for Claude Desktop on your machine.
#
# Usage:
#   cd ~/path/to/codeledger-plugin
#   bash setup-local.sh
#
# What this does:
#   1. Detects plugin location
#   2. Writes ~/.claude/hooks.json with correct paths
#   3. Verifies codeledger CLI is available
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
HOOKS_FILE="${CLAUDE_DIR}/hooks.json"

echo "CodeLedger Plugin Setup"
echo "======================"
echo ""
echo "Plugin directory: ${PLUGIN_DIR}"
echo "Claude config:    ${HOOKS_FILE}"
echo ""

# Check for codeledger CLI
if command -v codeledger >/dev/null 2>&1; then
  echo "codeledger CLI: $(command -v codeledger)"
elif [ -x "${PLUGIN_DIR}/../codeledger-blackbox/packages/cli/dist/index.js" ] 2>/dev/null; then
  echo "codeledger CLI: monorepo dev mode (node)"
elif command -v npx >/dev/null 2>&1; then
  echo "codeledger CLI: will use npx fallback"
else
  echo "WARNING: codeledger CLI not found."
  echo "  Install with: npm install -g @codeledger/cli"
  echo ""
fi

# Ensure scripts are executable
chmod +x "${PLUGIN_DIR}/scripts/"*.sh

# Back up existing hooks.json if present
if [ -f "$HOOKS_FILE" ]; then
  BACKUP="${HOOKS_FILE}.backup.$(date +%Y%m%d%H%M%S)"
  cp "$HOOKS_FILE" "$BACKUP"
  echo "Backed up existing hooks.json to ${BACKUP}"
fi

# Write hooks.json
mkdir -p "$CLAUDE_DIR"
cat > "$HOOKS_FILE" << JSONEOF
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "${PLUGIN_DIR}/scripts/activate.sh",
        "timeout": 30000
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit|NotebookEdit",
        "type": "command",
        "command": "${PLUGIN_DIR}/scripts/check-bundle.sh",
        "timeout": 5000
      }
    ],
    "PreCompact": [
      {
        "type": "command",
        "command": "${PLUGIN_DIR}/scripts/session-progress.sh",
        "timeout": 10000
      },
      {
        "type": "command",
        "command": "${PLUGIN_DIR}/scripts/cowork-snapshot.sh --workspace . --quiet 2>/dev/null || true",
        "timeout": 10000
      }
    ],
    "Stop": [
      {
        "type": "command",
        "command": "${PLUGIN_DIR}/scripts/session-summary.sh",
        "timeout": 10000
      }
    ]
  }
}
JSONEOF

echo ""
echo "hooks.json written to ${HOOKS_FILE}"
echo ""
echo "Done! Next steps:"
echo "  1. Open Claude Desktop"
echo "  2. Start a session in any project"
echo "  3. CodeLedger will auto-activate on session start"
echo "  4. Use /codeledger:activate or /codeledger:cowork-start to generate bundles"
echo ""
