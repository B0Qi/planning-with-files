---
name: planning-with-files
version: "2.13.0"
description: Implements Manus-style file-based planning with multi-task support. Uses .claude-plans/ directory with per-task isolation. Use when starting complex multi-step tasks, research projects, or any task requiring >5 tool calls. Now with automatic session recovery after /clear.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - WebFetch
  - WebSearch
hooks:
  PreToolUse:
    - matcher: "Write|Edit|Bash|Read|Glob|Grep"
      hooks:
        - type: command
          command: "cat .claude-plans/index.md 2>/dev/null | head -20 || true"
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "echo '[planning-with-files] File updated. If this completes a phase, update plan.md status in .claude-plans/'"
  Stop:
    - hooks:
        - type: command
          command: |
            SCRIPT_DIR="${CLAUDE_PLUGIN_ROOT:-$HOME/.claude/plugins/planning-with-files}/scripts"

            IS_WINDOWS=0
            if [ "${OS-}" = "Windows_NT" ]; then
              IS_WINDOWS=1
            else
              UNAME_S="$(uname -s 2>/dev/null || echo '')"
              case "$UNAME_S" in
                CYGWIN*|MINGW*|MSYS*) IS_WINDOWS=1 ;;
              esac
            fi

            if [ "$IS_WINDOWS" -eq 1 ]; then
              if command -v pwsh >/dev/null 2>&1; then
                pwsh -ExecutionPolicy Bypass -File "$SCRIPT_DIR/check-complete.ps1" 2>/dev/null ||
                powershell -ExecutionPolicy Bypass -File "$SCRIPT_DIR/check-complete.ps1" 2>/dev/null ||
                sh "$SCRIPT_DIR/check-complete.sh"
              else
                powershell -ExecutionPolicy Bypass -File "$SCRIPT_DIR/check-complete.ps1" 2>/dev/null ||
                sh "$SCRIPT_DIR/check-complete.sh"
              fi
            else
              sh "$SCRIPT_DIR/check-complete.sh"
            fi
---

# Planning with Files

Work like Manus: Use persistent markdown files as your "working memory on disk."

## FIRST: Check for Previous Session (v2.2.0)

**Before starting work**, check for unsynced context from a previous session:

```bash
# Linux/macOS
$(command -v python3 || command -v python) ${CLAUDE_PLUGIN_ROOT}/scripts/session-catchup.py "$(pwd)"
```

```powershell
# Windows PowerShell
& (Get-Command python -ErrorAction SilentlyContinue).Source "$env:USERPROFILE\.claude\skills\planning-with-files\scripts\session-catchup.py" (Get-Location)
```

If catchup report shows unsynced context:
1. Run `git diff --stat` to see actual code changes
2. Read current planning files in `.claude-plans/`
3. Update planning files based on catchup + git diff
4. Then proceed with task

## Directory Structure

All planning files live in `.claude-plans/` with per-task isolation:

```
.claude-plans/                    # Hidden directory, won't pollute project
├── index.md                      # Task index (active + history)
├── dark-mode-toggle/             # Task 1 directory
│   ├── plan.md                   # Task plan
│   ├── findings.md               # Research findings
│   └── progress.md               # Session log
└── fix-login-bug/                # Task 2 directory
    ├── plan.md
    ├── findings.md
    └── progress.md
```

## Quick Start

Before ANY complex task:

1. **Check `.claude-plans/index.md`** — See existing tasks or create new
2. **Create task directory** under `.claude-plans/[task-slug]/`
3. **Create `plan.md`** with goal and phases
4. **Re-read plan before decisions** — Refreshes goals in attention window
5. **Update after each phase** — Mark complete, log errors
6. **Update index.md** — When switching or completing tasks

Or invoke manually with `/planning-with-files` or `/plan`.

## The Core Pattern

```
Context Window = RAM (volatile, limited)
Filesystem = Disk (persistent, unlimited)

→ Anything important gets written to disk.
```

## The 3-File Pattern (Per Task)

For every non-trivial task, create THREE files in the task directory:

| File | Purpose | When to Update |
|------|---------|----------------|
| `plan.md` | Phases, progress, decisions | After each phase |
| `findings.md` | Research, discoveries | After ANY discovery |
| `progress.md` | Session log, test results | Throughout session |

## index.md Template

Create this file FIRST in `.claude-plans/`:

```markdown
# Task Index

## Active Tasks

| Task | Directory | Status | Started |
|------|-----------|--------|---------|
| Add dark mode toggle | `dark-mode-toggle/` | Phase 2/4 | 2025-01-08 |
| Fix login bug | `fix-login-bug/` | Phase 1/3 | 2025-01-09 |

## Current Focus
`dark-mode-toggle/` - Implementing toggle component

## Completed Tasks

| Task | Directory | Completed |
|------|-----------|-----------|
| Refactor auth module | `refactor-auth/` | 2025-01-07 |
```

## Critical Rules

### 1. Use .claude-plans/ Directory
All planning files go in `.claude-plans/`. Never pollute project root.

### 2. One Directory Per Task
Each task gets its own subdirectory with a descriptive slug.

### 3. Maintain index.md
Always update the index when starting or completing tasks.

### 4. Create Plan First
Never start a complex task without creating the task directory and `plan.md`.

### 5. The 2-Action Rule
> "After every 2 view/browser/search operations, IMMEDIATELY save key findings to text files."

### 6. Read Before Decide
Before major decisions, read the plan file. This keeps goals in your attention window.

### 7. Update After Act
After completing any phase:
- Mark phase status: `in_progress` → `complete`
- Log any errors encountered
- Note files created/modified

### 8. Log ALL Errors
Every error goes in the plan file. This builds knowledge and prevents repetition.

### 9. Never Repeat Failures
```
if action_failed:
    next_action != same_action
```

## The 3-Strike Error Protocol

```
ATTEMPT 1: Diagnose & Fix
  → Read error carefully
  → Identify root cause
  → Apply targeted fix

ATTEMPT 2: Alternative Approach
  → Same error? Try different method
  → NEVER repeat exact same failing action

ATTEMPT 3: Broader Rethink
  → Question assumptions
  → Search for solutions
  → Consider updating the plan

AFTER 3 FAILURES: Escalate to User
```

## Switching Between Tasks

```bash
# 1. Read index to see all tasks
Read .claude-plans/index.md

# 2. Switch to the relevant task
Read .claude-plans/[other-task]/plan.md

# 3. Update index's "Current Focus"
Edit .claude-plans/index.md
```

## Context Recovery After Session Reset

```bash
# 1. Check if plans exist
Read .claude-plans/index.md

# 2. Resume from current focus
Read .claude-plans/[active-task]/plan.md
```

## When to Use This Pattern

**Use for:**
- Multi-step tasks (3+ steps)
- Research tasks
- Building/creating projects
- Tasks spanning many tool calls
- Multiple concurrent tasks

**Skip for:**
- Simple questions
- Single-file edits
- Quick lookups

## Templates

- [templates/task_plan.md](templates/task_plan.md) — Phase tracking
- [templates/findings.md](templates/findings.md) — Research storage
- [templates/progress.md](templates/progress.md) — Session logging

## Scripts

- `scripts/init-session.sh` — Initialize planning files
- `scripts/check-complete.sh` — Verify phases complete
- `scripts/session-catchup.py` — Recover context from previous session

## Advanced Topics

- **Manus Principles:** See [reference.md](reference.md)
- **Real Examples:** See [examples.md](examples.md)

## Anti-Patterns

| Don't | Do Instead |
|-------|------------|
| Put plan files in project root | Use `.claude-plans/` directory |
| Use same files for all tasks | Create subdirectory per task |
| Forget to update index.md | Always maintain the index |
| Use TodoWrite for persistence | Create plan files |
| State goals once and forget | Re-read plan before decisions |
| Hide errors and retry silently | Log errors to plan file |
| Repeat failed actions | Track attempts, mutate approach |
