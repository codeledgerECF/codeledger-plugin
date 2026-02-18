# CodeLedger Plugin for Claude Code

**Your agent reads the right files first. Every time.**

CodeLedger is a deterministic context selection engine for AI coding agents. It scans your repository, scores every file across 10 weighted signals, and delivers a minimal, ranked context bundle — so your agent starts with the files that matter most, not a random walk through your codebase.

## Why CodeLedger

| Without CodeLedger | With CodeLedger |
|--------------------|-----------------|
| Agent explores randomly, reads 40+ files | Agent reads 8-15 targeted files |
| Wastes tokens on irrelevant context | Stays within a strict token budget |
| Loses orientation after context compaction | Recovers instantly via progress snapshots |
| Different runs, different file choices | Same task = same bundle (deterministic) |

### Measured Quality

Every release is gated by automated quality benchmarks across real-world task scenarios:

| Metric | Default Budget | Tight Budget |
|--------|---------------|--------------|
| **Recall** (relevant files found) | 100% | 100% |
| **Precision** (noise excluded) | 32% | 62.5% |
| **Must-hit rate** (critical files) | 100% | 100% |

> Recall is the priority: the agent should never miss a file it needs. Precision improves with tighter budgets.

## Install

### 1. Install the CLI

```bash
npm install -g @codeledger/cli
```

Requires Node.js >= 20 and Git.

### 2. Install the Plugin

```bash
claude plugin install codeledger
```

### 3. One-Command Setup (in any project)

```bash
codeledger activate --task "describe your task here"
```

This single command initializes CodeLedger (if needed), scans the repo, scores all files against your task, and writes `.codeledger/active-bundle.md` with the result.

## Two Modes, One Plugin

### Mode 1: Standalone Context Selection

Use `/codeledger:activate` at the start of any task. The agent gets a ranked bundle of the most relevant files with scores, reasons, and code excerpts.

```
/codeledger:activate Fix null handling in getUserById
```

### Mode 2: Cowork Session Integration

For long-running, multi-step work, Cowork mode adds lifecycle management — the plugin automatically initializes context on session start, takes progress snapshots before compaction, and prints recall/precision metrics when the session ends.

```
/codeledger:cowork-start Refactor the authentication middleware
```

The agent stays oriented across the entire session, even through context compaction events.

## Lifecycle Hooks (Automatic)

These fire automatically — no user action needed:

| Event | What Happens |
|-------|-------------|
| **SessionStart** | Initializes CodeLedger, scans the repo index (if stale >1hr), warms the cache |
| **PreToolUse** | On Edit/Write, reminds the agent to check `.codeledger/active-bundle.md` for relevant context (once per session) |
| **PreCompact** | Writes a ground-truth session progress snapshot to `.codeledger/session-progress.md` so the agent re-orients after compaction |
| **Stop** | Prints session-end recall, precision, and token savings; cleans up transient files |

## Slash Commands

### Context Selection

| Command | Purpose |
|---------|---------|
| `/codeledger:activate` | Generate and write a context bundle for a task |
| `/codeledger:bundle` | Preview a bundle without writing to disk |
| `/codeledger:refine` | Update the bundle mid-session with new learned context |
| `/codeledger:explain` | Detailed per-file scoring breakdown with near-misses |
| `/codeledger:status` | Check session metrics and progress |

### Cowork Lifecycle

| Command | Purpose |
|---------|---------|
| `/codeledger:cowork-start` | Start a Cowork session: scan + knowledge-scored bundle |
| `/codeledger:cowork-refresh` | Re-score with updated intent mid-session |
| `/codeledger:cowork-snapshot` | Write a progress snapshot for session continuity |

## Scoring Signals

CodeLedger scores files across 10 weighted signals:

| Signal | Weight | What It Measures |
|--------|--------|-----------------|
| `keyword` | 0.30 | Task keywords found in file content and path |
| `centrality` | 0.15 | How many other files import this file |
| `churn` | 0.15 | Git commit frequency (high churn = high relevance) |
| `branch_changed` | 0.15 | Uncommitted or branch-diffed files |
| `recent_touch` | 0.10 | Time since last modification |
| `test_relevance` | 0.10 | Paired source/test file relationship |
| `size_penalty` | 0.10 | Smaller, focused files get a bonus |
| `error_infrastructure` | 0.08 | Error handling and validation patterns |
| `success_prior` | 0.05 | Historical build success rate |
| `fail_prior` | 0.05 | Historical build failure rate |

All weights are configurable in `.codeledger/config.json`.

## How It Works

```
Task Description
       |
       v
  +-----------+     +-----------+     +-------------+
  | Repo Scan |---->| Score     |---->| Select &    |
  | (index,   |     | (10       |     | Bundle      |
  |  deps,    |     |  signals) |     | (stop rule, |
  |  churn)   |     |           |     |  budget)    |
  +-----------+     +-----------+     +-------------+
                                            |
                                            v
                                  .codeledger/active-bundle.md
                                  - Ranked files with scores
                                  - Relevance reasons per file
                                  - Code excerpts
                                  - Token budget usage
```

1. **Scan** — Builds a file index with dependency graph, git churn, and test mappings
2. **Score** — Each file is scored against the task description using 10 weighted signals
3. **Select** — Files are ranked and selected using a sufficiency stop rule (default threshold: 0.85) within a token budget
4. **Bundle** — The result is written as a human-readable markdown file with scores, reasons, and excerpts

## Privacy

- Runs entirely on your local machine
- Makes zero network calls
- Collects zero telemetry
- Your source code never leaves your machine
- No cloud APIs, no embeddings, no external dependencies

## Links

- [GitHub](https://github.com/codeledgerECF/codeledger-plugin)
- [CodeLedger Core](https://github.com/codeledgerECF/codeledger)
- [Documentation](https://codeledger.dev)

## License

MIT - Intelligent Context AI, Inc.
