---
name: activate
description: Generate a context bundle for a task. Scans the repo if stale, scores every file across 10 signals (keyword, centrality, churn, recency, test relevance, size, priors, error infrastructure, branch changes), selects the most relevant files within a token budget, and writes the bundle to .codeledger/active-bundle.md. Use this when starting a new task or switching tasks.
---

Run `codeledger activate` to generate a targeted context bundle for the current task.

## What to run

```bash
codeledger activate --task "$ARGUMENTS"
```

If no task is provided via `$ARGUMENTS`, run without `--task` to warm the repo index:

```bash
codeledger activate --quiet --stale-after 3600
```

## Common options

- `--task "description"` — Task description for keyword matching (more specific = higher confidence)
- `--scope "packages/api"` — Restrict to a path prefix (monorepo support)
- `--branch-aware` — Boost uncommitted and branch-diffed files
- `--expand` — Double the default token budget for complex tasks
- `--budget 12000` — Set a specific token budget
- `--max-files 30` — Override the file count ceiling
- `--explain` — Include per-file scoring breakdown in the bundle
- `--near-misses` — Show files that almost made the cut
- `--blast-radius` — Show dependents and impacted tests for each bundle file
- `--layer-order` — Sort files by architectural layer (types → models → services → routes → tests)

## After activation

1. Read `.codeledger/active-bundle.md` for the ranked file list with scores, reasons, and code excerpts
2. Prioritize working within the bundled files — they were selected deterministically based on the task
3. If confidence is LOW, try a more specific task description or use `--expand`
4. Use `/codeledger:refine` mid-session if you learn new context

## Examples

```bash
# Feature work
codeledger activate --task "Add pagination to the products API endpoint"

# Bug fix with full diagnostics
codeledger activate --task "Fix null handling in getUserById" --explain --blast-radius

# Monorepo scoped activation
codeledger activate --task "Refactor auth middleware" --scope "packages/api"

# Branch-aware for work in progress
codeledger activate --task "Complete the migration to new logger" --branch-aware
```
