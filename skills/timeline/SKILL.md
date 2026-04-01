---
name: timeline
description: Read the recent live truth ledger tail without rereading the entire timeline. Use this to recover session state after compaction or to understand what was actually observed, validated, blocked, or corrected.
---

Run `codeledger broker timeline` to inspect the recent session truth tail.

## What to run

```bash
codeledger broker timeline --limit 10 --json
```

## When to use

- after compaction
- when checking what changed since the last task
- before making claims about work that already happened

## Example

```bash
codeledger broker timeline --limit 10 --json
```
