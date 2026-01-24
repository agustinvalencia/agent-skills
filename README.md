# Agent Skills

Personal collection of [Agent Skills](https://agentskills.io/) for AI coding assistants.

## Installation

Symlink to your personal skills directory:

```bash
# Link all skills
for skill in */; do
  ln -sf "$(pwd)/$skill" ~/.claude/skills/
done

# Or link individually
ln -s /path/to/agent-skills/weekly-review ~/.claude/skills/weekly-review
```

## Skills

| Skill | Description |
|-------|-------------|
| [start-day](./start-day/) | Morning briefing with focus, tasks, and intentions |
| [weekly-review](./weekly-review/) | Conduct a weekly review using mdvault |

## Structure

Each skill follows the [Agent Skills specification](https://agentskills.io/specification):

```
skill-name/
├── SKILL.md           # Required - frontmatter + instructions
├── references/        # Optional - additional documentation
├── scripts/           # Optional - executable code
└── assets/            # Optional - templates, data files
```

## Compatibility

These skills are designed for use with:
- Claude Code
- OpenAI Codex CLI
- Gemini CLI
- Cursor
- Any agent supporting the Agent Skills spec
