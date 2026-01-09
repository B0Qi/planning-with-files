# Planning with Files

> **Work like Manus** — the AI agent company Meta acquired for **$2 billion**.

A Claude Code plugin containing an [Agent Skill](https://code.claude.com/docs/en/skills) that transforms your workflow to use persistent markdown files for planning, progress tracking, and knowledge storage — the exact pattern that made Manus worth billions.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-blue)](https://code.claude.com/docs/en/plugins)
[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-Skill-green)](https://code.claude.com/docs/en/skills)
[![Cursor Rules](https://img.shields.io/badge/Cursor-Rules-purple)](https://docs.cursor.com/context/rules-for-ai)
[![Version](https://img.shields.io/badge/version-2.1.0-brightgreen)](https://github.com/B0Qi/planning-with-files/releases)

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=B0Qi/planning-with-files&type=Date)](https://star-history.com/#B0Qi/planning-with-files&Date)

---

## What's New in v2.1.0

- **Multi-Task Support** — `.claude-plans/` directory with per-task isolation
- **Task Index** — `index.md` tracks all active and completed tasks
- **Task Switching** — Seamlessly switch between multiple concurrent tasks
- **Hooks Integration** — Automatic plan re-reading and completion verification
- **Templates & Scripts** — Structured templates and helper scripts
- **Enhanced Documentation** — 2-Action Rule, 3-Strike Protocol, 5-Question Reboot Test

See [CHANGELOG.md](CHANGELOG.md) for details.

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
│   ├── findings.md               # Research findings
│   └── progress.md               # Session log
└── fix-login-bug/                # Task 2 directory
    ├── plan.md
    ├── findings.md
    └── progress.md
```

### The 3-File Pattern (Per Task)

For every complex task, create THREE files in the task directory:

| File | Purpose | When to Update |
|------|---------|----------------|
| `plan.md` | Track phases and progress | After each phase |
| `findings.md` | Store research and findings | After ANY discovery |
| `progress.md` | Session log and test results | Throughout session |

### The Core Principle

```
Context Window = RAM (volatile, limited)
Filesystem = Disk (persistent, unlimited)

→ Anything important gets written to disk.
```

**Key insight:** By reading `plan.md` before each decision, goals stay in the attention window. This is how Manus handles ~50 tool calls without losing track.

<details>
<summary><strong>Workflow Diagram</strong> (click to expand)</summary>

```
┌─────────────────────────────────────────────────────────────────┐
│                    TASK START                                    │
│  User requests a complex task (>5 tool calls expected)          │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
         ┌───────────────────────────────┐
         │  Check .claude-plans/index.md  │
         │  Create task directory         │
         └───────────────┬───────────────┘
                         │
                         ▼
         ┌───────────────────────────────┐
         │  Create plan.md, findings.md,  │
         │  progress.md in task directory │
         └───────────────┬───────────────┘
                         │
                         ▼
    ┌────────────────────────────────────────────┐
    │         WORK LOOP (Iterative)              │
    │                                            │
    │  ┌──────────────────────────────────────┐ │
    │  │  PreToolUse Hook (Automatic)         │ │
    │  │  → Reads index.md before            │ │
    │  │    Write/Edit/Bash operations       │ │
    │  └──────────────┬───────────────────────┘ │
    │                 │                          │
    │                 ▼                          │
    │  ┌──────────────────────────────────────┐ │
    │  │  Perform work (tool calls)          │ │
    │  │  - Research → Update findings.md    │ │
    │  │  - Implement → Update progress.md    │ │
    │  └──────────────┬───────────────────────┘ │
    │                 │                          │
    │                 ▼                          │
    │  ┌──────────────────────────────────────┐ │
    │  │  After completing a phase:            │ │
    │  │  → Update plan.md status             │ │
    │  │  → Update index.md if needed         │ │
    │  └──────────────┬───────────────────────┘ │
    │                 │                          │
    │                 └──────────┐               │
    │                            │               │
    │              ┌─────────────▼────────┐     │
    │              │  More work to do?    │     │
    │              └──────┬───────────────┘     │
    │              YES ───┘                     │
    └─────────────────────────────────────────┘
                         │
                        NO
                         │
                         ▼
         ┌──────────────────────────────────────┐
         │  Update index.md (mark complete)     │
         │  Deliver final output                │
         └──────────────────────────────────────┘
```

</details>

## Installation

### As a Claude Code Plugin (Recommended)

Clone into your project's `.claude/plugins/` directory:

```bash
mkdir -p .claude/plugins
git clone git@github.com:B0Qi/planning-with-files.git .claude/plugins/planning-with-files
```

### Global Skills Installation

Copy the `skills/` directory contents into your `.claude/skills/` folder:

```bash
git clone git@github.com:B0Qi/planning-with-files.git
cp -r planning-with-files/skills/* ~/.claude/skills/
```

### Cursor Installation

Copy the `.cursor/rules/` directory into your project:

```bash
git clone git@github.com:B0Qi/planning-with-files.git
cp -r planning-with-files/.cursor .cursor
```

> **Note:** Hooks (PreToolUse, Stop) are Claude Code specific and won't work in Cursor. The core planning workflow still applies.

## Usage

Once installed, Claude will automatically:

1. **Check `.claude-plans/index.md`** to see existing tasks or create new
2. **Create task directory** with `plan.md` for each new task
3. **Re-read plan** before major decisions (via hooks)
4. **Update progress** with checkboxes after each phase
5. **Store findings** in `findings.md` instead of stuffing context
6. **Log errors** for future reference
7. **Update index** when switching or completing tasks

### Key Rules

1. **Use .claude-plans/ Directory** — All planning files go there
2. **One Directory Per Task** — No file conflicts between tasks
3. **Maintain index.md** — Always update when starting/completing tasks
4. **The 2-Action Rule** — Save findings after every 2 view/browser operations
5. **Log ALL Errors** — They help avoid repetition

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
- [x] Phase 1: Create plan
- [ ] Phase 2: Research and gather sources (CURRENT)
- [ ] Phase 3: Synthesize findings
- [ ] Phase 4: Deliver summary

## Status
**Currently in Phase 2** - Searching for sources
```

Then continues through each phase, updating files as it goes.

### Switching Between Tasks

When you need to work on a different task:

```bash
# Claude reads index to see all tasks
Read .claude-plans/index.md

# Switches to the other task
Read .claude-plans/fix-login-bug/plan.md

# Updates index's Current Focus
Edit .claude-plans/index.md
```

## The Manus Principles

This skill implements these key context engineering principles:

| Principle | Implementation |
|-----------|----------------|
| Filesystem as memory | Store in `.claude-plans/`, not context |
| Task isolation | One directory per task |
| Attention manipulation | Re-read plan before decisions (hooks) |
| Error persistence | Log failures in plan file |
| Goal tracking | Checkboxes show progress |
| Context recovery | Read index.md after session reset |

## File Structure

```
planning-with-files/
├── .claude-plugin/
│   ├── plugin.json          # Plugin manifest
│   └── marketplace.json     # Marketplace listing
├── .cursor/
│   └── rules/
│       └── planning-with-files.mdc  # Cursor rules file
├── skills/
│   └── planning-with-files/
│       ├── SKILL.md         # Main skill definition
│       ├── reference.md     # Manus principles
│       ├── examples.md      # Usage examples
│       ├── templates/       # File templates
│       │   ├── task_plan.md
│       │   ├── findings.md
│       │   └── progress.md
│       └── scripts/         # Helper scripts
│           ├── init-session.sh
│           └── check-complete.sh
├── examples/                # Extended examples
├── CHANGELOG.md             # Version history
├── MIGRATION.md             # Upgrade guide
├── LICENSE
└── README.md
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

## Community Forks

Extensions built by the community:

| Fork | Author | Features |
|------|--------|----------|
| [multi-manus-planning](https://github.com/kmichels/multi-manus-planning) | [@kmichels](https://github.com/kmichels) | Multi-project support, separate planning/source paths, SessionStart git sync |

*Built something? Open an issue to get listed!*

## Acknowledgments

- **Manus AI** — For pioneering context engineering patterns
- **Anthropic** — For Claude Code, Agent Skills, and the Plugin system
- **Lance Martin** — For the detailed Manus architecture analysis
- Based on [Context Engineering for AI Agents](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)
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
