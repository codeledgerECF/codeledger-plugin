---
name: timeline
description: Review recent session activity — what happened, what changed, and where things stand. Particularly useful after context compaction to get back up to speed quickly.
---

See what happened recently in the session.

## What to run

```bash
codeledger broker timeline --limit 10 --json
```

## When to use

- After context compaction — get back up to speed without re-reading the conversation
- Before making a change — confirm what's already been done
- When switching between tasks — see the recent history at a glance

## Example

```bash
codeledger broker timeline --limit 10 --json
```
