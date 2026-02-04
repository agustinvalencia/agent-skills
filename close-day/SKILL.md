---
name: close-day
description: Wind down the day with a gentle evening review. Acknowledges what happened (no judgment), captures loose thoughts, and optionally sets up tomorrow. Helps quiet the ADHD mind before rest. Use when the user says good night, wants to close the day, or is done working.
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Close Day

ADHD-friendly evening wind-down. Goal: quiet the mind, acknowledge the day, rest easy.

**Read first**: [ADHD Principles](../references/ADHD-PRINCIPLES.md)

## Mindset

Evenings are vulnerable for ADHD brains:
- Racing thoughts about undone tasks
- Rumination on "unproductive" days
- Anxiety about tomorrow

This skill:
- Acknowledges what DID happen (not what didn't)
- Captures loose thoughts so they don't keep you awake
- Closes loops gently
- Makes tomorrow feel manageable

## Steps

### 1. Gather Context (Silent)

Collect the day's activity:

**Call these tools:**
- `get_context_day` with `date: "today"` - Full day activity
- `get_context_focus` - Current focus project context
- `get_daily_dashboard` - Quick status (but ignore overdue at night)

**Extract from `get_context_day`:**
- `date` - Today's date
- `day_of_week` - Day name for greeting
- `daily_note.exists` - Whether note exists
- `daily_note.sections` - Check for "Closing Thoughts" section
- `summary.tasks_completed` - Wins to acknowledge
- `summary.tasks_created` - Planning activity to acknowledge
- `summary.notes_modified` - General activity
- `summary.focus` - What project dominated the day
- `tasks.completed[]` - Specific wins to mention
- `tasks.created[]` - Tasks added (planning = work)
- `modified_notes[]` - What was touched

**Extract from `get_context_focus`:**
- `project` - Current focus (to mention continuity)
- `context.recent_tasks.completed` - Recent wins
- `note` - Why they were focusing (for acknowledgment)

**DO NOT use from dashboard:**
- Overdue tasks (don't mention at night)
- Due tomorrow (anxiety trigger)

### 2. Warm Wind-Down

Start gently:

```
Hey, wrapping up the day. It's [time] on [Day].

Let's see what happened today...
```

No urgency. No pressure.

### 3. Acknowledge the Day (No Judgment)

Reflect what happened, framed positively:

```
Today you:
- [Concrete things from logs/notes - tasks created, notes written, etc.]
- [Activity: "Worked on [focus project]" or "Touched X notes"]
- [Any task completions]
```

**For "unproductive" days:**
- No tasks? → "Some days are thinking days, not doing days."
- Low activity? → "Rest and recovery count."
- Chaos? → "You navigated a lot today."

Never list what wasn't done. Never mention overdue tasks at night.

### 4. Capture Loose Thoughts

ADHD minds race at night. Offer to capture:

```
Anything floating around in your head you want to capture?
- A thought to remember
- Something for tomorrow
- An idea that popped up

(I'll add it to your daily note so you can let it go)
```

Write anything shared to the Notes or Closing Thoughts section.

### 5. Gentle Tomorrow Prep (Optional)

Don't overwhelm with tomorrow's tasks. Just plant a seed:

```
For tomorrow, one thing to keep in mind:
→ [Most relevant item - a deadline, appointment, or continued focus]

That's it. The rest can wait until morning.
```

**Action:** If user agrees to a task, set its `planned_for` date to tomorrow:
`update_metadata(note_path="...", metadata_json='{"planned_for": "YYYY-MM-DD"}')`

If user seems tired, skip this entirely:
```
Tomorrow will sort itself out. Rest now.
```

### 6. Closing Thoughts

If the daily note has a Closing Thoughts section:

```
Any closing thought for the day?
One sentence is plenty. Or we can skip it.
```

Keep it optional. No pressure for profound reflection.

### 7. Close the Day

Update daily note metadata if supported (`closed: true`).

Log to daily note:
```
- Day closed. [Brief summary or "Rest well."]
```

End warmly:

```
Day closed - [Date]

You showed up today. That counts.

Rest well. See you tomorrow.
```

## Quick Mode

If user just wants to close quickly:

```
Closing the day. You [one thing acknowledged].

Rest well.
```

Log and done. No questions.

## What NOT to Do

- Don't list tomorrow's tasks (anxiety trigger)
- Don't mention overdue items at night (rumination)
- Don't ask for detailed reflection (tired brain)
- Don't make closing feel like work
- Don't guilt about unfinished tasks
- Don't energize - wind DOWN

## If It Was a Hard Day

```
Today was tough, and that's okay.
You made it through. That's enough.

Anything you want to let go of before sleep?
```

Let them vent briefly if needed. Capture it. Close it.

```
Noted. You can leave that here.
Tomorrow is a fresh start.
```

## Late Night Mode

If it's past 10pm or user mentions being tired:

```
It's late - let's keep this quick.

Today happened. You're here.
Let's close it and rest.

[Log and close immediately]
```

Don't engage in planning or reflection. Just close.
