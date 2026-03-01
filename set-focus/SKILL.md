---
name: set-focus
description: Switch project focus with proper context handoff. Closes current focus gracefully, sets new focus, and orients you to the new project. Use when the user wants to switch projects, change focus, or says "focus on" or "work on".
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Set Focus

Switch project focus with proper context handoff. ADHD brains need explicit transitions.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))
**Linking**: Always use `[[wikilinks]]` when writing content that references tasks, projects, or other notes ([rules](../references/LINKING-RULES.md))

## Mindset

Context switching is hard for ADHD:
- Previous context lingers (open loops)
- New context takes time to load
- Switching without closure creates anxiety

This skill:
- Closes the previous focus properly
- Sets the new focus explicitly
- Provides quick orientation to new project
- Logs the transition

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_context_focus` | Current focus project |
| `list_projects` | Show active projects if needed |
| `log_to_note` | Log pause on previous project |
| `set_focus` | Set new project focus |
| `clear_focus` | Clear focus without setting new one |
| `log_to_daily_note` | Log focus transition |

## Steps

### 1. Get Current Focus

**Call:** `get_context_focus()`

**Extract:**
- `project` - Current focus project (if any)
- `note` - Why they were focusing on it
- `context.tasks.todo` - Open tasks in current project

### 2. Identify New Focus

**If user specified project:**
```
User: focus on kitchen renovation
Agent: [Match to project]
```

**If unclear:**
```
Which project do you want to focus on?
```

**Call:** `list_projects(status_filter: "active")` to show options if needed

### 3. Close Previous Focus (If Set)

If there's a current focus, close it gracefully:

```
Closing focus on [Previous Project].
- [X] open tasks will be waiting when you return.

Any quick note about where you left off?
(One line, or skip)
```

If they provide a note, log it:
```
log_to_note(
  note_path: "[previous project path]",
  content: "Paused: [their note]"
)
```

If they skip, that's fine. Move on.

### 4. Set New Focus

**Call:**
```
set_focus(
  project: "[project name]",
  note: "[optional: why focusing on this]"
)
```

### 5. Orient to New Project

Provide quick context for the new project:

**Call:** `get_context_focus()` (now returns new project)

**Present:**
```
Now focusing on: [Project Name]

Quick status:
- [X] tasks open, [Y] done
- Recent: [last completed task or activity]

Next action suggestions:
→ [First todo task or in-progress task]
```

Keep it brief. Just enough to get started.

### 6. Log Transition

```
log_to_daily_note("Switched focus: [Previous] → [New Project]")
```

### 7. Launch

```
Ready to work on [Project Name].

What's first?
```

Or if they already know:
```
Ready. Go for it.
```

## Quick Mode

If user just wants fast switch:

```
User: focus kitchen
Agent: Focus set: Kitchen Renovation
       [X] tasks open. Go.
```

Skip the orientation details.

## No Previous Focus

If no focus was set before:

```
Setting focus: [Project Name]
[Quick orientation]

You're set.
```

Skip the closing step.

## What NOT to Do

- Don't list all tasks in old project (guilt)
- Don't list all tasks in new project (overwhelm)
- Don't require note about previous focus (friction)
- Don't ask multiple questions (decision fatigue)
- Don't linger on the old project

## Focus Without Project

If user wants to focus on something that isn't a project:

```
User: focus on reading papers
Agent: That's not a tracked project. Want to:
- Create it as a project
- Just note it as today's focus (informal)
```

If informal, just log to daily note:
```
log_to_daily_note("Focus: reading papers (informal)")
```

## Clearing Focus

If user wants to clear focus without setting new one:

```
User: clear focus / unfocus / no focus
Agent: Focus cleared. You're in free mode.
       (Set a new focus anytime with /set-focus)
```

**Call:** `clear_focus()`
