---
name: archive-project
description: Archive a completed project. Moves it to _archive, cancels remaining tasks, clears focus, and celebrates closure. Use when the user says they want to archive a project, put a project away, or shelve a finished project.
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Archive Project

Put a finished project to rest properly. Clean closure, celebration, and a fresh slate.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))

## Mindset

Archiving is a positive act:
- The project is DONE - celebrate that
- Open tasks get cancelled cleanly (no guilt)
- Files move out of the active view
- Focus clears for the next thing

This skill:
- Validates the project is ready to archive (status: done)
- Shows what will happen (tasks cancelled, files moved)
- Calls the archive tool
- Celebrates the closure
- Suggests what's next

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `list_projects` | Find project if not specified |
| `get_project_context` | Check project status and metadata |
| `get_project_status` | Show open tasks that will be cancelled |
| `archive_project` | Execute the archive operation |
| `get_context_focus` | Check if focus needs clearing |
| `log_to_daily_note` | Log the archival event |

## Steps

### 1. Identify the Project

**If specified:**
```
User: archive the kitchen renovation project
Agent: [Match to project]
```

**If not specified:**
```
Which project do you want to archive?
```

Show completed projects with `list_projects(status_filter: "done")`.

**Filter out areas** — only projects (kind: project) can be archived. If the list includes areas, exclude them from the archivable options.

### 2. Validate Status

**Call:** `get_project_context(project_name: "[project]")`

Check that `status == "done"`.

**If not done:**
```
[Project] has status '[current status]' - only 'done' projects can be archived.

Want me to mark it as done first? Or review it to make sure everything's wrapped up?
```

If they want to mark done first, help with that, then proceed to archive.

### 3. Show What Will Happen

**Call:** `get_project_status(project_name: "[project]")`

Review open tasks:

```
Archiving: [Project Name]

This will:
- Move all files to Projects/_archive/[slug]/
- Cancel [N] remaining open task(s):
  - [Task 1]
  - [Task 2]
- Set status to 'archived'

Go ahead?
```

If no open tasks:
```
Archiving: [Project Name]

All tasks are already done or cancelled. Clean archive.

Go ahead?
```

### 4. Execute Archive

**Call:**
```
archive_project(project_name: "[project]")
```

### 5. Celebrate Closure

This matters. A finished project deserves recognition:

```
[Project Name] is archived.

[X] tasks completed, [Y] total. That's a wrap.

The project files are safe in _archive/ if you ever need them.
```

**Variations:**
- Long-running project: "That was a marathon. Well done seeing it through."
- Small project: "Clean and done. Nice."
- Project with many cancelled tasks: "Some tasks didn't make it, and that's fine. The important work got done."

### 6. Suggest Next Focus

Gently offer what's next:

```
Focus is cleared. What's next?
- Pick another project to focus on
- See what else is active
- Take a break - you've earned it
```

Don't push. Let them decide.

## Quick Mode

```
User: archive kitchen-renovation
Agent: Archived! Kitchen Renovation is put away.
       2 open tasks cancelled. Focus cleared.
       Files moved to Projects/_archive/kitchen-renovation/
```

No questions, no follow-up.

## What NOT to Do

- Don't make archiving feel like failure
- Don't dwell on cancelled tasks
- Don't skip the celebration
- Don't immediately push the next project
- Don't archive without confirming (unless quick mode)

## Edge Cases

**Project not found:**
```
Can't find that project. Here are the active ones:
[list]
```

**Project not done:**
```
That project isn't marked as done yet. Want to review it first?
```

**Already archived:**
```
That project is already archived. Nothing to do.
```

**That's an area, not a project:**
```
[Name] is an area, not a project — areas are ongoing and can't be archived.
If it's no longer relevant, you can pause it or remove it instead.
```
