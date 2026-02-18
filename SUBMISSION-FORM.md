# Claude Plugin Submission Form — Draft Answers

Use these answers to fill out the submission form at the Claude Plugin Directory.

---

## Plugin Details

### Plugin Name

```
CodeLedger
```

### Plugin Description (50-100 words)

```
CodeLedger gives your AI coding agent the right files first. It scans your repo, builds a dependency graph, and scores every file across 10 weighted signals — keyword relevance, centrality, git churn, recency, test pairing, and more — then selects a minimal, ranked context bundle within a token budget. The plugin auto-activates on session start, reminds the agent to check the bundle before edits, preserves session progress across context compaction, and reports recall/precision metrics at session end. No cloud, no embeddings, no telemetry — fully local and deterministic.
```

### Is this plugin for Claude Code or Cowork?

```
Claude Code
```

---

## Plugin Submission

### (Option 1) Link to GitHub (preferred)

```
https://github.com/codeledgerECF/codeledger-plugin
```

> **Note:** The plugin lives in the `plugin/` directory of this repo. Before submission, either:
> 1. Publish the `plugin/` directory as its own repo at `codeledgerECF/codeledger-plugin`, OR
> 2. Point the form to this repo and note the `plugin/` subdirectory

---

## Submission Details

### Company/Organization URL

```
https://codeledger.dev
```

### Primary Contact Email

```
ash@connectwithash.com
```

---

## Plugin Examples (at least 3 use cases)

### Example 1: Feature Development on a Large Codebase

**Scenario:** A developer asks Claude Code to "Add pagination to the products API endpoint" in a 2,000-file monorepo.

**Without CodeLedger:** Claude reads 30-50 files exploring the codebase before finding the route handler, service layer, model, and test file — burning tokens and time.

**With CodeLedger:** The developer runs `/codeledger:activate Add pagination to the products API endpoint`. CodeLedger scores every file and delivers a ranked bundle of 8-12 files: the route handler, service, model, pagination utility, and test file — with code excerpts and dependency relationships. Claude starts editing from the first turn.

**Value:** 60-99% context reduction. The agent reaches the right files immediately instead of exploring.

---

### Example 2: Bug Fix in Unfamiliar Code

**Scenario:** A developer asks Claude Code to "Fix the race condition in session refresh" but doesn't know which files are involved.

**Without CodeLedger:** Claude has to search through the codebase, reading file after file, often going down wrong paths before finding the session management code.

**With CodeLedger:** `/codeledger:activate Fix the race condition in session refresh` matches "session" and "refresh" as keywords, identifies the session service via centrality analysis (it's imported by 15 other files), boosts recently-modified files via git churn, and includes the paired test file. The bundle comes with confidence scoring — if it's LOW, the developer is prompted to be more specific.

**Value:** Even on unfamiliar codebases, CodeLedger's multi-signal scoring finds the right files without manual navigation.

---

### Example 3: Session Continuity Across Context Compaction

**Scenario:** A developer is deep into a complex refactoring task. Claude Code compacts context to stay within limits, and the agent loses track of what was already done.

**Without CodeLedger:** After compaction, Claude may redo work, re-read files it already changed, or lose track of the overall task plan.

**With CodeLedger:** The PreCompact hook automatically writes `.codeledger/session-progress.md` — a ground-truth snapshot derived from git showing: commits made this session, files changed, uncommitted work, and bundle files not yet touched. After compaction, Claude reads this file and knows exactly where to pick up. At session end, `/codeledger:status` shows 89% recall and 67% precision.

**Value:** Zero wasted work after compaction. The agent re-orients from git truth, not compressed conversation memory.

---

### Example 4: Mid-Session Refinement

**Scenario:** A developer activated a bundle for "Fix authentication flow" but discovers mid-task that the real issue is in the WebSocket reconnection logic.

**Without CodeLedger:** The developer manually searches for WebSocket files, losing the context of what was already explored.

**With CodeLedger:** `/codeledger:refine The issue is in the WebSocket reconnection logic, not the HTTP client --add-keywords reconnect,backoff,heartbeat`. CodeLedger re-scores the bundle with the new context, drops irrelevant auth files, boosts WebSocket-related files, and writes an updated bundle — without starting from scratch.

**Value:** The bundle evolves as understanding deepens, keeping context tight and relevant throughout the session.

---

### Example 5: Monorepo Scope Restriction

**Scenario:** A developer works in a 50,000-file monorepo but only needs context from the `packages/api` service.

**Without CodeLedger:** Claude may accidentally suggest edits to files in `packages/web` or `packages/shared` that happen to match keywords but are in the wrong package.

**With CodeLedger:** `/codeledger:activate Refactor auth middleware --scope packages/api` constrains all candidate generation, dependency expansion, and test pairing to the `packages/api` prefix. The bundle stays entirely within scope.

**Value:** No cross-package pollution. In monorepos, scoping is the difference between a 12-file focused bundle and a 40-file noisy one.
