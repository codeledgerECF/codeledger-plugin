---
name: status
description: See how your session is going — which files are in focus, what's been done, and how accurately CodeLedger predicted the files you actually needed.
---

Check what's happening in the current session.

## What to run

```bash
# What's in focus right now
codeledger broker current --json

# Summary of what was done and what's left
codeledger session-progress

# End-of-session accuracy report
codeledger session-summary
```

## What each command shows

### session-progress
A ground-truth view of the session from git: commits made, files changed, uncommitted work, and files not yet touched. Useful after a long session or after context compaction to re-orient.

### session-summary
How well CodeLedger predicted the files you actually changed:
- **Coverage** — Did the suggested files include the ones you ended up editing?
- **Focus** — Were the suggested files mostly useful, or did they include a lot of noise?
- **Token savings** — How much context was excluded compared to the full repo

High coverage means the task description was clear and CodeLedger got it right. Low focus means the selection could have been tighter — try a more specific task description next time.

### broker current
Which files CodeLedger is currently focused on and what changed when the task last shifted.
