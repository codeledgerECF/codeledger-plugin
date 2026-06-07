---
name: bundle
description: Preview which files CodeLedger would select for a task before committing to it. See the ranked results, understand the selections, and optionally get JSON output for scripting.
---

See which files CodeLedger considers most relevant for a task — without changing anything.

## What to run

```bash
codeledger bundle --task "$ARGUMENTS"
```

## Common options

- `--task "description"` — What you're working on (required)
- `--json` — Structured JSON output for scripting
- `--explain` — Show why each file was selected
- `--scope "path/prefix"` — Limit to a specific folder
- `--expand` — Cast a wider net
- `--layer-order` — Order files from foundational types through to tests

## bundle vs activate

- Use **bundle** to preview results without changing anything — good for checking before you commit to a direction
- Use **activate** when you're ready to start working and want the full experience

## Examples

```bash
# Preview file selection for a task
codeledger bundle --task "Add user authentication"

# See why each file was included
codeledger bundle --task "Fix race condition in cache" --explain

# JSON output for scripting
codeledger bundle --task "Refactor database layer" --json
```
