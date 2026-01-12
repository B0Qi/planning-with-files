# Changelog

All notable changes to this project will be documented in this file.

## [2.1.0] - 2026-01-09 (B0Qi Fork)

### Added

- **Multi-Task Support with `.claude-plans/` Directory**
  - All planning files now organized under `.claude-plans/` directory
  - Per-task subdirectories (e.g., `.claude-plans/dark-mode-toggle/`)
  - No more file conflicts between concurrent tasks
  - Hidden directory won't pollute project root

- **Task Index (`index.md`)**
  - Central entry point for all tasks
  - Tracks active tasks with status and start date
  - Records completed tasks for reference
  - "Current Focus" section for quick context recovery

- **Task Switching Workflow**
  - Seamless switching between multiple concurrent tasks
  - Read index → Switch task → Update focus
  - Context recovery after session reset

- **New Hooks from Upstream**
  - SessionStart hook: Notifies user when skill is loaded
  - PostToolUse hook: Reminds to update plan.md after Write/Edit
  - PreToolUse hook now reads `index.md` for task awareness

- **`user-invocable: true`**
  - Skill appears in slash command menu as `/planning-with-files`

### Changed

- File structure: `task_plan.md` → `.claude-plans/[task]/plan.md`
- File structure: `findings.md` → `.claude-plans/[task]/findings.md`
- File structure: `progress.md` → `.claude-plans/[task]/progress.md`
- Version bumped to 2.1.0

### Merged from Upstream (OthmanAdi)

- Documentation restructure with `docs/` folder
- Root-level `templates/` and `scripts/` for CLAUDE_PLUGIN_ROOT resolution
- `planning-with-files/` folder for plugin marketplace compatibility
- Cursor and Windows setup guides

### Preserved

- All v2.0.0 features (hooks, templates, scripts, 2-Action Rule, 3-Strike Protocol)
- Core 3-file pattern per task
- Cursor support

---

## Upstream Changes (OthmanAdi/planning-with-files)

### [2.1.2] - 2026-01-11

- Fixed template files not found in cache (Issue #18)
- Added `templates/` and `scripts/` at repo root level

### [2.1.1] - 2026-01-10

- Fixed plugin template path issue (Issue #15)
- Added `planning-with-files/` folder at root for plugin installs

### [2.1.0] - 2026-01-10

- Claude Code v2.1 compatibility
- `user-invocable: true` frontmatter
- SessionStart and PostToolUse hooks
- YAML list format for `allowed-tools`

### [2.0.1] - 2026-01-09

- Planning files now correctly created in project directory
- Added "Important: Where Files Go" section

---

## [2.0.0] - 2026-01-08

### Added

- **Hooks Integration** (Claude Code 2.1.0+)
  - `PreToolUse` hook: Automatically reads `task_plan.md` before Write/Edit/Bash operations
  - `Stop` hook: Verifies all phases are complete before stopping
  - Implements Manus "attention manipulation" principle automatically

- **Templates Directory**
  - `templates/task_plan.md` - Structured phase tracking template
  - `templates/findings.md` - Research and discovery storage template
  - `templates/progress.md` - Session logging with test results template

- **Scripts Directory**
  - `scripts/init-session.sh` - Initialize all planning files at once
  - `scripts/check-complete.sh` - Verify all phases are complete

- **New Documentation**
  - `CHANGELOG.md` - This file
  - `MIGRATION.md` - Guide for upgrading from v1.x

- **Enhanced SKILL.md**
  - The 2-Action Rule (save findings after every 2 view/browser operations)
  - The 3-Strike Error Protocol (structured error recovery)
  - Read vs Write Decision Matrix
  - The 5-Question Reboot Test

- **Expanded reference.md**
  - The 3 Context Engineering Strategies (Reduction, Isolation, Offloading)
  - The 7-Step Agent Loop diagram
  - Critical constraints section
  - Updated Manus statistics

### Changed

- SKILL.md restructured for progressive disclosure (<500 lines)
- Version bumped to 2.0.0 in all manifests
- README.md reorganized (Thank You section moved to top)
- Description updated to mention >5 tool calls threshold

### Preserved

- All v1.0.0 content available in `legacy` branch
- Original examples.md retained (proven patterns)
- Core 3-file pattern unchanged
- MIT License unchanged

## [1.0.0] - 2026-01-07

### Added

- Initial release
- SKILL.md with core workflow
- reference.md with 6 Manus principles
- examples.md with 4 real-world examples
- Plugin structure for Claude Code marketplace
- README.md with installation instructions

---

## Versioning

This project follows [Semantic Versioning](https://semver.org/):
- MAJOR: Breaking changes to skill behavior
- MINOR: New features, backward compatible
- PATCH: Bug fixes, documentation updates
