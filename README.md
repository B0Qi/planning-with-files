# Planning with Files

> **Work like Manus** — the AI agent company Meta acquired for **$2 billion**.

A Claude Code plugin that transforms your workflow to use persistent markdown files for planning, progress tracking, and knowledge storage — the exact pattern that made Manus worth billions.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-blue)](https://code.claude.com/docs/en/plugins)
[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-Skill-green)](https://code.claude.com/docs/en/skills)
[![Cursor Rules](https://img.shields.io/badge/Cursor-Rules-purple)](https://docs.cursor.com/context/rules-for-ai)
[![Version](https://img.shields.io/badge/version-2.1.0-brightgreen)](https://github.com/B0Qi/planning-with-files/releases)

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=B0Qi/planning-with-files&type=Date)](https://star-history.com/#B0Qi/planning-with-files&Date)

---

## Quick Install

```bash
mkdir -p .claude/plugins
git clone git@github.com:B0Qi/planning-with-files.git .claude/plugins/planning-with-files
```

See [docs/installation.md](docs/installation.md) for all installation methods.

## Documentation

| Document | Description |
|----------|-------------|
| [Installation Guide](docs/installation.md) | All installation methods (plugin, manual, Cursor, Windows) |
| [Quick Start](docs/quickstart.md) | 5-step guide to using the pattern |
| [Workflow Diagram](docs/workflow.md) | Visual diagram of how files and hooks interact |
| [Troubleshooting](docs/troubleshooting.md) | Common issues and solutions |
| [Cursor Setup](docs/cursor.md) | Cursor IDE-specific instructions |
| [Windows Setup](docs/windows.md) | Windows-specific notes |

## Versions

| Version | Features | Install |
|---------|----------|---------|
| **v2.1.0** (current) | Multi-task support, `.claude-plans/` directory, task index | `git clone git@github.com:B0Qi/planning-with-files.git` |
| **v2.0.x** | Hooks, templates, scripts | See upstream |
| **v1.0.0** (legacy) | Core 3-file pattern | `git clone -b legacy` |

See [CHANGELOG.md](CHANGELOG.md) for details.

## Why This Skill?

On December 29, 2025, [Meta acquired Manus for $2 billion](https://techcrunch.com/2025/12/29/meta-just-bought-manus-an-ai-startup-everyone-has-been-talking-about/). In just 8 months, Manus went from launch to $100M+ revenue. Their secret? **Context engineering**.

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

## Usage

Once installed, Claude will automatically:

1. **Check `.claude-plans/index.md`** to see existing tasks or create new
2. **Create task directory** with `plan.md` for each new task
3. **Re-read plan** before major decisions (via PreToolUse hook)
4. **Remind you** to update status after file writes (via PostToolUse hook)
5. **Store findings** in `findings.md` instead of stuffing context
6. **Log errors** for future reference
7. **Update index** when switching or completing tasks

Or invoke manually with `/planning-with-files`.

See [docs/quickstart.md](docs/quickstart.md) for the full 5-step guide.

## Key Rules

1. **Use .claude-plans/ Directory** — All planning files go there
2. **One Directory Per Task** — No file conflicts between tasks
3. **Maintain index.md** — Always update when starting/completing tasks
4. **The 2-Action Rule** — Save findings after every 2 view/browser operations
5. **Log ALL Errors** — They help avoid repetition

## File Structure

```
planning-with-files/
├── templates/               # Root-level templates (for CLAUDE_PLUGIN_ROOT)
├── scripts/                 # Root-level scripts (for CLAUDE_PLUGIN_ROOT)
├── docs/                    # Documentation
│   ├── installation.md
│   ├── quickstart.md
│   ├── workflow.md
│   ├── troubleshooting.md
│   ├── cursor.md
│   └── windows.md
├── planning-with-files/     # Plugin skill folder
│   ├── SKILL.md
│   ├── templates/
│   └── scripts/
├── skills/                  # Skills folder (with multi-task support)
│   └── planning-with-files/
│       ├── SKILL.md
│       ├── reference.md
│       ├── examples.md
│       ├── templates/
│       └── scripts/
├── .claude-plugin/          # Plugin manifest
├── .cursor/                 # Cursor rules
├── CHANGELOG.md
├── MIGRATION.md
├── LICENSE
└── README.md
```

## The Manus Principles

| Principle | Implementation |
|-----------|----------------|
| Filesystem as memory | Store in `.claude-plans/`, not context |
| Task isolation | One directory per task |
| Attention manipulation | Re-read plan before decisions (hooks) |
| Error persistence | Log failures in plan file |
| Goal tracking | Checkboxes show progress |
| Context recovery | Read index.md after session reset |

## When to Use

**Use this pattern for:**
- Multi-step tasks (3+ steps)
- Research tasks
- Building/creating projects
- Tasks spanning many tool calls
- Multiple concurrent tasks

**Skip for:**
- Simple questions
- Single-file edits
- Quick lookups

## Community Forks

| Fork | Author | Features |
|------|--------|----------|
| [multi-manus-planning](https://github.com/kmichels/multi-manus-planning) | [@kmichels](https://github.com/kmichels) | Multi-project support, SessionStart git sync |

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
