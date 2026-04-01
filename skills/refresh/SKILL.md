---
name: refresh
description: Refresh active context for a new or shifted task during a live session. Use this first before low-level file search. Returns ranked files plus context delta through the broker surface.
---

Run `codeledger broker refresh` before raw search when the user states a meaningful new task mid-session.

## What to run

```bash
codeledger broker refresh --task "$ARGUMENTS" --json
```

## Why this comes first

- It applies the same meaningful-task rule as hooks and ambient wrappers
- It refreshes or reuses the active bundle deterministically
- It returns ranked files and the bundle delta
- It keeps low-level search as a fallback, not the default

## Fallback order

1. `codeledger broker refresh --task "..."`
2. `codeledger broker resolve --task "..."`
3. Raw shell search such as `rg`

## Example

```bash
codeledger broker refresh --task "Add auth middleware tests" --json
```
