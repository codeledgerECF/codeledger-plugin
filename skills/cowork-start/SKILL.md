# Cowork Start

Start a focused session with smart file selection — optimized for deep, multi-step work.

## Usage

```
/codeledger:cowork-start <task description>
```

## What It Does

```bash
codeledger cowork-start --intent "$ARGUMENTS" --workspace .
```

Analyzes your codebase, selects the files most relevant to your task, and sets up full session tracking so nothing gets lost — even across long sessions with context resets.

## When to Use This vs. `/codeledger:activate`

| | `activate` | `cowork-start` |
|--|-----------|----------------|
| Best for | Quick tasks, feature work | Deep investigations, multi-step refactors |
| Session tracking | Standard | Full lifecycle with checkpoints |
| Output | Markdown file list | Structured selection with excerpts |

## Options

- `--intent "..."` — What you're working on (required)
- `--workspace .` — Project root (default: current directory)
- `--quiet` — Suppress output
