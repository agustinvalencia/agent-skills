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

### Daily Routines

| Skill | Description |
|-------|-------------|
| [start-day](./start-day/) | Morning briefing with standup - ONE task, ONE intention |
| [close-day](./close-day/) | Gentle evening wind-down - acknowledge, capture, rest |

### Reviews & Reports

| Skill | Description |
|-------|-------------|
| [weekly-review](./weekly-review/) | Shame-free weekly reflection - wins first, ONE goal |
| [monthly-report](./monthly-report/) | Generate monthly summary - accomplishments, patterns, shareable |
| [project-review](./project-review/) | Deep dive on single project health |
| [archive-project](./archive-project/) | Archive a completed project - celebrate closure |

### Task Flow

| Skill | Description |
|-------|-------------|
| [create-task](./create-task/) | Create task with minimal friction - uses focus project |
| [complete-task](./complete-task/) | Mark done with celebration - proper closure + dopamine |
| [quick-capture](./quick-capture/) | Instant thought dump - zero friction, process later |
| [process-inbox](./process-inbox/) | Standalone inbox triage - sort, decide, clear |

### Focus & Context

| Skill | Description |
|-------|-------------|
| [set-focus](./set-focus/) | Switch project focus with proper context handoff |
| [context-switch](./context-switch/) | Full context transition - close old, open new properly |
| [take-break](./take-break/) | Proper pause with clean handoff and gentle return |
| [status](./status/) | Quick snapshot - focus, due tasks, in-progress |

### When Stuck

| Skill | Description |
|-------|-------------|
| [unstuck](./unstuck/) | Paralysis breaker - picks ONE tiny action for you |
| [brain-dump](./brain-dump/) | Empty your head into vault, then pick ONE thing |

### Research

| Skill | Description |
|-------|-------------|
| [read-paper](./read-paper/) | Multi-pass paper reading with active engagement + zettel extraction |

### Creation (Standardised Procedures)

| Skill | Description |
|-------|-------------|
| [create-project](./create-project/) | Create project with title, context, outcome |
| [create-meeting](./create-meeting/) | Create meeting note with auto-generated ID |

## Shared References

| Reference | Purpose |
|-----------|---------|
| [ADHD-PRINCIPLES.md](./references/ADHD-PRINCIPLES.md) | Design guidelines all skills follow |
| [ROADMAP.md](./ROADMAP.md) | Future ideas and enhancements |

## Structure

```
agent-skills/
├── references/
│   └── ADHD-PRINCIPLES.md
├── start-day/
├── close-day/
├── weekly-review/
├── monthly-report/
├── project-review/
├── archive-project/
├── create-project/
├── create-meeting/
├── create-task/
├── complete-task/
├── quick-capture/
├── process-inbox/
├── set-focus/
├── context-switch/
├── take-break/
├── status/
├── unstuck/
├── brain-dump/
├── read-paper/
├── ROADMAP.md
└── README.md
```

## Compatibility

Works with any agent supporting the [Agent Skills spec](https://agentskills.io/specification):
- Claude Code
- OpenAI Codex CLI
- Gemini CLI
- Cursor

## Requirements

These skills are designed to work with the [mdvault](https://github.com/agustinvalencia/mdvault) MCP server for vault operations.
