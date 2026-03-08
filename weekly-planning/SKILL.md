---
name: weekly-planning
description: Proactive week planning — the forward-looking complement to weekly-review. Surveys what's on the plate, helps pick ONE main goal, estimates capacity, identifies blockers early, and writes the plan to the weekly note. ADHD-friendly — 5-10 minutes max, no sprawling todo lists. Use when the user wants to plan their week, says "plan the week", or asks "what should I focus on this week".
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Weekly Planning

ADHD-friendly week planning. Goal: leave with ONE clear focus, 2-3 supporting tasks, and blockers flagged — in under 10 minutes.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))
**Linking**: Always use `[[wikilinks]]` when writing content that references tasks, projects, or other notes ([rules](../references/LINKING-RULES.md))

## Mindset

Planning triggers overwhelm for ADHD brains. Too many goals, too many options, too much ambition. This skill:
- Keeps it to ONE main goal (not a sprawling todo list)
- Accounts for real capacity (meetings, energy, existing commitments)
- Flags blockers early so they don't cause paralysis mid-week
- Takes 5-10 minutes — planning is a sprint, not a marathon
- Celebrates the act of planning itself (showing up to plan is a win)

## MCP Tools Used

This skill relies on these MCP tools:

| Tool | Purpose |
|------|---------|
| `list_tasks` | In-progress, todo, and blocked tasks |
| `list_projects` | Active projects and areas |
| `get_project_status` | Kanban view per project |
| `get_context_week` | Current week's activity so far |
| `create_weekly_note` | Create this week's note if it doesn't exist |
| `log_to_daily_note` | Log planning session to today's daily note |
| `set_focus` | Set the week's focus project |
| `get_context_focus` | Current focus project |
| `append_to_note` | Write plan to weekly note |
| `update_metadata` | Schedule tasks via `planned_for` |
| `create_daily_note` | Pre-fill daily notes for the week |

## Steps

### 1. Gather Context (Silent)

Collect everything first — process before presenting. Call these in parallel:

**Call these tools:**
- `get_context_week` — current week's activity so far
- `get_context_focus` — what's currently focused
- `list_tasks` with `status_filter: "doing"` — in-progress tasks
- `list_tasks` with `status_filter: "todo"` — pending tasks
- `list_tasks` with `status_filter: "blocked"` — blocked work
- `list_projects(status_filter: "active")` — active projects and areas

**Extract and prepare:**
- In-flight work: tasks already in "doing" (commitments that carry over)
- Overdue tasks: anything past its due date
- Upcoming deadlines: tasks due this week or next
- Blocked work: tasks that need unblocking before progress
- Current focus: what project has momentum
- Project health: which projects have activity, which are quiet

### 2. Orient and Celebrate

Start with context and acknowledgment:

```
Let's plan the week! It's [Day], [Date] — [Week ID].

[If mid-week: "We're already [X] days in, so let's plan the rest."]
[If Monday/start: "Fresh week ahead."]
```

**Acknowledge what's already in motion:**
```
Here's what's on your plate:
- [X] tasks in progress
- [Y] tasks queued up
- Focus: [current focus project or "none set"]
[If any wins from the week so far: "Already completed [N] tasks this week — nice start."]
```

Frame existing work as progress, not burden. Don't list all tasks — just counts and the focus.

### 3. Surface What Matters

Present a focused view of commitments and opportunities. Don't dump everything.

**Deadlines and urgency (if any):**
```
Coming up this week:
- [Task with deadline] — due [date]
- [Overdue task] — [X] days overdue
```

Cap at 3-5 items. If more, summarise:
```
You have [X] deadlines this week. The most pressing: [top 1-2].
```

**Project momentum:**
```
Where you have momentum:
- [Project A]: [brief — e.g., "3 tasks done last week, 2 in progress"]
- [Project B]: [brief — e.g., "quiet for 2 weeks"]
```

Only show 2-3 projects. Focus on momentum, not guilt about quiet ones.

**Blocked work:**
```
[If blocked tasks exist:]
Heads up — these are blocked:
- [Task]: [blocker reason if known]

Worth unblocking early this week?
```

### 4. Pick ONE Main Goal

This is the core of the skill. ONE goal, not five.

**Suggest based on data — don't ask cold:**

If there's a clear candidate (deadline, momentum, carry-over from last week):
```
Based on what I see, your main goal this week could be:
-> [Goal — framed as an outcome, not a task list]

[Why: "You've got momentum here" / "Deadline on Friday" / "This has been stalled and a push would help"]

Does that feel right, or is something else more important?
```

If no clear candidate:
```
No obvious frontrunner this week. What feels most important?

Some options:
1. [Project A] — [one-liner why]
2. [Project B] — [one-liner why]
3. Something else entirely

Pick one. Everything else is secondary.
```

**Rules:**
- ONE goal only. Resist the urge to add more.
- Frame as an outcome ("Ship the API migration") not a process ("Work on API stuff")
- Accept whatever they choose — don't argue

### 5. Identify 2-3 Supporting Tasks

Once the goal is chosen, identify the tasks that serve it.

```
To make progress on [goal], here are the key tasks:

1. [Task — with effort if known]
2. [Task — with effort if known]
3. [Task — with effort if known]

Want to schedule these across the week?
```

**Rules:**
- Max 3 supporting tasks. Less is more.
- Pull from existing tasks in the vault — don't invent new ones
- If the user wants to add more, gently redirect:
  ```
  That's 5 tasks — getting ambitious. Let's keep 3 as the plan
  and treat the others as stretch goals. Which 3 matter most?
  ```
- If tasks don't exist yet, offer to create them: "Want me to create a task for that?"

### 6. Flag Blockers

Surface anything that could derail the week:

```
[If blockers exist:]
Watch out for:
- [Blocker 1 — e.g., "Waiting on feedback for [[TASK-ID]]"]
- [Blocker 2 — e.g., "No meeting scheduled to discuss X"]

Any of these you can unblock today?
```

```
[If no blockers:]
No obvious blockers — clear path ahead.
```

Keep it brief. The point is awareness, not problem-solving (unless they want to act now).

### 7. Write Plan to Weekly Note

Create the weekly note and write the plan.

**Ensure the note exists:**
**Call:** `create_weekly_note(week: "today")` — idempotent

**Write the plan:**
```
append_to_note(
  note_path: "[weekly note path, e.g., Journal/2026/Weekly/2026-W11.md]",
  content: "## Plan\n\n**Main goal:** [ONE goal]\n\n**Supporting tasks:**\n- [[task-1]]\n- [[task-2]]\n- [[task-3]]\n\n**Blockers to watch:**\n- [blocker or 'None']",
  subsection: "Plan"
)
```

### 8. Schedule Tasks (Optional)

If the user wants tasks distributed across the week:

```
Want me to spread these across the week?
I'll keep it light — no more than 2-3 tasks per day.
```

**If yes:**
- Distribute across weekdays only (Monday-Friday) unless user says otherwise
- Respect effort estimates if available — don't overload any day
- Flag if a day looks heavy:
  ```
  Wednesday already has [X] planned — want to move something to Thursday?
  ```

**For each scheduled task:**
```
update_metadata(
  note_path: "[task note path]",
  metadata_json: '{"planned_for": "YYYY-MM-DD"}'
)
```

**Create daily notes for days with planned tasks:**
```
create_daily_note(date: "YYYY-MM-DD")
log_to_daily_note(
  date: "YYYY-MM-DD",
  content: "## Plan\n- Focus: [weekly goal]\n- [[task-1]]\n- [[task-2]]"
)
```

Keep daily pre-fills minimal — the `start-day` skill will flesh things out each morning.

### 9. Set Focus

If the main goal maps to a project, set it as the focus:

```
set_focus(
  project: "[project name]",
  note: "Weekly goal: [goal]"
)
```

```
Focus set: [Project Name]
```

If focus is already correct, skip silently.

### 10. Close Positively

```
Week planned — [Week ID]

Main goal: [ONE thing]
Supporting tasks: [2-3 items]
[If scheduled: "Spread across [X] days"]
[If blockers: "Watching [N] blockers"]

Nice work planning. That's 80% of the battle.
```

**Log to daily note:**
```
log_to_daily_note("Planned the week ([Week ID]). Main goal: [goal]")
```

## What NOT to Do

- Don't set more than ONE main goal (overwhelm)
- Don't list all tasks in the vault (paralysis)
- Don't create a detailed hour-by-hour schedule (rigidity kills ADHD flow)
- Don't shame about last week's unfinished work (that's weekly-review territory)
- Don't force scheduling if they just want a goal (friction)
- Don't require meetings/calendar info to proceed (blocking)
- Don't spend more than 10 minutes (planning fatigue)
- Don't add tasks to the plan that weren't the user's choice

## Quick Mode

If user seems rushed or says "quick" / "fast":

```
Quick plan for [Week]:

You have [X] tasks in progress, [Y] queued.
[If deadlines: "[Task] due [date]"]

What's the ONE goal this week?
→ [Their answer]

Set. Logged. Go.
```

Skip supporting tasks, skip scheduling, skip blockers. Just the goal and done.

## Mid-Week Planning

If user triggers this on Wednesday or later:

```
We're mid-week — let's plan the rest.

So far: [X] tasks done, [Y] in progress.
[Deadlines remaining this week]

What's the ONE thing to focus on for the rest of the week?
```

Shorter flow. Don't pretend it's a fresh week. Acknowledge what's already happened and plan the remaining days only.

## If They're Overwhelmed

If the user seems paralysed by options or says "I have too much":

```
I hear you — there's a lot going on.

Let's ignore the full list. Just tell me:
What's the ONE thing that, if you made progress on it, would make you feel good this week?

Everything else can wait.
```

Radically simplify. One goal. No supporting tasks. No scheduling. Just the anchor.

## Adapting to Energy

Read the user's energy from their messages:
- **High energy** -> Full flow with scheduling and daily pre-fills
- **Medium energy** -> Goal + supporting tasks, skip scheduling
- **Low energy** -> Quick mode — just the goal
- **Very low** -> "Let's just pick one focus and call it planned"

Don't ask "how's your energy?" — infer from response length and tone.
