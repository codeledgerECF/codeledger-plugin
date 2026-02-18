# Cowork Snapshot

Write a progress snapshot for session continuity.

## Usage

```
/codeledger:cowork-snapshot
```

## What It Does

Captures the current session state to `.codeledger/progress-snapshot.json`:

```bash
codeledger cowork-snapshot --workspace .
```

The snapshot includes:
- **Last intent** — what the session is working on
- **Bundle hash** — workspace fingerprint for change detection
- **Files read** — which bundle files have been accessed
- **Suggested next files** — top 5 unread files from the bundle

## When to Use

- Before long operations that might trigger context compaction
- When you want to checkpoint your progress
- When switching between tasks temporarily
- After context compaction, read the snapshot to re-orient

## Automatic Usage

This command runs automatically via the **PreCompact** hook — you usually don't need to call it manually. But it's available if you want an explicit checkpoint.

## After Compaction

If context compaction occurs, read `.codeledger/progress-snapshot.json` to recover:
- What the task was
- Which files matter
- What's been read vs. what's still pending

## Options

- `--workspace .` — Workspace root (default: current directory)
- `--quiet` — Suppress stdout output
