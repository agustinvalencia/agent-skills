---
name: complete-task
description: Mark a task as done with proper closure. Celebrates the win, optionally captures what was done, and suggests next action. Provides dopamine hit for completion. Use when the user says they finished something, completed a task, or wants to mark something done.
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Complete Task

Close the loop properly. Celebrate the win. ADHD brains need completion dopamine.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))
**Linking**: Always use `[[wikilinks]]` when writing content that references tasks, projects, or other notes ([rules](../references/LINKING-RULES.md))

## Mindset

Task completion for ADHD needs:
- Explicit acknowledgment (not just checkbox)
- Dopamine moment (celebration)
- Clean closure (no lingering)
- Optional: momentum into next thing

This skill:
- Marks the task done properly
- Celebrates the completion
- Optionally captures summary
- Offers (doesn't push) next action

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_context_focus` | Current focus project for task search |
| `list_tasks` | Find matching task |
| `complete_task` | Mark task as done |
| `log_to_daily_note` | Log completion |

## Steps

### 1. Identify the Task

**If user specifies task:**
```
User: done with KRN-003
Agent: [Use that task ID]
```

**If user describes task:**
```
User: finished the wireframes
Agent: [Search for matching task]
```

**Call:** `list_tasks` with project filter or search in focus project

**If ambiguous:**
```
Which task? I see:
- KRN-003: Design kitchen layout
- KRN-004: Get contractor quotes

(Just the number is fine)
```

Keep it short. Max 3-4 options.

### 2. Confirm and Celebrate

Once task is identified:

```
Completing: KRN-003 - Design kitchen layout
```

**Call:**
```
complete_task(
  task_path: "[path to task]",
  summary: "[optional summary if provided]"
)
```

### 3. Celebrate the Win

This is important. Don't skip it:

```
Done! [Task Title] ✓

Nice work. That's off your plate.
```

**Variations for different task sizes:**
- Small task: "Done! One less thing."
- Medium task: "Nice. That was a solid chunk of work."
- Long-standing task: "Finally done! That one's been waiting a while."
- Hard task: "That was a tough one. Well done getting through it."

### 4. Ask for Summary (Optional, Brief)

Only if task seems significant:

```
Anything to note about how it went?
(One line is fine, or skip)
```

If they provide summary, append to task note.

If they skip, that's fine. Move on.

### 5. Log Completion

**Call:**
```
log_to_daily_note("Completed [Task ID]: [Title]")
```

### 6. Offer Next Action (Gentle)

Don't push. Offer:

```
What's next? I can:
- Pick another task from [Focus Project]
- Show what else is on today's list
- Or we're done for now

(Or just tell me and I'll log it)
```

If user seems done, don't push more tasks:
```
Taking a break? Good. You've earned it.
```

## Quick Mode

If user just wants fast completion:

```
User: done KRN-003
Agent: Done! KRN-003 - Design kitchen layout ✓
       Logged.
```

No questions. No follow-up unless asked.

## Partial Completion

If task isn't fully done:

```
User: made progress on KRN-003 but not finished
Agent: Got it. Want me to:
- Log progress to the task note
- Keep it open and note where you left off

What did you get done?
```

Add progress note to task, keep status as-is.

## Completing Multiple Tasks

```
User: finished the layout and the quotes
Agent: Completing both:
- KRN-003: Design kitchen layout ✓
- KRN-004: Get contractor quotes ✓

Nice! Two down. Logged.
```

Batch celebrate, don't ask questions between each.

## What NOT to Do

- Don't skip celebration (dopamine matters)
- Don't immediately push next task (let them enjoy)
- Don't ask for detailed summary (friction)
- Don't list all remaining tasks (overwhelm)
- Don't say "but you still have X to do" (kills the win)

## Finding Tasks

**Call:** `get_context_focus` for focus project tasks

**Extract:**
- `context.recent_tasks.active` - Currently in-progress
- Check `list_tasks` with `project_filter` for focus project

**Match by:**
1. Task ID (exact match)
2. Title similarity
3. Recent activity

## Celebration Phrases

Mix it up:
- "Done! ✓"
- "Complete. Nice work."
- "That's a wrap on [task]."
- "Checked off. Well done."
- "Finished! One less thing on your mind."
- "[Task] is history. Good job."

Avoid:
- Over-the-top praise (feels fake)
- "Great job!" repeatedly (loses meaning)
- Long congratulations (they want to move on)
