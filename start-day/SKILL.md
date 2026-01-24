---
name: start-day
description: Start the day with a morning briefing. Creates or opens today's daily note, shows the current focus, overdue tasks, tasks due today, and in-progress work. Helps set intentions for the day. Use when the user says good morning, wants to start their day, or asks what's on the agenda.
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Start Day

Guide the user through their morning routine to set up a productive day.

## Steps

### 1. Gather Context

Collect the current state using these MCP tools:

- `get_daily_dashboard` - Overview of today (tasks due, overdue, in progress)
- `get_context_focus` - Current project focus and what user is working on
- `read_note` on today's daily note - Check if it exists and has intentions set

### 2. Morning Briefing

Present a concise summary:

**Good morning! Here's your day:**

- **Focus**: [current project focus]
- **Overdue**: List any overdue tasks needing attention
- **Due today**: Tasks with today's due date
- **In progress**: Active tasks from yesterday

### 3. Check Daily Note

If today's daily note doesn't exist:
- Offer to create it using the daily template

If it exists but Morning Intentions section is empty:
- Ask: "What are your top 1-3 intentions for today?"
- Update the daily note with their response using `append_to_note`

### 4. Set Focus (Optional)

If no project focus is set, or user wants to change it:
- Show active projects using `list_projects`
- Ask which project to focus on
- Set focus using `set_focus`

### 5. Identify First Action

Help the user start with momentum:
- From in-progress or due-today tasks, ask: "Which task will you tackle first?"
- Optionally log the start to the daily note

## Output

End with a clear starting point:

```
Ready for the day!

Focus: [project]
First task: [selected task]

Daily note: Journal/Daily/YYYY-MM-DD.md
```

## Notes

- Keep it brief - mornings should be quick
- Don't overwhelm with too many tasks - highlight top 3-5
- If user seems rushed, skip optional steps
- Log the day start using `log_to_daily_note` with "Started the day"
