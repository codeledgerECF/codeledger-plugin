# Cowork Snapshot

Save your place so the session can continue seamlessly after any interruption.

## Usage

```
/codeledger:cowork-snapshot
```

## What It Does

```bash
codeledger cowork-snapshot --workspace .
```

Saves the current session state — what you're working on, which files matter, what's been covered, and what's still pending. If the session is interrupted or context resets, this is what gets the agent back on track instantly.

## When to Use

- Before a long operation you're not sure will complete cleanly
- When switching tasks temporarily and coming back later
- Any time you want to mark your progress explicitly

## Automatic

This runs automatically before context compaction, so you usually don't need to call it manually. It's available when you want an explicit checkpoint.

## Options

- `--workspace .` — Project root (default: current directory)
- `--quiet` — Suppress output
