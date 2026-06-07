---
name: activate
description: Get the right files for your task instantly. CodeLedger analyzes your codebase and surfaces the most relevant files — so your agent starts editing right away instead of exploring.
---

Tell CodeLedger what you're working on and it finds the files that matter.

## What to run

```bash
codeledger activate --task "$ARGUMENTS"
```

## Common options

- `--task "description"` — What you're trying to do (more specific = better results)
- `--scope "packages/api"` — Stay inside a specific folder (great for monorepos)
- `--branch-aware` — Prioritize files you've already changed on this branch
- `--expand` — Cast a wider net for complex tasks
- `--explain` — Show why each file was included
- `--layer-order` — Order files from foundational types through to tests

## What you get

A focused, ranked list of the files most likely to matter for your task — with code excerpts ready to read. Your agent starts from the right place instead of reading dozens of files to find the handful it actually needs.

If confidence comes back LOW, try a more specific task description or add `--expand`.

## Examples

```bash
# Feature work
codeledger activate --task "Add pagination to the products API endpoint"

# Bug fix
codeledger activate --task "Fix null handling in getUserById"

# Monorepo — stay in one package
codeledger activate --task "Refactor auth middleware" --scope "packages/api"

# Prioritize files already changed on this branch
codeledger activate --task "Complete the migration to new logger" --branch-aware
```
