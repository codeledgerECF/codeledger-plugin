# CodeLedger Plugin for Claude Code

**Deterministic context selection for AI coding agents.**

CodeLedger scans your repo, scores every file across 10 weighted signals, and delivers a minimal context bundle so your agent reads the right files first. This plugin integrates CodeLedger into Claude Code with lifecycle hooks and slash commands.

## Prerequisites

Install the CodeLedger CLI:

```bash
npm install -g @codeledger/cli
```

Requires Node.js >= 20, npm, and Git.

## Install the Plugin

```bash
claude plugin install codeledger
```

Or load directly during development:

```bash
claude --plugin-dir ./path/to/this/plugin
```

## What the Plugin Does

### Lifecycle Hooks (automatic)

| Event | What happens |
|-------|-------------|
| **SessionStart** | Initializes CodeLedger (if needed), scans the repo index (if stale), and warms the cache |
| **PreToolUse** | On Edit/Write, reminds the agent to check `.codeledger/active-bundle.md` for relevant context |
| **PreCompact** | Writes a git-based session progress snapshot to `.codeledger/session-progress.md` so the agent can re-orient after context compaction |
| **Stop** | Prints session-end recall, precision, and token savings, then cleans up transient files |

### Slash Commands

| Command | Purpose |
|---------|---------|
| `/codeledger:activate` | Generate a context bundle for a task (main entry point) |
| `/codeledger:bundle` | Preview a bundle without writing to disk |
| `/codeledger:refine` | Update the bundle mid-session with new learned context |
| `/codeledger:status` | Check session metrics and progress |
| `/codeledger:explain` | Show detailed per-file scoring breakdown |

## Quick Start

1. Install the CLI and the plugin
2. Start a Claude Code session in any project
3. The plugin auto-initializes and scans the repo
4. Activate a bundle for your task:

```
/codeledger:activate Fix null handling in getUserById
```

5. The agent now has `.codeledger/active-bundle.md` with ranked files, scores, reasons, and code excerpts

## Scoring Signals

CodeLedger scores files across 10 weighted signals:

| Signal | Weight | What it measures |
|--------|--------|-----------------|
| keyword | 0.30 | Task keywords found in file |
| centrality | 0.15 | How many files import this file |
| churn | 0.15 | Git commit frequency |
| recent_touch | 0.10 | Time since last modification |
| test_relevance | 0.10 | Paired source/test relationship |
| size_penalty | 0.10 | Smaller files get a bonus |
| success_prior | 0.05 | Historical build success |
| fail_prior | 0.05 | Historical build failure |
| error_infrastructure | 0.08 | Error/validation class detection |
| branch_changed | 0.15 | Uncommitted or branch-diffed files |

## Privacy

- Runs entirely on your local machine
- Makes zero network calls
- Collects zero telemetry
- Your source code never leaves your machine

## Links

- [CodeLedger Documentation](https://codeledger.dev)
- [Getting Started Guide](https://github.com/codeledgerECF/codeledger/blob/main/GETTING-STARTED.md)
- [GitHub](https://github.com/codeledgerECF/codeledger)

## License

MIT - Intelligent Context AI, Inc.
