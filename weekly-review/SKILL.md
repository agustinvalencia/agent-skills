---
name: weekly-review
description: Conduct an ADHD-friendly weekly review of the vault. Celebrates wins first, reviews progress compassionately, and plans next week with focus on ONE main goal. No shame, no overwhelm. Use when the user wants to do their weekly review or reflect on their week.
metadata:
  author: mdvault
  version: "2.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Weekly Review

ADHD-friendly weekly review. Goal: reflect without shame, plan without overwhelm.

**Read first**: [ADHD Principles](../references/ADHD-PRINCIPLES.md)

## Mindset

Weekly reviews can trigger shame spirals for ADHD brains. This skill:
- Leads with wins (dopamine first)
- Reframes "failures" as information
- Focuses on ONE goal for next week
- Keeps it under 15 minutes

## Steps

### 1. Gather Context (Silent)

Collect state - process it before presenting:

- `get_context_week` - Current week's activity
- `get_context_week` with `week: "last"` - For comparison (optional)
- `get_project_progress` - Project completion rates
- `list_tasks` with `status_filter: "doing"` - Stalled work

### 2. Celebrate Wins First

ALWAYS start positive. Find wins even in "bad" weeks:

```
Let's look at your week! Here's what went well:

- [Concrete achievement - task completed, note created, etc.]
- [Activity metric framed positively: "You showed up 6 out of 7 days"]
- [Any progress on focus project]
```

**Reframe low activity compassionately:**
- 0 tasks completed → "You created X tasks - planning is work too"
- Low note count → "Quality over quantity - some weeks are like that"
- Missed days → "Life happens. You're here now doing this review."

Never say: "You didn't complete any tasks" or "You failed to..."

### 3. Quick Activity Summary

Brief, not exhaustive:

```
This week: [X] active days, [Y] notes touched, [Z] tasks created

Focus was on: [project name]
```

Don't list every modified note. Don't show full task lists.

### 4. Address Stalled Work (Gently)

If tasks have been "in progress" for 2+ weeks:

```
A few things have been waiting a while:
- [Task] - started [when]. Still relevant, or should we let it go?
```

Offer escape hatches:
- "Want to break this into smaller pieces?"
- "Should we move this to someday/maybe?"
- "Is this actually important, or can we drop it?"

No guilt. Just honest reassessment.

### 5. Reflect (Keep It Simple)

Help fill in the weekly note. Don't require long answers:

**Wins** (already covered - just confirm):
```
I'll note these wins in your weekly review:
- [Win 1]
- [Win 2]

Anything else you want to add?
```

**Challenges** (reframe as information):
```
What got in the way this week?
(Not what you did wrong - what external factors or ADHD moments happened?)
```

**One Improvement** (not five):
```
What's ONE thing that could help next week?
(Just one - small and specific works best)
```

Update the weekly note using `append_to_note`.

### 6. Plan Next Week (ONE Thing)

Don't set 5 goals. Set ONE:

```
Looking at next week:
- [Upcoming deadline if any]
- [Current project status]

What's the ONE main focus for next week?
(Everything else can be secondary)
```

If next week's note doesn't exist, offer to create it.

Write the single focus item. Resist adding more.

### 7. Quick Cleanup (Optional, Ask First)

```
Want to do a quick cleanup? I can help:
- Mark done tasks as complete
- Reschedule or drop stalled tasks
- Close finished projects

Or we can skip this - the review itself is enough.
```

Don't push cleanup if user is tired.

### 8. Close Positively

```
Weekly Review Done - [Week]

Wins: [count or brief list]
Next week's focus: [ONE thing]

Nice work reflecting. See you next week!
```

Log to daily note:
```
- Completed weekly review. Focus for next week: [X]
```

## What NOT to Do

- Don't start with problems or overdue counts
- Don't list all incomplete tasks (shame trigger)
- Don't require detailed reflection (decision fatigue)
- Don't set multiple goals for next week (overwhelm)
- Don't compare negatively to "productive" weeks
- Don't use words like "failed", "didn't", "should have"

## If the Week Was Hard

Some weeks are survival mode. That's okay.

```
Looks like this was a tough week - and that's completely valid.
You're here doing this review, which means you're still in the game.

What's one small thing you can acknowledge yourself for this week?
```

Find the win. There's always something.
