---
name: daily-standup
description: Quick async standup status - what happened yesterday, what's planned today, any blockers. Creates a meeting note and pulls context automatically. Use when the user says "standup", "daily standup", or "status update".
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server (v0.3.0+) with vault configured
---

# Daily Standup

Generate a quick standup status. Perfect for async team updates or personal accountability.

**Read first**: [ADHD Principles](../references/ADHD-PRINCIPLES.md)

## Mindset

Standups should be:
- Quick (< 2 minutes to generate)
- Factual (what happened, not what should have)
- Forward-looking (what's next)
- Honest about blockers (no shame)

This skill:
- Pulls yesterday's activity automatically
- Shows today's planned/in-progress tasks
- Creates a meeting note for the standup
- Keeps it brief and scannable

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
```

**Extract:**
- `project` - Current focus
- `context.tasks.in_progress` - Tasks in progress
- `context.tasks.todo` - Planned tasks
- `context.recent_tasks.active[]` - Specific task names

### 3. Check for Blockers

**Call:**
```
list_tasks(status_filter: "blocked")
```

Note any blocked tasks for the standup.

### 4. Generate Standup

Present in classic standup format:

```markdown
# Daily Standup - [Today's Date]

## Yesterday
- Completed [N] tasks
  - [Task 1]
  - [Task 2]
- [Any notable activity]

## Today
- Focus: [Current focus project]
- In progress:
  - [Task in progress]
- Planned:
  - [Next task]

## Blockers
- [Any blocked tasks, or "None"]
```

### 5. Offer to Save

```
Want me to:
1. Create a standup meeting note
2. Copy to clipboard (for Slack/Teams)
3. Just display (done)
```

**If saving as meeting:**
```
create_meeting(
  title: "Daily Standup",
  date: "[today]"
)
```

Then append the standup content to the created note.

### 6. Log It

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
```

Three lines. Done.

## Formats

### Standard (Default)
Full markdown format with sections.

### Slack Format
```
*Yesterday:* Completed API migration, wrote tests
*Today:* Working on MCP context tools
*Blockers:* Waiting on design review
```

### Brief
```
✓ Yesterday: 3 tasks done
→ Today: MCP context tools
⚠ Blockers: None
```

## What NOT to Do

- Don't list everything from yesterday (overwhelm)
- Don't list all planned tasks (anxiety)
- Don't judge low activity days
- Don't ask clarifying questions (just generate)
- Don't require manual input (pull from vault)

## Handling Edge Cases

**No activity yesterday:**
```
## Yesterday
- Light day - no tracked task completions
- [Any notes modified, or "Took a break"]
```

No judgment. Just facts.

**No focus set:**
```
## Today
- No project focus set
- Consider: /set-focus to pick a project
```

**Many blocked tasks:**
```
## Blockers
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

- Focus on work-related projects only
- Use more formal language
- Include project names explicitly
- Skip personal projects

## Examples

**Quick standup:**
```
User: /daily-standup
Agent:
# Daily Standup - 2026-02-03

## Yesterday
- Completed 2 tasks
  - Implement context commands
  - Write MCP documentation

## Today
- Focus: MarkdownVault MCP
- In progress: Activity report tool
- Planned: Update skills documentation

## Blockers
- None

---
Saved as MTG-2026-02-03-001
```

**For Slack:**
```
User: standup for slack
Agent:
*Yesterday:* Implemented context commands, wrote MCP docs
*Today:* Working on activity report tool for MCP server
*Blockers:* None

(Copied to clipboard)
```

**Sparse day:**
```
User: standup
Agent:
# Daily Standup - 2026-02-03

## Yesterday
- Light day - 0 tasks completed
- Modified 3 notes (research reading)

## Today
- Focus: Research Papers
- Planned: Continue literature review

## Blockers
- None
```
