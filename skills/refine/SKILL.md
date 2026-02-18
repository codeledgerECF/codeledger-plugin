---
name: refine
description: Refine the active context bundle mid-session with new learned context. Use this when you've discovered important files, want to add keywords, or need to drop irrelevant files from the bundle. Re-scores and recomputes all derived metadata.
---

Run `codeledger refine` to update the active bundle with new context learned during the session.

## What to run

```bash
codeledger refine --learned "$ARGUMENTS"
```

## Common options

- `--learned "description"` — Describe what you've learned (e.g., "the bug is in the cache invalidation path, not the fetch path")
- `--add-keywords "cache,invalidation,TTL"` — Inject new search terms to influence scoring
- `--drop "path/to/irrelevant-file.ts"` — Remove specific files from the bundle
- `--budget 12000` — Adjust token budget
- `--max-files 30` — Adjust file count ceiling

## When to use

- You've been working and discovered the real problem is in different files than initially bundled
- You want to add domain-specific keywords you learned from reading the code
- The initial bundle included files that turned out to be irrelevant
- You need a bigger or smaller budget than the initial activation

## Examples

```bash
# Feed back what you've learned
codeledger refine --learned "The issue is in the WebSocket reconnection logic, not the HTTP client"

# Add keywords discovered during investigation
codeledger refine --add-keywords "reconnect,backoff,heartbeat"

# Drop files that turned out to be irrelevant
codeledger refine --drop "src/services/auth.ts" --drop "src/utils/format.ts"

# Combine learning with keyword injection
codeledger refine --learned "Need to check error boundaries" --add-keywords "ErrorBoundary,fallback"
```

After refinement, re-read `.codeledger/active-bundle.md` for the updated file list and excerpts.
