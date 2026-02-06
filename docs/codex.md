# Codex IDE Support

## Overview

`planning-with-files` works with Codex as a personal skill in `~/.codex/skills/planning-with-files/`.

This fork uses a multi-task planning layout in `.codex-plans/`.

## Quick Install

```bash
mkdir -p ~/.codex/skills/planning-with-files
cp -r .codex/skills/planning-with-files/* ~/.codex/skills/planning-with-files/
```

Or install directly from GitHub with Codex skill installer:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo B0Qi/planning-with-files \
  --path .codex/skills/planning-with-files
```

## Usage

Invoke in Codex with:

```text
$planning-with-files
```

For complex tasks:
1. Read `~/.codex/skills/planning-with-files/SKILL.md`.
2. Create and maintain `.codex-plans/index.md`.
3. Track each task in `.codex-plans/<task-slug>/` using `plan.md`, `findings.md`, `progress.md`.

## Verification

```bash
ls -la ~/.codex/skills/planning-with-files/SKILL.md
```

## Optional Helpers

```bash
# Initialize a task plan structure
~/.codex/skills/planning-with-files/scripts/init-session.sh my-task "My Task"

# Check completion status
~/.codex/skills/planning-with-files/scripts/check-complete.sh
```
