---
name: project-review
description: Deep dive review of a single project's health. Shows progress, task status, stalled work, and helps decide next steps. Use when the user wants to review a specific project, check project status, or says "review [project]" or "how is [project] going".
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Project Review

Deep dive on a single project. Understand where it stands and what's next.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))

## Mindset

Projects can drift without attention:
- Tasks pile up without progress
- Original goal gets fuzzy
- Stalled work creates guilt
- Not knowing status creates anxiety

This skill:
- Shows clear project status
- Celebrates what's done
- Identifies what's stuck
- Helps decide next action

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_context_focus` | Check current focus project |
| `list_projects` | List active projects if none specified |
| `get_project_info` | Project metadata, backlinks, activity |
| `get_project_status` | Kanban view with task breakdown |
| `get_context_note` | Rich context for the project note |
| `log_to_project_note` | Log review completion |
| `log_to_daily_note` | Log review to daily note |

## Steps

### 1. Identify Project

**If specified:**
```
User: review kitchen renovation
Agent: [Match to project]
```

**If not specified, check focus:**
```
get_context_focus()
```

If focus is set, offer it:
```
Review [Focus Project]? Or a different one?
```

**If no focus and not specified:**
```
Which project do you want to review?
```

Show active projects with `list_projects(status_filter: "active")`

### 2. Gather Project Data

**Call:**
```
get_project_info(project_name: "[project]")
get_project_status(project_name: "[project]")
get_context_note(note_path: "[project path]")
```

**Extract:**
- Title and description
- Task counts (total, todo, doing, done, blocked)
- Progress percentage
- Recent activity
- Backlinks and references

### 3. Present Status Overview

Start with the big picture:

```
# [Project Name] Review

Progress: [X]% ([done]/[total] tasks)
Status: [open/on-hold/etc]

[Progress bar visualization]
█████████░░░░░░░░░░░ 45%
```

### 4. Celebrate Completed Work

Always acknowledge what's done first:

```
## Completed ✓
- [Task 1]
- [Task 2]
- [Task 3]

[X] tasks done. Nice progress.
```

If nothing completed:
```
No tasks completed yet - but the project exists and you're reviewing it.
That's a start.
```

### 5. Show Current Status

**Active work (doing):**
```
## In Progress
- [Task] - started [when]
```

**Waiting/blocked:**
```
## Waiting On
- [Task] - blocked by [what]
```

**Up next (todo):**
```
## Up Next
- [Task 1]
- [Task 2]
- [Task 3]
(+ [X] more)
```

Limit to 5 items max. Don't overwhelm.

### 6. Identify Issues (Gently)

Look for potential problems:

**Stalled tasks** (in "doing" for >7 days):
```
⚠️ [Task] has been in progress for [X] days.
   Still relevant? Want to break it down or let it go?
```

**No next action:**
```
⚠️ No clear next action. What's the ONE thing to move this forward?
```

**Scope creep** (many tasks created recently):
```
Note: [X] tasks added recently. Is the scope still clear?
```

Frame as observations, not failures.

### 7. Review Expected Outcome

Check if the goal is still clear:

```
## Expected Outcome
"[Original expected outcome from project note]"

Still accurate? Or has the goal evolved?
```

If no outcome defined:
```
No expected outcome defined. Want to add one?
What does "done" look like for this project?
```

### 8. Decide Next Action

End with a clear decision:

```
## What's Next?

Options:
1. Continue with: [suggested next task]
2. Unblock: [stalled task]
3. Pause this project for now
4. Close/archive this project

What feels right?
```

If they pick an action, help execute:
- Continue → Set as focus, identify first step
- Unblock → Break down the stuck task
- Pause → Update status, note why
- Close/Archive → If project status is 'done', call `archive_project(project_name)` to move it to `Projects/_archive/`, cancel remaining tasks, and clear focus automatically. If not yet 'done', help mark it done first, then archive. The tool handles task cancellation, file moves, and logging.

### 9. Log Review

```
log_to_project_note(
  project_path: "[path]",
  content: "Project review completed. Next: [chosen action]"
)

log_to_daily_note("Reviewed project: [name] - [brief outcome]")
```

## Quick Mode

If user wants brief status:

```
User: quick status on kitchen
Agent: Kitchen Renovation: 45% (9/20 tasks)
       Active: Pick countertop material
       Stalled: Nothing
       Next suggested: Schedule contractor visit
```

No deep dive. Just status.

## What NOT to Do

- Don't list every single task (overwhelm)
- Don't emphasise what's not done (shame)
- Don't compare to other projects (judgment)
- Don't require immediate action (pressure)
- Don't make closing a project feel like failure

## Project Health Indicators

**Healthy:**
- Recent activity
- Clear next action
- Progress being made
- No long-stalled tasks

**Needs attention:**
- No activity in 2+ weeks
- Tasks stuck in "doing"
- No clear next action
- Scope unclear

**Consider closing:**
- No activity in 1+ month
- No longer relevant
- Superseded by another project
- Original goal achieved

## Closing a Project

If they decide to close:

```
Closing [Project Name].

Final status: [X]% complete, [Y] tasks done

This project is:
[ ] Completed - goal achieved → mark done, then archive
[ ] Cancelled - no longer relevant
[ ] Merged - absorbed into another project

Any final notes?
```

Then celebrate or acknowledge appropriately:
- Completed: Mark as done, then call `archive_project(project_name)` to archive. "Well done! [Project] is finished and archived."
- Cancelled: "That's okay. Knowing what NOT to do is valuable."
- Merged: "Good consolidation. Less to track."

**Archiving** uses the `archive_project` MCP tool which handles everything:
- Moves files to `Projects/_archive/`
- Cancels any remaining open tasks
- Clears focus if set to this project
- Logs to daily and project notes
