---
name: create-task
description: Create a new task in the vault with standardised structure. Uses current focus project by default. Minimal friction - just needs a title. Use when the user wants to add a task, says "new task", or describes something to do.
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Create Task

Standardized task creation. Minimal friction, maximum consistency.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_context_focus` | Current focus project (default for new tasks) |
| `list_projects` | Show active projects if no focus set |
| `create_task` | Create the task |
| `update_metadata` | Set planned_for date if needed |
| `log_to_daily_note` | Log task creation |

## Required Information

| Field | Required | Source | Default |
|-------|----------|--------|---------|
| title | Yes | Ask user or extract from request | - |
| project | No | Current focus | Active focus project |
| planned_for | No | Ask if mentioned or infer | None |
| due_date | No | Ask only if mentioned | None |
| priority | No | Never ask | medium |
| description | No | Ask only if complex | (empty) |

## Procedure

### 1. Check Focus Context (Silent)

First, get current focus:

**Call:** `get_context_focus()`

**Extract:**
- `project` - Current focus project name (use as default)
- `project_path` - Path for logging
- `context.tasks.todo` - Open task count (for duplicate detection)
- `context.recent_tasks.active` - Active tasks (check for similar)

**If no focus set** (`project` is null):
- Will need to ask user which project
- Use `list_projects` with `status_filter: "active"` to show options

### 2. Extract or Ask for Title

If user said something like "I need to call the dentist":
- Extract: "Call the dentist"

If unclear:
```
What's the task?
(Start with a verb - e.g., "Call dentist", "Review proposal", "Buy groceries")
```

**Good task titles:**
- Start with action verb
- Specific enough to know when done
- 3-7 words ideal

**If too vague**, help refine:
```
"Work on project" is broad - what's one specific thing to do?
```

### 3. Confirm Project (Only If Needed)

If focus is set:
```
Adding to [Focus Project]. (Say "different project" to change)
```

If no focus set:
```
Which project is this for?
```

Use `list_projects` if user needs to see options (limit to active ones).

### 4. Handle Due Date (Only If Mentioned)

Only ask/set if user mentions time:
- "by Friday" → calculate date
- "next week" → next Monday
- "tomorrow" → tomorrow's date
- "urgent" → today

Don't ask for due date if not mentioned.

### 5. Handle Planned Date (Internal Schedule)

Ask or infer when the user *intends* to work on this:
- "on Tuesday" -> set `planned_for` to that date.
- "this afternoon" -> set `planned_for` to today.
- "next week" -> set `planned_for` to next Monday (if no due date mentioned).

If a task is created *from* a Daily Note or during a planning session, set `planned_for` to that day.

### 6. Create the Task

Use MCP tool:

```
create_task(
  title: "[title]",
  project: "[project or omit for focus]",
  due_date: "[YYYY-MM-DD or omit]"
)
```

Never set priority explicitly - let it default to medium.

**If `planned_for` is needed**, set it after creation:
```
update_metadata(
  note_path: "[task path from create_task result]",
  metadata_json: '{"planned_for": "YYYY-MM-DD"}'
)
```

### 7. Confirm Simply

```
Created: [TASK-ID] - [Title]
Project: [Project Name]
[Due: date - only if set]
```

No follow-up questions. Task is created, done.

### 8. Log to Daily Note

```
log_to_daily_note("Created task [ID]: [Title]")
```

## Quick Mode (Default)

Most task creation should be instant:

```
User: task: call dentist
Agent: Created: PRS-005 - Call dentist
       Project: Personal
```

One line in, two lines out.

## Batch Mode

If user lists multiple tasks:

```
User: I need to: call dentist, buy groceries, email Bob
```

Create each one, summarize at end:

```
Created 3 tasks in [Project]:
- [ID] Call dentist
- [ID] Buy groceries
- [ID] Email Bob
```

Don't ask for confirmation between each.

## What NOT to Do

- Don't ask for priority (default is fine)
- Don't ask for description unless complex
- Don't ask for due date unless mentioned
- Don't ask for project if focus is set
- Don't require acceptance criteria (overhead)
- Don't create subtasks automatically
- Don't suggest related tasks

## Edge Cases

**No project exists:**
```
You don't have any projects yet. Want to create one first?
Or I can add this to a general inbox if you have one.
```

**Task seems like a project:**
```
"Renovate kitchen" sounds like a project with multiple steps.
Want to create it as a project instead?
```

**Duplicate detection:**
If a very similar task exists:
```
You already have "[similar task]" in [project].
Still want to create this one?
```

## Examples

**Instant (focus set):**
```
User: book flights
Agent: Created: HLD-003 - Book flights
       Project: Holiday Planning
```

**With dates:**
```
User: submit report by friday
Agent: Created: WRK-012 - Submit report
       Project: Q1 Report
       Due: 2026-01-31

User: plan to call the accountant on Tuesday
Agent: Created: PRS-008 - Call accountant
       Project: Personal
       Planned: 2026-02-03
```

**Different project:**
```
User: task for kitchen reno: pick countertop material
Agent: Created: KRN-005 - Pick countertop material
       Project: Kitchen Renovation
```

**From conversation:**
```
User: oh I should probably renew my passport this week
Agent: Want me to add "Renew passport" as a task?
User: yes
Agent: Created: PRS-009 - Renew passport
       Project: Personal
```
