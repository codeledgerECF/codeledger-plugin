---
name: refine
description: Update your file selection mid-session as you learn more. When the real problem turns out to be somewhere different, tell CodeLedger what you've discovered and it will adjust without starting over.
---

Tell CodeLedger what you've learned and it will sharpen the file selection.

## What to run

```bash
codeledger refine --learned "$ARGUMENTS"
```

## Common options

- `--learned "description"` — What you've discovered mid-task (e.g., "the bug is in the cache layer, not the API handler")
- `--add-keywords "cache,TTL"` — Add terms that should pull in more relevant files
- `--drop "src/services/auth.ts"` — Remove a file that turned out not to matter
- `--expand` — Cast a wider net after refining

## When to use

- You've started working and discovered the real issue is somewhere you didn't expect
- The initial file selection included things that aren't relevant
- You want to steer toward a specific area of the codebase

## Examples

```bash
# Tell CodeLedger where the real problem is
codeledger refine --learned "The issue is in the WebSocket reconnection logic, not the HTTP client"

# Pull in files around a specific concept
codeledger refine --add-keywords "reconnect,backoff,heartbeat"

# Remove files that aren't relevant
codeledger refine --drop "src/services/auth.ts" --drop "src/utils/format.ts"
```
