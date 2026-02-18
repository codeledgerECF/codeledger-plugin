---
name: bundle
description: Generate a context bundle and display it without writing to disk. Use this to preview what files CodeLedger would select for a task, or to get structured JSON output for further processing.
---

Run `codeledger bundle` to generate a context bundle and display it.

## What to run

```bash
codeledger bundle --task "$ARGUMENTS"
```

## Common options

- `--task "description"` — Task description (required)
- `--json` — Output structured JSON instead of markdown
- `--explain` — Include per-file scoring breakdown (keyword, centrality, churn, etc.)
- `--near-misses` — Show files that almost made the cut with their scores and budget gaps
- `--blast-radius` — Show dependents and impacted tests for each selected file
- `--scope "path/prefix"` — Restrict candidates to a path prefix
- `--budget 12000` — Token budget override
- `--max-files 30` — File count ceiling override
- `--expand` — Double the default budget
- `--layer-order` — Sort by architectural layer

## When to use this vs activate

- Use **bundle** to preview or inspect what CodeLedger would select, without writing `.codeledger/active-bundle.md`
- Use **activate** when you want to write the bundle to disk for the agent to consume
- Use `--json` with **bundle** to pipe structured output into other tools

## Examples

```bash
# Preview bundle for a task
codeledger bundle --task "Add user authentication"

# Full diagnostic view
codeledger bundle --task "Fix race condition in cache" --explain --near-misses --blast-radius

# JSON output for scripting
codeledger bundle --task "Refactor database layer" --json
```
