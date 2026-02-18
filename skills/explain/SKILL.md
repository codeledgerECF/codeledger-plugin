---
name: explain
description: Show a detailed scoring breakdown for the current or a new context bundle. Reveals why each file was selected with per-signal scores (keyword, centrality, churn, recency, test relevance, size, priors, error infrastructure, branch changes). Use this to understand or debug file selection.
---

Run `codeledger bundle` with `--explain` to see a detailed scoring breakdown.

## What to run

```bash
codeledger bundle --task "$ARGUMENTS" --explain --near-misses
```

If no task is provided via `$ARGUMENTS`, regenerate the explanation for the current active bundle's task:

```bash
codeledger bundle --task "$(head -5 .codeledger/active-bundle.md | grep 'Task:' | sed 's/.*Task: //')" --explain --near-misses --blast-radius
```

## What the output shows

### Per-file scoring table
For each selected file, shows the individual signal scores:

| Signal | What it measures |
|--------|-----------------|
| keyword | Task keywords found in file path/content |
| centrality | How many other files import this file |
| churn | Git commit frequency (hot zones) |
| recent_touch | Time since last modification |
| test_relevance | Paired source/test relationship |
| size_penalty | Small files get a bonus (less token waste) |
| success_prior | Historical build success rate |
| fail_prior | Historical build failure rate |
| error_infrastructure | Error/validation class detection |
| branch_changed | Uncommitted or branch-diffed files |

### Near-misses
Files that almost made the cut, with:
- Their scores and ranks
- How many more tokens they'd need (budget gap)
- Suggested keywords that might include them

### Blast radius
For each selected file:
- Direct dependents (files that import it)
- Transitive dependents (indirect impact chain)
- Impacted tests (tests that exercise this code)

## Examples

```bash
# Full diagnostic for a task
codeledger bundle --task "Fix authentication flow" --explain --near-misses --blast-radius

# Just the scoring table
codeledger bundle --task "Add pagination" --explain
```
