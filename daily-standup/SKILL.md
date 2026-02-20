---
name: daily-standup
description: Quick async standup status - what happened yesterday, what's planned today, any blockers. Writes to today's daily note and optionally outputs a shareable format. Use when the user says "standup", "daily standup", or "status update".
metadata:
  author: mdvault
  version: "2.0"
compatibility: Requires mdvault MCP server (v0.3.0+) with vault configured
---

# Daily Standup

Generate a quick standup status and write it to today's daily note.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))

## Mindset

Standups should be:
- Quick (< 2 minutes to generate)
- Factual (what happened, not what should have)
- Forward-looking (what's next)
- Honest about blockers (no shame)

This skill:
- Pulls yesterday's activity automatically
- Shows today's planned/in-progress tasks
- Writes the standup to today's daily note (the vault remembers)
- Optionally outputs a shareable format for Slack/Teams
- Keeps it brief and scannable

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_context_day` | Yesterday's activity |
| `get_context_focus` | Current focus and tasks |
| `list_tasks` | Check for blocked tasks |
| `create_daily_note` | Ensure today's note exists |
| `append_to_note` | Write standup to daily note |
| `log_to_daily_note` | Log standup completion |

## Steps

### 1. Get Yesterday's Context (Silent)

**Call:**
```
get_context_day(date: "yesterday")
```

**Extract:**
- `summary.tasks_completed` - Number completed
- `tasks.completed[]` - What got done
- `summary.notes_modified` - Activity level

### 2. Get Today's Context (Silent)

**Call:**
```
get_context_focus()
get_context_day(date: "today")
```

**Extract from focus:**
- `project` - Current focus
- `context.tasks.in_progress` - Tasks in progress
- `context.tasks.todo` - Planned tasks
- `context.recent_tasks.active[]` - Specific task names

**Extract from today:**
- `daily_note.exists` - Whether daily note exists

### 3. Ensure Daily Note Exists (Silent)

If `daily_note.exists` is `false`:
- Call `create_daily_note()` before writing anything

### 4. Check for Blockers

**Call:**
```
list_tasks(status_filter: "blocked")
```

Note any blocked tasks for the standup.

### 5. Generate and Write Standup

Compose the standup content:

```markdown
### Yesterday
- Completed [N] tasks
  - [Task 1]
  - [Task 2]
- [Any notable activity]

### Today
- Focus: [Current focus project]
- In progress:
  - [Task in progress]
- Planned:
  - [Next task]

### Blockers
- [Any blocked tasks, or "None"]
```

**Write to daily note:**
```
append_to_note(
  note_path: "[today's daily note path]",
  content: "[standup content]",
  subsection: "Standup"
)
```

### 6. Display and Offer Shareable Format

Show the standup to the user, then offer:

```
Standup written to today's daily note.

Want a copy-pasteable version for Slack/Teams?
```

If yes, output in the requested format (see Formats below).

### 7. Log It

```
log_to_daily_note("Standup completed")
```

## Quick Mode

If user just wants fast output:

```
User: standup
Agent:
Yesterday: Completed 3 tasks (API migration, tests, docs)
Today: Focus on MCP server - implementing context tools
Blockers: None

Written to daily note.
```

Three lines + confirmation. Done.

## Formats

### Vault (Default)
Written directly to today's daily note under `## Standup`.

### Slack Format (Shareable)
```
*Yesterday:* Completed API migration, wrote tests
*Today:* Working on MCP context tools
*Blockers:* Waiting on design review
```

### Brief (Shareable)
```
Yesterday: 3 tasks done
Today: MCP context tools
Blockers: None
```

## What NOT to Do

- Don't list everything from yesterday (overwhelm)
- Don't list all planned tasks (anxiety)
- Don't judge low activity days
- Don't ask clarifying questions (just generate)
- Don't require manual input (pull from vault)
- Don't create a separate meeting note (the daily note is the record)

## Handling Edge Cases

**No activity yesterday:**
```
### Yesterday
- Light day - no tracked task completions
- [Any notes modified, or "Took a break"]
```

No judgment. Just facts.

**No focus set:**
```
### Today
- No project focus set
- Consider: /set-focus to pick a project
```

**Many blocked tasks:**
```
### Blockers
- [Task 1] - blocked
- [Task 2] - blocked
- (3 tasks blocked - might need attention)
```

Flag it gently, don't alarm.

## Team Context

If user mentions it's for a team:

```
User: standup for the backend team meeting
```

- Still write to daily note (personal record)
- Also output a shareable version focused on work projects only
- Use more formal language
- Include project names explicitly
- Skip personal projects

## Examples

**Standard:**
```
User: /daily-standup
Agent:
Standup written to today's daily note:

### Yesterday
- Completed 2 tasks
  - Implement context commands
  - Write MCP documentation

### Today
- Focus: MarkdownVault MCP
- In progress: Activity report tool
- Planned: Update skills documentation

### Blockers
- None

Want a Slack-friendly version?
```

**For Slack:**
```
User: standup for slack
Agent:
[writes to daily note]

Here's your Slack version:

*Yesterday:* Implemented context commands, wrote MCP docs
*Today:* Working on activity report tool for MCP server
*Blockers:* None
```

**Sparse day:**
```
User: standup
Agent:
### Yesterday
- Light day - 0 tasks completed
- Modified 3 notes (research reading)

### Today
- Focus: Research Papers
- Planned: Continue literature review

### Blockers
- None

Written to daily note.
```
