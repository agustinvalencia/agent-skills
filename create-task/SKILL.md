---
name: create-task
description: Create a new task in the vault with standardised structure. Uses current focus project by default. Minimal friction - just needs a title. Use when the user wants to add a task, says "new task", or describes something to do.
metadata:
  author: mdvault
  version: "1.2"
compatibility: Requires mdvault MCP server with vault configured
---

# Create Task

Standardized task creation. Minimal friction, maximum consistency.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))
**Linking**: Always use `[[wikilinks]]` when writing content that references tasks, projects, or other notes ([rules](../references/LINKING-RULES.md))

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_context_focus` | Current focus project (default for new tasks) |
| `list_projects` | Show active projects if no focus set |
| `create_task` | Create the task |
| `update_metadata` | Set planned_for date if needed |
| `log_to_note` | Log task creation to project note |
| `log_to_daily_note` | Log task creation to daily note |
| `search_notes` | Find related notes for context linking |
| `append_to_note` | Add related notes links to the task |

## Required Information

| Field | Required | Source | Default |
|-------|----------|--------|---------|
| title | Yes | Ask user or extract from request | - |
| project | No | Current focus | Active focus project |
| planned_for | No | Ask if mentioned or infer | None |
| effort | No | Set if mentioned (e.g. "quick", "half day", "2 hours") | None |
| due_date | No | Ask only if mentioned | None |
| priority | No | Never ask | medium |
| description | Auto | Infer from title/context, ask only if complex. For bugs, use structured format (see §6a) | Derived from title |
| criteria | Always | Generate meaningful, verifiable criteria from description — never skip | At least 1 criterion |
| related_notes | Auto | Search vault for notes that add context, link if found | None |

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

### 5b. Handle Effort (If Mentioned)

Set `effort` if the user mentions time/size. Don't ask for it — only capture if offered:
- "quick task" / "5 minutes" → `effort: 0.5h`
- "a couple of hours" → `effort: 2h`
- "half a day" → `effort: 0.5d`
- "should take a day" → `effort: 1d`
- "big one, probably two days" → `effort: 2d`

Use duration strings: `0.5h`, `1h`, `2h`, `0.5d`, `1d`, `2d`, etc.

### 6. Create the Task

Use MCP tool:

```
create_task(
  title: "[title]",
  project: "[project or omit for focus]",
  description: "[description if provided]",
  due_date: "[YYYY-MM-DD or omit]",
  extra_vars: {"criteria": "[acceptance criteria]"}
)
```

Never set priority explicitly — let it default to medium.

**Description**: Always pass the `description` parameter when the user provides context beyond just a title. This populates both the frontmatter and the body `## Description` section. If the user only gives a title, pass a one-line description derived from the title and context (e.g., project name, conversation topic).

#### 6a. Bug Report Description Format

When the task is about fixing a bug (user says "bug", "broken", "not working", "error", "regression", etc.), structure the description with all five fields:

```
**Goal:** What was being attempted / what it should accomplish
**Steps:** How to reproduce — what was done
**Expected:** What should have happened
**Actual:** What happened instead
**Context:** Any other relevant info (error messages, environment, frequency, workarounds)
```

Ask the user to fill in any gaps — for bugs, completeness matters more than speed. A single clarifying question covering all missing fields is fine:

```
To capture this bug properly, could you tell me:
- What were you trying to do?
- What happened instead?
- Any error messages or steps to reproduce?
```

If the user already provided enough detail in their message, don't ask — just structure it.

#### 6b. Acceptance Criteria (Always Generate)

**Acceptance criteria are mandatory** — every task gets meaningful, verifiable criteria. Generate them from the task description and pass via `extra_vars`. Format as a markdown checklist string:

```
extra_vars: {"criteria": "First criterion\n- [ ] Second criterion\n- [ ] Third criterion"}
```

Note: the template already includes `- [ ]` before `{{criteria}}`, so the first criterion needs no prefix — only subsequent items need `\n- [ ]`.

Guidelines for generating criteria:
- **Simple tasks** (call dentist, buy groceries): 1-2 criteria, e.g. `"Appointment booked for a specific date"` — make it verifiable, not just "done"
- **Medium tasks** (submit report, review proposal): 2-3 criteria covering the key deliverables
- **Complex tasks** (with a multi-part description): 3-5 criteria covering each part
- **Bug fix tasks**: criteria must confirm the fix and prevent regression, e.g.:
  - `"Bug no longer reproduces with the reported steps"`
  - `"\n- [ ] Expected behaviour confirmed"`
  - `"\n- [ ] No regressions in related functionality"`
- Keep each criterion short and verifiable — "X is done", not "X is done well"
- Don't ask the user for criteria — infer them from context
- If unsure what "done" looks like, err on the side of more specific criteria rather than vague ones

**If `planned_for` or `effort` is needed**, set them after creation:
```
update_metadata(
  note_path: "[task path from create_task result]",
  metadata_json: '{"planned_for": "YYYY-MM-DD", "effort": "1d"}'
)
```

### 6c. Link Related Notes (When They Add Context)

After creating the task, search the vault for notes that would provide useful context. This is not about linking everything vaguely related — only link notes that a future reader would genuinely benefit from seeing.

**When to search:**
- The task references a specific feature, component, or concept that may have existing notes
- The task is a bug fix (look for related tasks, meeting notes discussing the issue, or zettels about the affected area)
- The user mentioned other notes or context during the conversation

**When to skip:**
- Simple standalone tasks (e.g. "Call dentist", "Buy groceries")
- The task is self-contained and needs no background reading

**How:**

1. Use `search_notes` with 1-2 targeted keywords from the task (component name, feature, error, etc.)
2. From the results, select only notes that genuinely add context — not just keyword matches
3. Append links to the task's `## Notes` section:

```
append_to_note(
  note_path: "[task path from create_task result]",
  content: "**Related:**\n- [[NOTE-ID]] - Why this is relevant\n- [[NOTE-ID]] - Why this is relevant"
)
```

**Guidelines:**
- 1-3 related notes maximum — don't overwhelm
- Always include a short reason why each note is relevant (not just the link)
- Prefer: project notes, prior tasks on the same topic, meeting notes where this was discussed, zettels about the concept
- Skip: daily notes (too transient), notes that only share a vague keyword

### 7. Confirm Simply

```
Created: [TASK-ID] - [Title]
Project: [Project Name]
[Due: date - only if set]
[Planned: date - only if set]
[Effort: duration - only if set]
```

No follow-up questions. Task is created, done.

### 8. Log to Project and Daily Note

Log to the project note so the project's history reflects the new task:
```
log_to_note(
  note_path: "[project note path]",
  content: "Created task [[TASK-ID]]: [Title]"
)
```

The project note path can be derived from the focus context (`project_path` from step 1) or from the `create_task` result (the task path contains the project folder).

Then log to the daily note:
```
log_to_daily_note("Created task [ID]: [Title] in [[Project Name]]")
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
- Don't ask the user for acceptance criteria — generate them silently from context (but do ask for bug details if missing)
- Don't create subtasks automatically
- Don't link more than 3 related notes — quality over quantity

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

**Bug fix (user provides detail):**
```
User: the search_notes tool returns duplicates when the query has accented characters
Agent: Created: MCP-014 - Fix duplicate results for accented character queries
       Project: Markdown Vault MCP
       Related: [[MCP-009]] (prior unicode normalisation task), [[ZTL-042]] (search architecture notes)
```

Description written as:
```
**Goal:** search_notes should return unique results regardless of character encoding
**Steps:** Call search_notes with a query containing accented characters (e.g. "résumé")
**Expected:** Unique matching notes returned
**Actual:** Duplicate entries appear in results
**Context:** Likely a Unicode normalisation issue in the search index. Similar to [[MCP-009]].
```

**Bug fix (user is vague — agent asks):**
```
User: search is broken
Agent: To capture this properly:
       - What were you searching for?
       - What happened — no results, wrong results, or an error?
User: searching for "meeting" returns nothing but I know I have meeting notes
Agent: Created: MCP-015 - Fix search returning no results for "meeting"
       Project: Markdown Vault MCP
```

**Task with related notes:**
```
User: add API rate limiting to the MCP server
Agent: Created: MCP-016 - Add API rate limiting
       Project: Markdown Vault MCP
       Related: [[ZTL-038]] (MCP server architecture), [[MTG-012]] (discussed rate limits in design review)
```

**From conversation:**
```
User: oh I should probably renew my passport this week
Agent: Want me to add "Renew passport" as a task?
User: yes
Agent: Created: PRS-009 - Renew passport
       Project: Personal
```
