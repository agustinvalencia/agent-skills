---
name: start-day
description: Start the day with a low-friction morning briefing. Shows ONE priority task, current focus, writes a standup to the daily note, and helps set a single intention. ADHD-friendly - minimal overwhelm, maximum momentum. Use when the user says good morning, wants to start their day, asks what's on the agenda, or says "standup" or "daily standup".
metadata:
  author: mdvault
  version: "3.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Start Day

ADHD-friendly morning routine. Goal: get the user moving with ONE clear action.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_context_focus` | Current focus project with task counts |
| `get_context_day` | Today's and yesterday's activity |
| `get_daily_dashboard` | Overdue/due today/in-progress tasks |
| `create_daily_note` | Ensure today's note exists |
| `list_tasks` | Check for blocked tasks |
| `append_to_note` | Write standup to daily note |
| `log_to_daily_note` | Log the day start |

## Steps

### 1. Gather Context (Silent)

Collect state using MCP tools - don't dump this on the user:

**Call these tools (in parallel where possible):**
- `get_context_focus` - Returns focus project with task counts and recent activity
- `get_context_day` with `date: "today"` - Returns daily note status and today's activity
- `get_context_day` with `date: "yesterday"` - Returns yesterday's completions and activity
- `get_daily_dashboard` - Returns overdue/due today/in-progress tasks
- `list_tasks` with `status_filter: "blocked"` - Any blocked work

**Extract from `get_context_focus`:**
- `project` - Current focus project name
- `note` - Why they're focusing on it
- `context.tasks.todo` - Open tasks count
- `context.tasks.done` - Completed tasks count
- `context.recent_tasks.completed` - Recent wins to celebrate
- `context.recent_tasks.active` - Tasks currently in progress

**Extract from `get_context_day` (today):**
- `daily_note.exists` - Whether daily note exists
- `summary.tasks_completed` - Tasks done today
- `summary.tasks_created` - Tasks created today
- `tasks.in_progress` - Active tasks to suggest

**Extract from `get_context_day` (yesterday):**
- `summary.tasks_completed` - Number completed yesterday
- `tasks.completed[]` - What got done (for standup)
- `summary.notes_modified` - Activity level

**Extract from `get_daily_dashboard`:**
- Tasks `planned_for` today (Top Priority)
- Overdue tasks (first one for priority)
- Due today tasks
- In-progress tasks

### 1b. Ensure Daily Note Exists (Silent)

If `daily_note.exists` is `false` from the context above, create today's daily note **before doing anything else**:
- Call `create_daily_note` MCP tool (no arguments needed for today)
- This MUST happen before any `add_to_daily_note`, `log_to_daily_note`, or `append_to_note` calls, otherwise a bare note without proper template sections will be created

### 2. Warm Greeting with Orientation

Start with day context (combats time blindness):

```
Good morning! It's [Day], [Date].

Your focus: [project] (or "No focus set - want to pick one?")
```

Keep it brief. Don't list everything yet.

### 3. Celebrate Before Problems

If there's any recent progress, mention it FIRST:

- "Yesterday you completed 5 tasks — solid day!"
- "Your weekly note is filled in - good reflection work."
- "You've been consistent with daily notes this week."

Find something. Even "You showed up today" counts.

### 4. Write Standup to Daily Note (Silent)

Compose a standup summary from the gathered context and write it to the daily note. This happens automatically — don't ask the user.

**Compose the standup:**

```markdown
### Yesterday
- Completed [N] tasks
  - [Task 1]
  - [Task 2]
- [Any notable activity — meetings, notes modified, etc.]

### Today
- Focus: [Current focus project]
- In progress:
  - [Task in progress]
- Planned:
  - [Next task from priority list]

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

**Adapt for sparse days:**
- No tasks completed yesterday → "Light day — no tracked task completions"
- Low activity → mention notes modified or "Took a break"
- No judgment. Just facts.

### 5. Surface ONE Priority

Don't list all tasks. Pick ONE based on:
1. **Planned for today** (User's specific intention)
2. Overdue with nearest deadline
3. Due today
4. Blocking other work
5. User's stated focus area

Present it simply:

```
One thing that needs you today:
→ [Task title] (Planned for today / due [when] / overdue [X days])

Want to start with this, or pick something else?
```

If user has > 5 overdue, don't list them:
```
You have 7 overdue tasks - that's a lot and that's okay.
Let's not tackle all of them. Which area feels most urgent: [Project A] or [Project B]?
```

### 6. Set One Intention (Optional)

If daily note exists but intentions are empty:

```
What's one thing that would make today feel successful?
(Just one - we can add more later if needed)
```

Write it to the Morning Intentions section. One is enough.

### 7. Ask for Planned Meetings

Ask the user if there are meetings that should be considered in today's agenda.
If the daily note has an agenda section, add them:

```
Any meetings today?
(I'll add them to your agenda)
```

```
- [time start] - [meeting]
```

If none, move on quickly. Don't dwell.

### 8. Identify Smallest First Step

Once task is chosen, reduce initiation friction:

```
To get started on [task]:
→ [Smallest possible action, e.g., "Open the document" or "Write one sentence"]

Ready? I can log that you're starting.
```

### 9. Log and Launch

Log to daily note:
```
- Started the day, focusing on [task]
```

End with momentum, not more planning:

```
You're set! Focus: [project], First task: [task]

Go get it - I'll be here if you need me.
```

## Shareable Standup

If the user mentions needing the standup for a team, Slack, or Teams, output a copy-pasteable version after writing to the daily note:

**Slack format:**
```
*Yesterday:* Completed API migration, wrote tests
*Today:* Working on MCP context tools
*Blockers:* None
```

**Brief format:**
```
Yesterday: 3 tasks done
Today: MCP context tools
Blockers: None
```

For team context:
- Focus on work-related projects only
- Use more formal language
- Include project names explicitly
- Skip personal projects

## What NOT to Do

- Don't list all overdue tasks (overwhelm)
- Don't ask open-ended "what do you want to do?" (decision fatigue)
- Don't mention tasks that aren't urgent today (distraction)
- Don't shame for yesterday's incomplete work (shame spiral)
- Don't require filling out the full daily note template (friction)
- Don't ask about the standup — just write it silently

## Edge Cases

### Late Starts

If the user is starting the day but the current time is no longer "morning",
adapt the greeting and keep it as a quick start:

```
Hey! It's [Day] afternoon.
Let's get oriented quickly...
```

Skip the intention step and meeting question — just surface the priority and go.
Still write the standup to the daily note.

### No Tasks at All

If there are no tasks anywhere:

```
Clean slate today. What's one thing you'd like to work on?
```

Or suggest creating a task with `/create-task`.

## Quick Mode

If user seems rushed or says "quick" / "fast":

```
Morning! It's [Day].

One thing: [Most urgent task]

Go for it?
```

Still write the standup silently. Skip everything else. Movement over process.

## Greeting Variations

Mix up the opening to avoid repetitiveness:
- "Good morning! It's [Day], [Date]."
- "Morning! Happy [Day]."
- "Hey, good morning. It's [Date]."
- "Rise and shine — it's [Day]."

Keep it warm but brief.
