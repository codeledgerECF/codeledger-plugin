# Cursor Marketplace Submission — CodeLedger

Fill in this form at https://cursor.com/en/marketplace/publish

---

## Organization name
```
Intelligent Context AI
```

## Organization handle
```
codeledger
```

## Unique namespace (kebab-case)
```
@codeledger
```

## Contact email
```
ash@connectwithash.com
```

## Logotype URL
```
https://raw.githubusercontent.com/codeledgerECF/codeledger-plugin/main/logo.svg
```
1:1 SVG with transparent background (document icon, currentColor strokes).

## Description
```
CodeLedger gives your AI coding agent the right files first. It scans your repo, scores every file across 10 weighted signals — keyword relevance, centrality, git churn, recency, test pairing, and more — and delivers a ranked context bundle within a token budget. Includes a live context cockpit with Explain, Learnings, and Next tabs that refresh every 10 seconds. 14 MCP tools. Fully local. No cloud, no telemetry.
```

## GitHub repository
```
https://github.com/codeledgerECF/codeledger-plugin
```

## Website URL
```
https://codeledger.dev
```

---

## What this plugin distributes

| Type | Contents |
|------|----------|
| **MCP server** | 14 tools: context selection, replay, reasoning, system map, panel cockpit |
| **Rules** | `rules/codeledger.mdc` — agent protocol: use MCP before browsing files |
| **Skills** | activate, refresh, bundle, refine, explain, current, timeline, status, cowork-* |
| **Hooks** | SessionStart, UserPromptSubmit, PreToolUse (Edit/Write), PreCompact, Stop |

---

## MCP Tools (14)

### Core
| Tool | What it does |
|------|-------------|
| `query_ledger` | Search Golden Patterns and episodes from repo memory |
| `get_active_context` | Return the ranked active context bundle |
| `record_interaction` | Write success/failure signals into evidence buffer |
| `prompt_validate` | Score task prompts against best practices |

### Specialized
| Tool | What it does |
|------|-------------|
| `codeledger_replay` | Search retained terminal flows for prior execution patterns |
| `codeledger_recent_flows` | Recent retained operational execution history |
| `codeledger_flow_explain` | Explain why a flow was kept by the Context Sieve |
| `codeledger_reason` | FAST / GUIDED / FULL synthesis with pre-reasoning gating |
| `codeledger_system_map` | Topology — blast radius, component roles, invariants |
| `codeledger_context_pointers` | Bootstrap guidance — canonical docs and entry points |
| `codeledger_execution_prompt` | Repo-aware Reality Loop execution prompt |

### Panel / Cockpit (built April 2026)
| Tool | What it does |
|------|-------------|
| `panel_snapshot` | Full cockpit snapshot: bundle, status, annotations, cert state |
| `panel_brief` | Markdown brief for Explain / Learnings / Next tab |
| `panel_handoff` | Files to inspect, risk notes, verification commands |

---

## Install for Cursor users

### 1. Install the CLI
```bash
npm install -g @codeledger/cli
```

### 2. Add the MCP server to Cursor

In `.cursor/mcp.json` (or Cursor Settings → MCP):
```json
{
  "mcpServers": {
    "codeledger": {
      "command": "codeledger",
      "args": ["mcp", "start"],
      "env": {
        "CODELEDGER_REPO_ROOT": "${workspaceFolder}"
      }
    }
  }
}
```

### 3. Initialize in your repo
```bash
codeledger init
codeledger activate --task "describe your task"
```

### 4. Optional: live context panel
```bash
node .claude/panel-server.mjs
# Open http://localhost:7420
```

---

## Privacy

- Runs entirely on the user's local machine
- Zero network calls, zero telemetry
- Source code never leaves the machine
- No cloud APIs, no embeddings
