---
name: planning-with-files
description: Transforms workflow to use Manus-style persistent markdown files for planning, progress tracking, and knowledge storage. Use when starting complex tasks, multi-step projects, research tasks, or when the user mentions planning, organizing work, tracking progress, or wants structured output.
---

# Planning with Files

Work like Manus: Use persistent markdown files as your "working memory on disk."

## Quick Start

Before ANY complex task:

1. **Check `.claude-plans/index.md`** - see existing tasks or create new
2. **Create task directory** under `.claude-plans/[task-slug]/`
3. **Create `plan.md`** with goal and phases
4. **Update after each phase** - mark [x] and change status
5. **Read before deciding** - refresh goals in attention window

## Directory Structure

All planning files live in `.claude-plans/` (hidden, won't pollute project):

```
.claude-plans/
├── index.md                      # Task index (active + history)
├── dark-mode-toggle/             # Task 1 directory
│   ├── plan.md                   # Task plan
│   ├── notes.md                  # Research notes
│   └── deliverable.md            # Final output
└── fix-login-bug/                # Task 2 directory
    ├── plan.md
    └── notes.md
```

## The 3-File Pattern (Per Task)

For every non-trivial task, create THREE files in the task directory:

| File | Purpose | When to Update |
|------|---------|----------------|
| `plan.md` | Track phases and progress | After each phase |
| `notes.md` | Store findings and research | During research |
| `deliverable.md` | Final output | At completion |

## Core Workflow

```
Loop 1: Create/update index.md → create task directory → create plan.md
Loop 2: Research → save to notes.md → update plan.md
Loop 3: Read notes.md → create deliverable → update plan.md
Loop 4: Deliver final output → update index.md (mark complete)
```

### Starting a New Task

```bash
# 1. Check or create index
Read .claude-plans/index.md       # If exists
# OR
Write .claude-plans/index.md      # If first task

# 2. Create task directory and plan
Write .claude-plans/[task-slug]/plan.md

# 3. Update index with new task
Edit .claude-plans/index.md
```

### The Loop in Detail

**Before each major action:**
```bash
Read .claude-plans/[task-slug]/plan.md  # Refresh goals in attention window
```

**After each phase:**
```bash
Edit .claude-plans/[task-slug]/plan.md  # Mark [x], update status
```

**When storing information:**
```bash
Write .claude-plans/[task-slug]/notes.md  # Don't stuff context, store in file
```

**When completing a task:**
```bash
Edit .claude-plans/index.md  # Move task to completed section
```

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

## plan.md Template

Create this file in each task directory:

```markdown
# Task: [Brief Description]

## Goal
[One sentence describing the end state]

## Phases
- [ ] Phase 1: Plan and setup
- [ ] Phase 2: Research/gather information
- [ ] Phase 3: Execute/build
- [ ] Phase 4: Review and deliver

## Key Questions
1. [Question to answer]
2. [Question to answer]

## Decisions Made
- [Decision]: [Rationale]

## Errors Encountered
- [Error]: [Resolution]

## Status
**Currently in Phase X** - [What I'm doing now]
```

## notes.md Template

For research and findings:

```markdown
# Notes: [Topic]

## Sources

### Source 1: [Name]
- URL: [link]
- Key points:
  - [Finding]
  - [Finding]

## Synthesized Findings

### [Category]
- [Finding]
- [Finding]
```

## Critical Rules

### 1. Use .claude-plans/ Directory
All planning files go in `.claude-plans/`. Never pollute project root with plan files.

### 2. One Directory Per Task
Each task gets its own subdirectory with a descriptive slug (e.g., `fix-login-bug/`, `add-dark-mode/`).

### 3. Maintain index.md
Always update the index when starting or completing tasks. This is your entry point.

### 4. Read Before Decide
Before any major decision, read the plan file. This keeps goals in your attention window.

### 5. Update After Act
After completing any phase, immediately update the plan file:
- Mark completed phases with [x]
- Update the Status section
- Log any errors encountered

### 6. Store, Don't Stuff
Large outputs go to files, not context. Keep only paths in working memory.

### 7. Log All Errors
Every error goes in the "Errors Encountered" section. This builds knowledge for future tasks.

## Switching Between Tasks

When user switches context or asks about a different task:

```bash
# 1. Read index to see all tasks
Read .claude-plans/index.md

# 2. Switch to the relevant task
Read .claude-plans/[other-task]/plan.md

# 3. Update index's "Current Focus"
Edit .claude-plans/index.md
```

## When to Use This Pattern

**Use 3-file pattern for:**
- Multi-step tasks (3+ steps)
- Research tasks
- Building/creating something
- Tasks spanning multiple tool calls
- Anything requiring organization

**Skip for:**
- Simple questions
- Single-file edits
- Quick lookups

## Anti-Patterns to Avoid

| Don't | Do Instead |
|-------|------------|
| Put plan files in project root | Use `.claude-plans/` directory |
| Use same file for all tasks | Create subdirectory per task |
| Forget to update index.md | Always maintain the index |
| Use TodoWrite for persistence | Create plan files |
| State goals once and forget | Re-read plan before each decision |
| Hide errors and retry | Log errors to plan file |
| Stuff everything in context | Store large content in files |
| Start executing immediately | Create plan file FIRST |

## Advanced Patterns

See [reference.md](reference.md) for:
- Attention manipulation techniques
- Error recovery patterns
- Context optimization from Manus

See [examples.md](examples.md) for:
- Real task examples
- Complex workflow patterns
