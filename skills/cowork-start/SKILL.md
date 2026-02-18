# Cowork Start

Start a Cowork session with knowledge-scored context selection.

## Usage

```
/codeledger:cowork-start <task description>
```

## What It Does

Run this command to start a long-running session with full lifecycle management:

```bash
codeledger cowork-start --intent "$ARGUMENTS" --workspace .
```

This command:

1. **Scans** the workspace — builds a file index with dependency graph, git churn, and test mappings
2. **Scores** every file using knowledge-weighted signals optimized for understanding codebases (not just keyword matching)
3. **Selects** files within a strict token budget using a sufficiency stop rule
4. **Writes artifacts** to `.codeledger/`:
   - `context-bundle.json` — machine-readable bundle with scores, reasons, and excerpt references
   - `trace.json` — full scoring trace for debugging and explainability
   - `excerpts/` — extracted code excerpts for quick access

## After Starting

1. Read `.codeledger/context-bundle.json` for the ranked file selection
2. Prioritize the listed files — they were selected deterministically based on your task
3. Each file includes a score, reasons for inclusion, and an excerpt reference

## When to Use This vs. `/codeledger:activate`

| Feature | `activate` | `cowork-start` |
|---------|-----------|----------------|
| Scoring mode | Standard (10 signals) | Knowledge-optimized |
| Output format | Markdown (`active-bundle.md`) | JSON + trace + excerpts |
| Session tracking | Basic | Full lifecycle (snapshot, stop) |
| Best for | Quick tasks | Multi-step, long-running work |

## Options

- `--intent "..."` — Task description (required)
- `--workspace .` — Workspace root (default: current directory)
- `--quiet` — Suppress stdout output
