# Changelog

## 0.3.0 (2026-02-18)

Cowork integration and go-to-market update.

### Added
- **Cowork session lifecycle** — Full session management for long-running, multi-step tasks
- **`/codeledger:cowork-start`** — Start a Cowork session with knowledge-scored context selection
- **`/codeledger:cowork-refresh`** — Re-score the bundle mid-session when focus shifts
- **`/codeledger:cowork-snapshot`** — Write a progress snapshot for session continuity
- **PreCompact Cowork hook** — Automatically snapshots Cowork state before context compaction
- **Knowledge scoring mode** — Optimized signal weights for codebase understanding tasks

### Changed
- **README rewritten for GTM** — Quality metrics (100% recall, 62.5% precision), two-mode messaging, install quickstart, architecture diagram
- **Plugin manifest v0.3.0** — Added Cowork keywords (cowork, session-continuity, knowledge-scoring, context-governor)

## 0.2.1 (2026-02-18)

### Fixed
- Requires CLI v0.2.1 — adds early `--agentCmd`/`--guided` validation to `compare` and `run` commands so missing agent configuration is caught before execution begins

## 0.2.0 (2026-02-18)

Initial plugin release for the Claude Code Plugin Directory.

### Added
- **SessionStart hook** — Auto-initializes CodeLedger and warms the repo index on session start
- **PreToolUse hook** — Reminds the agent to check the active context bundle before editing files
- **PreCompact hook** — Writes a ground-truth session progress snapshot before context compaction
- **Stop hook** — Shows session-end recall/precision metrics and cleanup
- **`/codeledger:activate`** — Generate a context bundle for a task (scan + score + select + write)
- **`/codeledger:bundle`** — Preview a bundle without writing to disk, with JSON output support
- **`/codeledger:refine`** — Mid-session bundle refinement with learned context and keyword injection
- **`/codeledger:status`** — Check session metrics (recall, precision, token savings, progress)
- **`/codeledger:explain`** — Detailed per-file scoring breakdown with near-misses and blast radius
