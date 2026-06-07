# Cowork Refresh

Update the file selection when your focus shifts mid-session.

## Usage

```
/codeledger:cowork-refresh <new task description or focus>
```

## What It Does

```bash
codeledger cowork-refresh --intent "$ARGUMENTS" --workspace .
```

Reanalyzes the codebase for the new direction and updates the selected files — without starting the session over.

## When to Use

- The real problem turned out to be somewhere different than expected
- The scope narrowed or shifted during investigation
- You want to focus on a specific area you've discovered

## Options

- `--intent "..."` — Updated description of what you're now working on (required)
- `--workspace .` — Project root (default: current directory)
- `--quiet` — Suppress output
