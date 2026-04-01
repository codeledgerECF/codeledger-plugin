---
name: current
description: Inspect the current active bundle, latest bundle delta, and recent truth tail during a session. Use this when you need to understand what CodeLedger currently believes and how the context changed.
---

Run `codeledger broker current` to inspect the active context state.

## What to run

```bash
codeledger broker current --json
```

## What it returns

- current bundle id and task
- top ranked files
- latest bundle delta
- recent timeline tail

## Example

```bash
codeledger broker current --json
```
