# Planning with Files

> **Work like Manus** — the AI agent company Meta just acquired for **$2 billion**.

A Claude Code skill that transforms your workflow to use persistent markdown files for planning, progress tracking, and knowledge storage — the exact pattern that made Manus worth billions.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-Skill-blue)](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/skills)

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=B0Qi/planning-with-files&type=Date)](https://star-history.com/#B0Qi/planning-with-files&Date)

---

## Why This Skill?

On December 29, 2025, [Meta acquired Manus for $2 billion](https://techcrunch.com/2025/12/29/meta-just-bought-manus-an-ai-startup-everyone-has-been-talking-about/). In just 8 months, Manus went from launch to $100M+ revenue. Their secret? **Context engineering**.

This skill implements Manus's core workflow pattern:

> "Markdown is my 'working memory' on disk. Since I process information iteratively and my active context has limits, Markdown files serve as scratch pads for notes, checkpoints for progress, building blocks for final deliverables."
> — Manus AI

## The Problem

Claude Code (and most AI agents) suffer from:

- **Volatile memory** — TodoWrite tool disappears on context reset
- **Goal drift** — After 50+ tool calls, original goals get forgotten
- **Hidden errors** — Failures aren't tracked, so the same mistakes repeat
- **Context stuffing** — Everything crammed into context instead of stored
- **Task confusion** — Multiple tasks use same files, causing conflicts

## The Solution: Organized Task Directories

All planning files live in `.claude-plans/` with per-task isolation:

```
.claude-plans/                    # Hidden directory, won't pollute project
├── index.md                      # Task index (active + history)
├── dark-mode-toggle/             # Task 1 directory
│   ├── plan.md                   # Task plan
│   ├── notes.md                  # Research notes
│   └── deliverable.md            # Final output
└── fix-login-bug/                # Task 2 directory
    ├── plan.md
    └── notes.md
```

### The 3-File Pattern (Per Task)

For every complex task, create THREE files in the task directory:

| File | Purpose | When to Update |
|------|---------|----------------|
| `plan.md` | Track phases and progress | After each phase |
| `notes.md` | Store findings and research | During research |
| `deliverable.md` | Final output | At completion |

### The Loop

```
1. Check/create .claude-plans/index.md
2. Create task directory with plan.md
3. Research → save to notes.md → update plan.md
4. Read notes.md → create deliverable → update plan.md
5. Deliver final output → update index.md
```

**Key insight:** By reading `plan.md` before each decision, goals stay in the attention window. This is how Manus handles ~50 tool calls without losing track.

## Installation

### Option 1: Clone directly (Recommended)

```bash
# Navigate to your Claude Code skills directory
cd ~/.claude/skills  # or your custom skills path

# Clone this skill
git clone git@github.com:B0Qi/planning-with-files.git
```

### Option 2: Manual installation

1. Download or copy the `planning-with-files` folder
2. Place it in your Claude Code skills directory:
   - macOS/Linux: `~/.claude/skills/`
   - Windows: `%USERPROFILE%\.claude\skills\`

### Verify Installation

In Claude Code, the skill will automatically activate when you:
- Start complex tasks
- Mention "planning", "organize", or "track progress"
- Ask for structured work

## Usage

Once installed, Claude will automatically:

1. **Check `index.md`** to see existing tasks or create new
2. **Create task directory** with `plan.md` for each new task
3. **Update progress** with checkboxes after each phase
4. **Store findings** in `notes.md` instead of stuffing context
5. **Log errors** for future reference
6. **Re-read plan** before major decisions
7. **Update index** when switching or completing tasks

### Example

**You:** "Research the benefits of TypeScript and write a summary"

**Claude creates:**

`.claude-plans/index.md`:
```markdown
# Task Index

## Active Tasks

| Task | Directory | Status | Started |
|------|-----------|--------|---------|
| TypeScript benefits research | `typescript-research/` | Phase 2/4 | 2025-01-09 |

## Current Focus
`typescript-research/` - Searching for sources
```

`.claude-plans/typescript-research/plan.md`:
```markdown
# Task: TypeScript Benefits Research

## Goal
Create a research summary on TypeScript benefits.

## Phases
- [x] Phase 1: Create plan ✓
- [ ] Phase 2: Research and gather sources (CURRENT)
- [ ] Phase 3: Synthesize findings
- [ ] Phase 4: Deliver summary

## Status
**Currently in Phase 2** - Searching for sources
```

Then continues through each phase, updating files as it goes.

## The Manus Principles

This skill implements these key context engineering principles:

| Principle | Implementation |
|-----------|----------------|
| Filesystem as memory | Store in `.claude-plans/`, not context |
| Task isolation | One directory per task |
| Attention manipulation | Re-read plan before decisions |
| Error persistence | Log failures in plan file |
| Goal tracking | Checkboxes show progress |
| Context recovery | Read index.md after session reset |

## File Structure

```
planning-with-files/
├── SKILL.md        # Core instructions (what Claude reads)
├── reference.md    # Manus principles deep dive
├── examples.md     # Real usage examples
└── README.md       # This file
```

## When to Use

**Use this pattern for:**
- Multi-step tasks (3+ steps)
- Research tasks
- Building/creating projects
- Tasks spanning many tool calls
- Multiple concurrent tasks
- Anything requiring organization

**Skip for:**
- Simple questions
- Single-file edits
- Quick lookups

## Acknowledgments

- **Manus AI** — For pioneering context engineering patterns that made this possible
- **Anthropic** — For Claude Code and the Agent Skills framework
- Based on [Context Engineering for AI Agents](https://manus.im/de/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)
- Original skill by [Ahmad Othman Ammar Adi](https://github.com/OthmanAdi)

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

MIT License — feel free to use, modify, and distribute.

---

**Maintainer:** [B0Qi](https://github.com/B0Qi)
