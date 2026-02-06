# Examples: Planning with Files in Action

## Example 1: Research Task

**User Request:** "Research the benefits of morning exercise and write a summary"

### Loop 1: Create Index and Plan

```bash
# Check if index exists
Read .codex-plans/index.md  # Not found

# Create index and task directory
Write .codex-plans/index.md
Write .codex-plans/morning-exercise-research/plan.md
```

**.codex-plans/index.md:**
```markdown
# Task Index

## Active Tasks

| Task | Directory | Status | Started |
|------|-----------|--------|---------|
| Morning exercise research | `morning-exercise-research/` | Phase 1/4 | 2025-01-09 |

## Current Focus
`morning-exercise-research/` - Creating plan

## Completed Tasks
(none yet)
```

**.codex-plans/morning-exercise-research/plan.md:**
```markdown
# Task: Morning Exercise Benefits Research

## Goal
Create a research summary on the benefits of morning exercise.

## Phases
- [x] Phase 1: Create this plan
- [ ] Phase 2: Search and gather sources
- [ ] Phase 3: Synthesize findings
- [ ] Phase 4: Deliver summary

## Key Questions
1. What are the physical health benefits?
2. What are the mental health benefits?
3. What scientific studies support this?

## Status
**Currently in Phase 1** - Creating plan
```

### Loop 2: Research

```bash
Read .codex-plans/morning-exercise-research/plan.md   # Refresh goals
WebSearch "morning exercise benefits"
Write .codex-plans/morning-exercise-research/findings.md  # Store findings
Edit .codex-plans/morning-exercise-research/plan.md   # Mark Phase 2 complete
```

### Loop 3: Synthesize

```bash
Read .codex-plans/morning-exercise-research/plan.md   # Refresh goals
Read .codex-plans/morning-exercise-research/findings.md  # Get findings
Write .codex-plans/morning-exercise-research/deliverable.md
Edit .codex-plans/morning-exercise-research/plan.md   # Mark Phase 3 complete
```

### Loop 4: Deliver

```bash
Read .codex-plans/morning-exercise-research/plan.md   # Verify complete
Edit .codex-plans/index.md                            # Move to completed
Deliver .codex-plans/morning-exercise-research/deliverable.md
```

---

## Example 2: Bug Fix Task

**User Request:** "Fix the login bug in the authentication module"

### .codex-plans/index.md
```markdown
# Task Index

## Active Tasks

| Task | Directory | Status | Started |
|------|-----------|--------|---------|
| Fix login bug | `fix-login-bug/` | Phase 3/5 | 2025-01-09 |

## Current Focus
`fix-login-bug/` - Identifying root cause

## Completed Tasks

| Task | Directory | Completed |
|------|-----------|-----------|
| Morning exercise research | `morning-exercise-research/` | 2025-01-09 |
```

### .codex-plans/fix-login-bug/plan.md
```markdown
# Task: Fix Login Bug

## Goal
Identify and fix the bug preventing successful login.

## Phases
- [x] Phase 1: Understand the bug report
- [x] Phase 2: Locate relevant code
- [ ] Phase 3: Identify root cause (CURRENT)
- [ ] Phase 4: Implement fix
- [ ] Phase 5: Test and verify

## Key Questions
1. What error message appears?
2. Which file handles authentication?
3. What changed recently?

## Decisions Made
- Auth handler is in src/auth/login.ts
- Error occurs in validateToken() function

## Errors Encountered
- [Initial] TypeError: Cannot read property 'token' of undefined
  → Root cause: user object not awaited properly

## Status
**Currently in Phase 3** - Found root cause, preparing fix
```

---

## Example 3: Feature Development with Multiple Tasks

**User Request:** "Add a dark mode toggle to the settings page"

### .codex-plans/index.md (showing multiple tasks)
```markdown
# Task Index

## Active Tasks

| Task | Directory | Status | Started |
|------|-----------|--------|---------|
| Dark mode toggle | `dark-mode-toggle/` | Phase 3/5 | 2025-01-08 |
| Fix login bug | `fix-login-bug/` | Phase 4/5 | 2025-01-09 |

## Current Focus
`dark-mode-toggle/` - Building toggle component

## Completed Tasks

| Task | Directory | Completed |
|------|-----------|-----------|
| Morning exercise research | `morning-exercise-research/` | 2025-01-09 |
| Refactor auth module | `refactor-auth/` | 2025-01-07 |
```

### .codex-plans/dark-mode-toggle/plan.md
```markdown
# Task: Dark Mode Toggle

## Goal
Add functional dark mode toggle to settings.

## Phases
- [x] Phase 1: Research existing theme system
- [x] Phase 2: Design implementation approach
- [ ] Phase 3: Implement toggle component (CURRENT)
- [ ] Phase 4: Add theme switching logic
- [ ] Phase 5: Test and polish

## Decisions Made
- Using CSS custom properties for theme
- Storing preference in localStorage
- Toggle component in SettingsPage.tsx

## Status
**Currently in Phase 3** - Building toggle component
```

### .codex-plans/dark-mode-toggle/findings.md
```markdown
# Notes: Dark Mode Implementation

## Existing Theme System
- Located in: src/styles/theme.ts
- Uses: CSS custom properties
- Current themes: light only

## Files to Modify
1. src/styles/theme.ts - Add dark theme colors
2. src/components/SettingsPage.tsx - Add toggle
3. src/hooks/useTheme.ts - Create new hook
4. src/App.tsx - Wrap with ThemeProvider

## Color Decisions
- Dark background: #1a1a2e
- Dark surface: #16213e
- Dark text: #eaeaea
```

---

## Example 4: Switching Between Tasks

**User says:** "Actually, let's finish the login bug first"

### Workflow
```bash
# 1. Read index to see all tasks
Read .codex-plans/index.md

# 2. Switch to login bug task
Read .codex-plans/fix-login-bug/plan.md

# 3. Update index's Current Focus
Edit .codex-plans/index.md
# Change: Current Focus → `fix-login-bug/` - Implementing fix
```

### Updated .codex-plans/index.md
```markdown
# Task Index

## Active Tasks

| Task | Directory | Status | Started |
|------|-----------|--------|---------|
| Dark mode toggle | `dark-mode-toggle/` | Phase 3/5 | 2025-01-08 |
| Fix login bug | `fix-login-bug/` | Phase 4/5 | 2025-01-09 |

## Current Focus
`fix-login-bug/` - Implementing fix    ← CHANGED

## Completed Tasks
...
```

---

## Example 5: Error Recovery Pattern

When something fails, DON'T hide it:

### Before (Wrong)
```
Action: Read config.json
Error: File not found
Action: Read config.json  # Silent retry
Action: Read config.json  # Another retry
```

### After (Correct)
```
Action: Read config.json
Error: File not found

# Update .codex-plans/[task]/plan.md:
## Errors Encountered
- config.json not found → Will create default config

Action: Write config.json (default config)
Action: Read config.json
Success!
```

---

## Example 6: Context Recovery After Session Reset

**New session starts, user says:** "Continue working on my tasks"

### Workflow
```bash
# 1. Check if plans exist
Read .codex-plans/index.md

# Output shows:
# - Active: dark-mode-toggle (Phase 3/5), fix-login-bug (Phase 4/5)
# - Current Focus: fix-login-bug

# 2. Resume the active task
Read .codex-plans/fix-login-bug/plan.md

# Now I know:
# - Goal: Fix login bug
# - Currently in Phase 4: Implement fix
# - Root cause: user object not awaited

# 3. Continue from where we left off
```

---

## The Read-Before-Decide Pattern

**Always read your plan before major decisions:**

```
[Many tool calls have happened...]
[Context is getting long...]
[Original goal might be forgotten...]

→ Read .codex-plans/[task]/plan.md    # This brings goals back into attention!
→ Now make the decision                 # Goals are fresh in context
```

This is why Manus can handle ~50 tool calls without losing track. The plan file acts as a "goal refresh" mechanism.

---

## Directory Structure Summary

```
.codex-plans/
├── index.md                          # Always read first
├── morning-exercise-research/        # Completed task (kept for reference)
│   ├── plan.md
│   ├── notes.md
│   └── deliverable.md
├── fix-login-bug/                    # Active task
│   ├── plan.md
│   └── notes.md
├── dark-mode-toggle/                 # Active task (paused)
│   ├── plan.md
│   └── notes.md
└── refactor-auth/                    # Completed task
    ├── plan.md
    └── deliverable.md
```
