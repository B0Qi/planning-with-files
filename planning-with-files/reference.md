# Reference: Manus Context Engineering Principles

This skill is based on the context engineering principles from Manus, the AI agent company acquired by Meta for $2 billion in December 2025.

## Directory Structure Rationale

### Why `.claude-plans/`?

1. **Hidden directory** - Won't clutter project file listings
2. **Centralized location** - All planning in one place
3. **Git-friendly** - Can choose to `.gitignore` or commit
4. **Separation of concerns** - Planning files separate from project files

### Why Per-Task Directories?

1. **Isolation** - Multiple tasks don't interfere with each other
2. **Context switching** - Easy to switch between tasks
3. **History** - Completed tasks remain for reference
4. **Clean structure** - Each task is self-contained

### Why index.md?

1. **Entry point** - Quick overview of all tasks
2. **Current focus** - Know which task is active
3. **Task history** - See completed work
4. **Context recovery** - After session reset, read index first

## The 6 Manus Principles

### 1. Filesystem as External Memory

> "Markdown is my 'working memory' on disk."

**Problem:** Context windows have limits. Stuffing everything in context degrades performance and increases costs.

**Solution:** Treat the filesystem as unlimited memory:
- Store large content in files under `.claude-plans/[task]/`
- Keep only paths in context
- Agent can "look up" information when needed
- Compression must be REVERSIBLE

### 2. Attention Manipulation Through Repetition

**Problem:** After ~50 tool calls, models forget original goals ("lost in the middle" effect).

**Solution:** Keep a `plan.md` file that gets RE-READ throughout execution:
```
Start of context: [Original goal - far away, forgotten]
...many tool calls...
End of context: [Recently read plan.md - gets ATTENTION!]
```

By reading the plan file before each decision, goals appear in the attention window.

### 3. Keep Failure Traces

> "Error recovery is one of the clearest signals of TRUE agentic behavior."

**Problem:** Instinct says hide errors, retry silently. This wastes tokens and loses learning.

**Solution:** KEEP failed actions in the plan file:
```markdown
## Errors Encountered
- [2025-01-03] FileNotFoundError: config.json not found → Created default config
- [2025-01-03] API timeout → Retried with exponential backoff, succeeded
```

The model updates its internal understanding when seeing failures.

### 4. Avoid Few-Shot Overfitting

> "Uniformity breeds fragility."

**Problem:** Repetitive action-observation pairs cause drift and hallucination.

**Solution:** Introduce controlled variation:
- Vary phrasings slightly
- Don't copy-paste patterns blindly
- Recalibrate on repetitive tasks

### 5. Stable Prefixes for Cache Optimization

**Problem:** Agents are input-heavy (100:1 ratio). Every token costs money.

**Solution:** Structure for cache hits:
- Put static content FIRST
- Append-only context (never modify history)
- Consistent serialization

### 6. Append-Only Context

**Problem:** Modifying previous messages invalidates KV-cache.

**Solution:** NEVER modify previous messages. Always append new information.

## The Agent Loop

Manus operates in a continuous loop:

```
1. Analyze → 2. Think → 3. Select Tool → 4. Execute → 5. Observe → 6. Iterate → 7. Deliver
```

### File Operations in the Loop:

| Operation | When to Use | Path |
|-----------|-------------|------|
| `write` | New files or complete rewrites | `.claude-plans/[task]/` |
| `append` | Adding sections incrementally | `.claude-plans/[task]/notes.md` |
| `edit` | Updating specific parts (checkboxes, status) | `.claude-plans/[task]/plan.md` |
| `read` | Reviewing before decisions | `.claude-plans/[task]/plan.md` |

## Task Lifecycle

```
┌─────────────────────────────────────────────────────────────┐
│  1. START NEW TASK                                          │
│     Read .claude-plans/index.md                             │
│     Create .claude-plans/[task-slug]/plan.md                │
│     Update index.md with new task                           │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  2. WORK ON TASK                                            │
│     Read plan.md before each decision                       │
│     Store research in notes.md                              │
│     Update plan.md after each phase                         │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  3. COMPLETE TASK                                           │
│     Create deliverable.md                                   │
│     Update index.md (move to Completed)                     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  4. SWITCH TASK (if needed)                                 │
│     Read index.md                                           │
│     Read .claude-plans/[other-task]/plan.md                 │
│     Update index.md "Current Focus"                         │
└─────────────────────────────────────────────────────────────┘
```

## Context Recovery After Session Reset

When starting a new session:

```bash
# 1. Check if plans exist
Read .claude-plans/index.md

# 2. See current focus
# Index tells you which task was active

# 3. Resume that task
Read .claude-plans/[active-task]/plan.md

# 4. Continue from last status
```

This is why the directory structure matters - it survives session resets!

## Manus Statistics

| Metric | Value |
|--------|-------|
| Average tool calls per task | ~50 |
| Input-to-output ratio | 100:1 |
| Acquisition price | $2 billion |
| Time to $100M revenue | 8 months |

## Key Quotes

> "If the model improvement is the rising tide, we want Manus to be the boat, not the piling stuck on the seafloor."

> "For complex tasks, I save notes, code, and findings to files so I can reference them as I work."

> "I used file.edit to update checkboxes in my plan as I progressed, rather than rewriting the whole file."

## Source

Based on Manus's official context engineering documentation:
https://manus.im/de/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus
