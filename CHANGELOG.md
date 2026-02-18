# Changelog

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
