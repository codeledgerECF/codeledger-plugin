# Cowork Refresh

Re-score the context bundle with an updated intent mid-session.

## Usage

```
/codeledger:cowork-refresh <new task description or focus>
```

## What It Does

Run this when your focus shifts during a session:

```bash
codeledger cowork-refresh --intent "$ARGUMENTS" --workspace .
```

This command re-runs the knowledge scoring pipeline against the new intent and updates all artifacts:

- `context-bundle.json` is regenerated with new scores and selections
- `trace.json` reflects the updated scoring profile
- `excerpts/` are regenerated for newly selected files

## When to Use

- The user shifts focus to a different part of the codebase
- You discovered the real problem is in a different area than initially expected
- The original intent was too broad and needs narrowing
- New keywords or file patterns emerged during investigation

## Options

- `--intent "..."` — Updated task description (required)
- `--workspace .` — Workspace root (default: current directory)
- `--quiet` — Suppress stdout output
