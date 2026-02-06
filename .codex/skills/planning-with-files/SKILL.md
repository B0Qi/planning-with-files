---
name: planning-with-files
description: Implements Manus-style file-based planning with multi-task support for Codex. Uses .codex-plans/ with task index and per-task plan.md, findings.md, and progress.md files. Use for complex multi-step tasks, research projects, or tasks requiring more than 5 tool calls.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - WebFetch
  - WebSearch
metadata:
  short-description: Multi-task file planning for Codex
---

# Planning with Files (Codex)

Use persistent markdown files as working memory on disk.

## Important for Codex

Codex skills do not run Claude-style hooks automatically.

You must do these steps manually:
1. Re-read `.codex-plans/index.md` and current `plan.md` before major decisions.
2. After each phase, update `plan.md`, `findings.md`, and `progress.md`.
3. Before ending the task, run `scripts/check-complete.sh` (or `.ps1`).

## First: Session Catchup

Before starting work, check for unsynced context:

```bash
$(command -v python3 || command -v python) ~/.codex/skills/planning-with-files/scripts/session-catchup.py "$(pwd)"
```

```powershell
python "$env:USERPROFILE\.codex\skills\planning-with-files\scripts\session-catchup.py" (Get-Location)
```

If catchup reports unsynced context:
1. Run `git diff --stat`.
2. Read `.codex-plans/index.md` and the active task files.
3. Sync the files before continuing.

## Directory Structure

All planning files live in `.codex-plans/`:

```text
.codex-plans/
├── index.md
├── dark-mode-toggle/
│   ├── plan.md
│   ├── findings.md
│   └── progress.md
└── fix-login-bug/
    ├── plan.md
    ├── findings.md
    └── progress.md
```

## Quick Start

Before any complex task:
1. Read or create `.codex-plans/index.md`.
2. Create `.codex-plans/<task-slug>/`.
3. Create `plan.md`, `findings.md`, and `progress.md` in that task directory.
4. Update index `Current Focus` to the task slug.
5. Re-read plan before major decisions.
6. Update files after each phase.

Manual invocation: `$planning-with-files`

## Core Pattern

```text
Context Window = RAM (volatile, limited)
Filesystem = Disk (persistent, unlimited)

Anything important gets written to disk.
```

## File Roles

| File | Purpose | Update When |
|------|---------|-------------|
| `index.md` | Active/completed task registry | Start, switch, complete |
| `plan.md` | Goal, phases, decisions, errors | After each phase |
| `findings.md` | Research and discoveries | After any discovery |
| `progress.md` | Session log and test evidence | Throughout task |

## index.md Template

Use `assets/templates/index.md` as your base.

## Critical Rules

### 1. Use `.codex-plans/`
Do not put planning files in the project root.

### 2. One Directory Per Task
Each task has its own subdirectory and 3 files.

### 3. Maintain `index.md`
Always update Active Tasks, Current Focus, and Completed Tasks.

### 4. Create Plan First
Do not start complex work without a `plan.md`.

### 5. The 2-Action Rule
After every 2 view/browser/search operations, immediately write findings to disk.

### 6. Read Before Decide
Re-read the current `plan.md` before major decisions.

### 7. Update After Act
After each phase, update status and note changed files.

### 8. Log Every Error
Every error goes into `plan.md`.

### 9. Never Repeat Failures
```text
if action_failed:
    next_action != same_action
```

## 3-Strike Error Protocol

```text
ATTEMPT 1: Diagnose and fix root cause.
ATTEMPT 2: Use a different approach or tool.
ATTEMPT 3: Rethink assumptions and search broader.
AFTER 3 FAILURES: Escalate to user with what was tried.
```

## Switching Tasks

```bash
Read .codex-plans/index.md
Read .codex-plans/<other-task>/plan.md
Edit .codex-plans/index.md  # update Current Focus
```

## Context Recovery

```bash
Read .codex-plans/index.md
Read .codex-plans/<active-task>/plan.md
```

## When to Use

Use for:
- Multi-step tasks (3+ steps)
- Research tasks
- Builds/refactors spanning many tool calls
- Multiple concurrent tasks

Skip for:
- Simple questions
- Small one-file edits
- Quick lookups

## Templates

- `assets/templates/index.md`
- `assets/templates/plan.md`
- `assets/templates/findings.md`
- `assets/templates/progress.md`

## Scripts

- `scripts/init-session.sh` / `scripts/init-session.ps1`
  Usage: initialize `.codex-plans/` and a task directory.
- `scripts/check-complete.sh` / `scripts/check-complete.ps1`
  Usage: verify all phases in active `plan.md` are complete.
- `scripts/session-catchup.py`
  Usage: recover unsynced context from previous session logs.

## References

- `references/reference.md` - Context engineering principles
- `references/examples.md` - End-to-end examples

## Anti-Patterns

| Don't | Do Instead |
|------|-------------|
| Put plans in project root | Use `.codex-plans/` |
| Mix multiple tasks in one plan | One task directory each |
| Forget index updates | Maintain `index.md` |
| Repeat same failing action | Log attempts and mutate approach |
| Keep findings only in context | Write to `findings.md` |
