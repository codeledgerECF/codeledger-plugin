---
name: status
description: Show the current CodeLedger session status including active bundle info, session metrics (recall, precision, token savings), and progress since last activation. Use this to check how the session is going.
---

Check the current CodeLedger session status.

## What to run

Run these commands to understand the current state:

```bash
# Show session-end metrics (recall, precision, token savings)
codeledger session-summary

# Show progress snapshot (commits, changed files, remaining bundle files)
codeledger session-progress

# List all active sessions
codeledger sessions
```

## What each command shows

### session-summary
- **Bundle recall** — What percentage of files you actually changed were predicted by the bundle
- **Bundle precision** — What percentage of bundled files you actually needed
- **Token savings** — Bundle size vs full repo size (context reduction percentage)

### session-progress
- Commits made this session
- Files changed (with diffs)
- Uncommitted work
- Bundle files not yet touched (remaining work hints)

### sessions
- All active CodeLedger sessions
- File overlap between concurrent sessions (collision detection)

## Interpreting results

- **High recall (>80%)** — The bundle covered most of what you needed
- **Low recall** — Task description may have been too vague, or the task diverged from the original plan
- **High precision (>60%)** — Bundle was focused; minimal wasted context
- **Low precision** — Budget may be too generous; try tightening with `--budget` or `--max-files`
