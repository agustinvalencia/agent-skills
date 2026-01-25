---
name: start-day
description: Start the day with a low-friction morning briefing. Shows ONE priority task, current focus, and helps set a single intention. ADHD-friendly - minimal overwhelm, maximum momentum. Use when the user says good morning, wants to start their day, or asks what's on the agenda.
metadata:
  author: mdvault
  version: "2.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Start Day

ADHD-friendly morning routine. Goal: get the user moving with ONE clear action.

**Read first**: [ADHD Principles](../references/ADHD-PRINCIPLES.md)

## Steps

### 1. Gather Context (Silent)

Collect state using MCP tools - don't dump this on the user:

**Call these tools:**
- `get_context_focus` - Returns focus project with task counts and recent activity
- `get_context_day` with `date: "today"` - Returns daily note status and today's activity
- `get_daily_dashboard` - Returns overdue/due today/in-progress tasks

**Extract from `get_context_focus`:**
- `project` - Current focus project name
- `note` - Why they're focusing on it
- `context.tasks.todo` - Open tasks count
- `context.tasks.done` - Completed tasks count
- `context.recent_tasks.completed` - Recent wins to celebrate
- `context.recent_tasks.active` - Tasks currently in progress

**Extract from `get_context_day`:**
- `daily_note.exists` - Whether daily note exists
- `summary.tasks_completed` - Tasks done today
- `summary.tasks_created` - Tasks created today
- `tasks.in_progress` - Active tasks to suggest

**Extract from `get_daily_dashboard`:**
- Overdue tasks (first one for priority)
- Due today tasks
- In-progress tasks

### 2. Warm Greeting with Orientation

Start with day context (combats time blindness):

```
Good morning! It's [Day], [Date].

Your focus: [project] (or "No focus set - want to pick one?")
```

Keep it brief. Don't list everything yet.

### 3. Celebrate Before Problems

If there's any recent progress, mention it FIRST:

- "Yesterday you created 3 tasks for the move - nice momentum!"
- "Your weekly note is filled in - good reflection work."
- "You've been consistent with daily notes this week."

Find something. Even "You showed up today" counts.

### 4. Surface ONE Priority

Don't list all tasks. Pick ONE based on:
1. Overdue with nearest deadline
2. Due today
3. Blocking other work
4. User's stated focus area

Present it simply:

```
One thing that needs you today:
→ [Task title] (due [when] / overdue by [X days])

Want to start with this, or pick something else?
```

If user has > 5 overdue, don't list them:
```
You have 7 overdue tasks - that's a lot and that's okay.
Let's not tackle all of them. Which area feels most urgent: [Project A] or [Project B]?
```

### 5. Set One Intention (Optional)

If daily note exists but intentions are empty:

```
What's one thing that would make today feel successful?
(Just one - we can add more later if needed)
```

Write it to the Morning Intentions section. One is enough.

### 6. Identify Smallest First Step

Once task is chosen, reduce initiation friction:

```
To get started on [task]:
→ [Smallest possible action, e.g., "Open the document" or "Write one sentence"]

Ready? I can log that you're starting.
```

### 7. Log and Launch

Log to daily note:
```
- Started the day, focusing on [task]
```

End with momentum, not more planning:

```
You're set! Focus: [project], First task: [task]

Go get it - I'll be here if you need me.
```

### 8. Ask for planned meetings

Ask the user if there are meetings that should be considered in today's agenda, 
If the daily note has an agenda section add them: 

```
- [time start] - [meeting]
```

### 9. In case of late starts

If the user is starting the day, but the current time is no longer "morning",
keep it as a quick start.

## What NOT to Do

- Don't list all overdue tasks (overwhelm)
- Don't ask open-ended "what do you want to do?" (decision fatigue)
- Don't mention tasks that aren't urgent today (distraction)
- Don't shame for yesterday's incomplete work (shame spiral)
- Don't require filling out the full daily note template (friction)

## Quick Mode

If user seems rushed or says "quick" / "fast":

```
Morning! It's [Day].

One thing: [Most urgent task]

Go for it?
```

Skip everything else. Movement over process.
