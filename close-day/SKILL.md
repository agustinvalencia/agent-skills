---
name: close-day
description: Wind down the day with a gentle evening review. Acknowledges what happened (no judgment), captures loose thoughts, and optionally sets up tomorrow. Helps quiet the ADHD mind before rest. Use when the user says good night, wants to close the day, or is done working.
metadata:
  author: mdvault
  version: "2.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Close Day

ADHD-friendly evening wind-down. Goal: quiet the mind, acknowledge the day, rest easy.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))

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

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_context_day` | Today's full activity |
| `get_context_focus` | Current focus project context |
| `get_daily_dashboard` | Quick status (ignore overdue at night) |
| `read_note` | Read daily note for intention text |
| `get_metadata` | Check intention and closed status |
| `append_to_note` | Write closing thoughts |
| `update_metadata` | Mark day as closed |
| `log_to_daily_note` | Log day close |

## Steps

### 1. Gather Context (Silent)

Collect the day's activity:

**Call these tools (in parallel where possible):**
- `get_context_day` with `date: "today"` - Full day activity
- `get_context_focus` - Current focus project context
- `get_daily_dashboard` - Quick status (but ignore overdue at night)
- `get_metadata` on today's daily note - Check `intention` field

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

### 4. Reflect on Intention (Gentle)

Check the `intention` metadata from step 1.

**If `intention: true`** — an intention was set this morning:

Read the `## Intention` section from the daily note to get the text. Then reflect gently:

```
Your intention today was: "[intention text]"
→ [Brief, honest reflection — "Looks like you stayed on track" or "The day went a different direction, and that's fine"]
```

Don't judge. Just mirror. If they clearly achieved it, celebrate. If not, normalise — days rarely go to plan.

**If `intention: false`** — no intention was set:

Don't shame. Just note it lightly:

```
No intention set today — that happens.
```

Only surface the pattern if it's becoming frequent (e.g., 3+ days in a row). Keep it compassionate:

```
That's a few days without setting an intention. Want to try one tomorrow morning?
No pressure — just data.
```

### 5. Review Planned Tasks

Check if any tasks with `planned_for` = today didn't get attention. This is the replanning loop — the whole point of `planned_for`.

**From the dashboard or task list, find tasks where `planned_for` = today and status is still `todo`.**

If there are unattended planned tasks, surface them gently (one at a time, not a list):

```
You had [task title] ([effort]) planned for today.
→ Replan for another day, or leave it?
```

**For each, based on user's answer:**
- **Replan** → `update_metadata(note_path: "...", metadata_json: '{"planned_for": "YYYY-MM-DD"}')`
- **Leave** → No action (it stays, will surface again)
- **Done actually** → `complete_task(task_path: "...")`

Don't shame. Days rarely go to plan. If there are many, batch them:
```
[X] planned tasks didn't get touched today — that's normal.
Want to quickly replan them, or leave them for tomorrow?
```

If user says "leave them" or seems tired, move on immediately.

### 6. Capture Loose Thoughts

ADHD minds race at night. Offer to capture:

```
Anything floating around in your head you want to capture?
- A thought to remember
- Something for tomorrow
- An idea that popped up

(I'll add it to your daily note so you can let it go)
```

Write anything shared to the Notes or Closing Thoughts section.

### 7. Gentle Tomorrow Prep (Optional)

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

### 8. Closing Thoughts

If the daily note has a Closing Thoughts section:

```
Any closing thought for the day?
One sentence is plenty. Or we can skip it.
```

Keep it optional. No pressure for profound reflection.

### 9. Close the Day

**Write closing thought** (if provided in step 7):
```
append_to_note(
  note_path: "[today's daily note path]",
  content: "[closing thought text]",
  subsection: "Closing Thoughts"
)
```

**Mark the day as closed:**
```
update_metadata(
  note_path: "[today's daily note path]",
  metadata_json: '{"closed": true}'
)
```

**Log it:**
```
log_to_daily_note("Day closed")
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
