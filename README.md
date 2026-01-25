# Agent Skills

ADHD-friendly [Agent Skills](https://agentskills.io/) for productivity and organization.

Designed for researchers, knowledge workers, and anyone juggling multiple projects with an ADHD brain.

## Philosophy

These skills follow [ADHD-friendly principles](./references/ADHD-PRINCIPLES.md):

- **One thing at a time** - Never overwhelm with long lists
- **Celebrate wins first** - Dopamine before problems
- **Compassionate accountability** - No shame, no guilt
- **Low friction** - Make starting easy
- **External memory** - The vault remembers so you don't have to

## Installation

Symlink to your personal skills directory:

```bash
# Link all skills
for skill in */; do
  [[ -d "$skill" && "$skill" != "references/" ]] && ln -sf "$(pwd)/$skill" ~/.claude/skills/
done

# Or link individually
ln -s /path/to/agent-skills/start-day ~/.claude/skills/start-day
```

## Skills

| Skill | Description |
|-------|-------------|
| [start-day](./start-day/) | Low-friction morning briefing - ONE task, ONE intention |
| [close-day](./close-day/) | Gentle evening wind-down - acknowledge, capture, rest |
| [weekly-review](./weekly-review/) | Shame-free weekly reflection - wins first, ONE goal |

## Shared References

| Reference | Purpose |
|-----------|---------|
| [ADHD-PRINCIPLES.md](./references/ADHD-PRINCIPLES.md) | Design guidelines all skills follow |

## Structure

```
agent-skills/
├── references/           # Shared guidelines
│   └── ADHD-PRINCIPLES.md
├── start-day/
│   └── SKILL.md
├── close-day/
│   └── SKILL.md
├── weekly-review/
│   └── SKILL.md
└── README.md
```

## Compatibility

Works with any agent supporting the [Agent Skills spec](https://agentskills.io/specification):
- Claude Code
- OpenAI Codex CLI
- Gemini CLI
- Cursor

## Requirements

These skills are designed to work with [mdvault](https://github.com/agustinvalencia/mdvault) MCP server for vault operations.
