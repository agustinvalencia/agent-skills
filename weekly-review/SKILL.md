---
name: weekly-review
description: Conduct a weekly review of the vault. Summarizes the past week's activity, reviews project and task status, helps with reflection (wins, challenges, improvements), and plans focus for the upcoming week. Use when the user wants to do their weekly review or asks about their week's progress.
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Weekly Review

Guide the user through a comprehensive weekly review of their vault.

## Steps

### 1. Gather Context

Collect current state using these MCP tools:

- `get_context_week` - Current week's activity (tasks completed/created, notes modified, active days)
- `get_context_week` with `week: "last"` - Previous week for comparison
- `get_project_progress` - All projects with completion percentages
- `list_tasks` with `status_filter: "doing"` - Currently active tasks

### 2. Present Week Summary

Show the user:

**Activity**
- Active days this week
- Notes modified
- Tasks completed vs created

**Tasks**
- Completed tasks (acknowledge wins)
- In-progress tasks
- Stalled tasks (in "doing" status across multiple weeks)

**Projects**
- Progress bars for active projects
- Projects with activity but 0% completion
- Projects without recent activity

### 3. Facilitate Reflection

Read the current week's note at `Journal/Weekly/YYYY-Wxx.md` using `read_note`.

Help the user fill in the Review section:

- **Wins**: What went well? Reference completed tasks and achievements
- **Challenges**: What obstacles appeared? Look for patterns in stalled work
- **Improvements**: What could be better next week?

Update the weekly note using `append_to_note` with the user's reflections.

### 4. Plan Next Week

- Check if next week's note exists
- Review tasks with upcoming due dates
- Ask: "What is your main focus for next week?"
- Help select 1-3 focus items from active projects

### 5. Optional Cleanup

Offer to help with:

- Marking tasks done via `complete_task`
- Rescheduling overdue tasks via `update_metadata`
- Closing stalled projects

## Completion

After the review, summarize:

```
Weekly Review - YYYY-Wxx

Reviewed: X projects, Y tasks
Completed this week: Z tasks
Next week's focus: [stated focus]

Updated: Journal/Weekly/YYYY-Wxx.md
```

Log the review to today's daily note using `log_to_daily_note`.
