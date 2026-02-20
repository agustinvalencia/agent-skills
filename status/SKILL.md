---
name: status
description: Quick snapshot of where you are right now. Shows current focus, due tasks, in-progress work, and today's activity. No review, no planning — just a status check. Use when the user says "status", "where am I", "what's going on", or "what am I working on".
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server (v0.3.0+) with vault configured
---

# Status

Quick snapshot. No review, no planning, no decisions. Just: where am I?

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))

## Mindset

ADHD brains lose track of context:
- "Wait, what was I working on?"
- "What's due soon?"
- "Did I do anything today?"

This skill:
- Shows current state in under 5 seconds
- Zero decisions required
- No follow-up questions
- Read-only — doesn't change anything

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_context_focus` | Current focus project |
| `get_daily_dashboard` | Due/overdue/in-progress tasks |
| `get_context_day` | Today's activity |

## Steps

### 1. Gather Everything (Silent)

Call all three in parallel:

```
get_context_focus()
get_daily_dashboard()
get_context_day(date: "today")
```

### 2. Present Status

One compact output. No questions:

```
Status — [Day], [Date], [Time]

Focus: [project name] (or "None set")
Today: [N] tasks completed, [M] notes modified

In progress:
→ [Task 1]
→ [Task 2]

Due soon:
→ [Task] (due [when])
→ [Task] (overdue [X days])

[If no in-progress or due tasks: "Clear — nothing urgent."]
```

That's it. Done.

### 3. No Follow-Up

Do NOT:
- Ask what they want to work on
- Suggest next actions
- List all tasks
- Start a review

If they want more, they'll ask or use another skill.

## Formatting Rules

- **Cap lists at 3 items** per section. If more exist, show count:
  ```
  In progress: 3 shown (+4 more)
  ```
- **Overdue framing**: Use relative time ("2 days overdue"), not shame
- **Empty sections**: Omit them entirely. Don't show "In progress: None"
- **Time of day**: Include the time to combat time blindness

## Quick Mode (Default)

This skill IS quick mode. There's no slower version. The entire output should fit on one screen.

## What NOT to Do

- Don't list completed tasks (that's a review)
- Don't list all tasks in a project (that's a project review)
- Don't suggest actions (that's unstuck/start-day)
- Don't ask questions (that's friction)
- Don't shame about overdue items (ever)
- Don't log this to the daily note (it's just a peek)

## Edge Cases

**No focus set:**
```
Status — [Day], [Date], [Time]

Focus: None set (use /set-focus to pick a project)

[Show due/overdue tasks across all projects]
```

**No activity today:**
```
Status — [Day], [Date], [Time]

Focus: [project]
Today: No activity yet — the day is young.

[Show due/in-progress if any]
```

**Everything is clear:**
```
Status — [Day], [Date], [Time]

Focus: [project]
Clear — nothing due, nothing in progress. Nice.
```

## Trigger Phrases

- "status"
- "where am I"
- "what am I working on"
- "what's going on"
- "what's due"
- "show me my tasks"
- "quick check"
