---
name: refresh
description: Update your file selection when the task shifts mid-session. Faster than starting over — CodeLedger reuses what it already knows and adjusts to the new direction.
---

When the task changes mid-session, refresh your file selection before searching manually.

## What to run

```bash
codeledger broker refresh --task "$ARGUMENTS" --json
```

## Why refresh before searching

Refreshing takes seconds and gives you a ranked, focused set of files for the new direction. Raw file search is slower and misses the codebase relationships that CodeLedger uses to rank results.

## Example

```bash
codeledger broker refresh --task "Add auth middleware tests" --json
```
