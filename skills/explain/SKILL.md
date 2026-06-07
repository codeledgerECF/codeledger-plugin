---
name: explain
description: Understand why CodeLedger selected the files it did. See the reasoning behind each inclusion, files that narrowly missed the cut, and the downstream impact of each selected file.
---

See the reasoning behind which files were selected for your task.

## What to run

```bash
codeledger bundle --task "$ARGUMENTS" --explain
```

## What the output shows

### Why each file was included
For each selected file, CodeLedger shows a plain-English explanation of why it ranked highly — task relevance, how central it is to the codebase, how recently it changed, whether a test file is paired with it, and more.

### Files that nearly made the cut
Files that were close to being included, with a note on what would have pushed them in — useful if you feel like a file is missing.

### Downstream impact
For each selected file, the files and tests that depend on it — so you know what else might be affected by your changes.

## Examples

```bash
# See the full reasoning for a task
codeledger bundle --task "Fix authentication flow" --explain

# Include nearly-selected files and impact analysis
codeledger bundle --task "Fix authentication flow" --explain --near-misses --blast-radius
```
