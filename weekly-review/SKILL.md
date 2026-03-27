---
name: weekly-review
description: Conduct an ADHD-friendly weekly review of the vault. Celebrates wins first, reviews progress compassionately, and plans next week with focus on ONE main goal. No shame, no overwhelm. Use when the user wants to do their weekly review or reflect on their week.
metadata:
  author: mdvault
  version: "3.2"
compatibility: Requires mdvault MCP server with vault configured
---

# Weekly Review

ADHD-friendly weekly review. Goal: reflect without shame, plan without overwhelm, leave with clear next steps.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))
**Linking**: Always use `[[wikilinks]]` when writing content that references tasks, projects, or other notes ([rules](../references/LINKING-RULES.md))

## Mindset

Weekly reviews can trigger shame spirals for ADHD brains. This skill:
- Leads with wins (dopamine first)
- Builds a narrative (your week as a story, not a report card)
- Reviews stalled work compassionately, one task at a time
- Processes inbox so nothing lingers
- Focuses on ONE goal for next week
- Keeps it under 20 minutes

## MCP Tools Used

This skill relies on these MCP tools:

| Tool | Purpose |
|------|---------|
| `get_context_week` | Week activity breakdown (current + previous) |
| `get_activity_report` | Activity metrics and heatmap |
| `get_dashboard_report` | Structured vault-wide metrics: velocity, project progress, stale notes, overdue/upcoming/high-priority tasks |
| `generate_visual_report` | Generate PNG dashboard for embedding in weekly note |
| `get_project_progress` | All projects with completion rates |
| `list_projects` | Active project list |
| `list_tasks` | Task queries (stalled, overdue, in-progress) |
| `get_project_status` | Kanban view per project |
| `get_area_report` | Area health criteria vs actuals for a period |
| `get_metadata` | Check intention/closed flags on daily notes |
| `search_notes` | Find inbox items across daily notes |
| `create_daily_note` | Create daily notes for next week's planned days |
| `create_weekly_note` | Create next week's note from template |
| `append_to_note` | Write to weekly notes (wins, reflections, plans) |
| `add_to_inbox` | Quick-capture thoughts during review |
| `create_task` | Convert inbox items to proper tasks |
| `complete_task` | Mark tasks done during cleanup |
| `cancel_task` | Cancel stalled/irrelevant tasks |
| `update_metadata` | Reschedule tasks (update due_date, planned_for) |
| `log_to_daily_note` | Log review completion |
| `log_to_note` | Log project decisions |

## Steps

### 1. Gather Context (Silent)

Collect everything first — process before presenting. Call these in parallel:

**Call these tools:**
- `get_context_week` — current week's activity
- `get_context_week` with `week: "last"` — previous week for comparison
- `get_activity_report` with current week (e.g., `week: "2026-W08"`) — metrics and heatmap
- `get_dashboard_report(activity_days: 14)` — vault-wide metrics with velocity and stale notes
- `get_project_progress` — all projects with completion rates
- `list_tasks` with `status_filter: "doing"` — in-progress tasks (potential stalls)
- `list_tasks` with `status_filter: "todo"` — pending tasks (check for overdue)
- `search_notes` with `query: "## Inbox"`, `folder: "Journal"`, `context_lines: 10` — find unprocessed inbox items from this week's daily notes
- `get_metadata` on each daily note for the week (paths from `get_context_week` days) — check `intention` and `closed` fields
- `generate_visual_report` — start generating the dashboard PNG early so it's ready if wanted at close

**Extract and prepare:**
- Wins: `tasks.completed` list + `summary.tasks_completed` count
- Activity trend: compare `summary.active_days` and `summary.tasks_completed` across weeks
- Velocity: from dashboard report — `velocity.tasks_per_week_2w` vs `tasks_per_week_4w` (accelerating or slowing?)
- Focus pattern: check `days[].focus` to see what dominated
- Stalled detection: tasks in "doing" that appear in both this and last week's context + `activity.stale_notes` from dashboard
- Overdue: use `overdue` array from dashboard report (pre-computed with `days_overdue`)
- High priority: use `high_priority` array from dashboard report
- Upcoming deadlines: use `upcoming_deadlines` array from dashboard report (next 14 days)
- Inbox items: unchecked items from `## Inbox` sections in daily notes
- Intention pattern: count days with `intention: true` vs `false` from daily note metadata
- Closure pattern: count days with `closed: true` vs `false`

### 2. Celebrate Wins First

ALWAYS start here. Find wins even in "bad" weeks:

```
Let's look at your week!

You completed [X] tasks this week [vs Y last week].
[Active days] out of 7 days with activity.

Here's what went well:
- [Concrete achievement 1]
- [Concrete achievement 2]
- [Progress framed positively]
```

**Trend framing (compare to last week):**
- More completed → "Up from [Y] last week — nice momentum"
- Same → "Consistent — steady progress"
- Fewer → "Different pace this week — some weeks are like that"

**Velocity framing** (from dashboard report):
- 2w > 4w average → "Picking up speed — [X] tasks/week recently vs [Y] over the month"
- 2w ≈ 4w → "Steady pace at ~[X] tasks/week"
- 2w < 4w → "Lighter pace recently — some weeks need that"

**Reframe low activity compassionately:**
- 0 tasks completed → "You created X tasks — planning is work too"
- Low note count → "Quality over quantity — some weeks are like that"
- Missed days → "Life happens. You're here now doing this review."

Never say: "You didn't complete any tasks" or "You failed to..."

### 3. Build the Week's Narrative

Don't just list metrics — tell the story of the week:

```
This week's story:
You focused mainly on [project/area]. [What happened there — brief].
[If multiple projects: "You also touched [project 2] with [brief]"].
[If context switches: "Quite a bit of switching between X and Y this week"].
```

**Intention pattern** — weave in naturally:

- All/most days with intention → "You set an intention [X] out of [Y] days — strong anchoring."
- Mixed → "Intention set [X] of [Y] days. The days with one tended to be more focused." (only if true from the data)
- Few/none → "Most days went without a set intention this week. Worth trying next week — even a one-liner helps anchor the day."

Don't lecture. State the data, offer a gentle nudge if the pattern is low, and move on.

This helps the user see patterns:
- Were they focused or scattered?
- Did they work on what matters?
- Is there momentum building on something?
- Are they setting intentions or raw-dogging their days?

Keep it to 4-5 sentences. Not a full report.

### 4. Executive Project Walk-Through

Brief status for each active project and area. Don't deep-dive — that's what `/project-review` is for.

**Call:** `list_projects(status_filter: "active")`

Split into two sections based on `kind` (default "project" when absent):

```
Project check-in:
- [Project A]: [X]% done, [what moved this week or "quiet this week"]
- [Project B]: [X]% done, [what moved or "no activity"]

Areas of focus:
- [Area A]: [N] active tasks, [what moved or "steady"]
- [Area B]: [N] active tasks, [what moved or "quiet this week"]
```

Flag projects with no activity in 2+ weeks:
```
[Project D] has been quiet for [X] weeks. Worth keeping active, or pause it?
```

Offer but don't push:
- For projects: "Want to pause any of these?" / "Should we close [project] — is it done or no longer relevant?"
- For areas: "Want to pause any of these?" (don't offer to close/archive areas — they're ongoing)

If they decide to pause/close, update the project and log to the project note:
```
log_to_note(
  note_path: "[project note path]",
  content: "Project [paused/closed] during weekly review ([week]). Reason: [brief reason from user]"
)
```

#### 4b. Area Standards Check

After the project/area walk-through, check how areas with `health_criteria` are tracking. This is the automated measurement step.

**Call:** `get_area_report(area: "[area name]", period: "[current week]")` for each area that has `health_criteria`.

**Present compassionately — patterns, not scores:**

```
Area standards:
- Health: exercise 2/3 this week, meds 5/7 — weekends slipped
- Finances: no criteria set (qualitative — SEB migration on track)
```

**If a standard is consistently unmet (2+ weeks in a row):**
```
Health exercise has been below target for [N] weeks.
Want to create a project to address it, or adjust the target?
```

Options:
- **Spawn project** → `create_project` with a concrete 4-week goal
- **Adjust target** → update `health_criteria` in the area frontmatter
- **Leave it** → no action, just awareness

**If all standards are met:**
```
All area standards met this week — steady.
```

**If no areas have criteria:**
Skip this step silently.

**Write one-liner to weekly note:**
```
append_to_note(
  note_path: "[weekly note path]",
  content: "- Health: exercise [X]/[target], meds [X]/[target]",
  subsection: "Review"
)
```

**Do NOT:**
- Show this as a report card or score
- Shame for unmet criteria
- Surface this at night (that's close-day territory — and close-day doesn't do area checks)

**Energy checkpoint:**
```
That's the big picture. Ready to dig into inbox and stalled tasks, or want to skip ahead to planning next week?
```

Only ask if you sense energy dropping (short replies, "sure", "ok"). If they're engaged, flow straight into step 5.

### 5. Process Inbox Items

Go through unprocessed items from this week's daily notes.

**Present items in batches of 3-5:**

```
You have [X] inbox items from this week. Let's quickly process them:

1. "[Item text]" — Task, note, or discard?
2. "[Item text]" — Task, note, or discard?
3. "[Item text]" — Task, note, or discard?
```

**For each item, based on user's answer:**
- **Task** → `create_task(title: "...", project: "[relevant project]")`
- **Note** → `append_to_note` to relevant note, or `add_to_inbox` if unsure where
- **Discard** → Mark checkbox as done in the daily note: `update_task_status(note_path: "...", task_pattern: "...", completed: true)`

**If many items (>10):**
```
There are [X] inbox items — quite a few. Want to:
1. Go through them all (we'll batch them)
2. Just the important-looking ones
3. Skip for now — they'll be there next week
```

Respect their energy. Don't force processing if they're tired.

### 6. Review Stalled and Overdue Tasks

This is the most emotionally loaded step. Present counts first and let the user choose depth.

**Show the summary first:**
```
You have [X] overdue tasks and [Y] stalled tasks (in progress for 2+ weeks).
Want to:
1. Go through them all one by one
2. Just the overdue ones
3. Quick sweep — I'll list them and you say keep/cancel/reschedule
4. Skip — deal with them during the week
```

**If they choose to review, overdue tasks first:**

```
These tasks are past due:
```

For each overdue task:
```
[Task ID]: [Title]
Due: [date] ([X days/weeks ago])
Project: [project]

What should we do?
- Reschedule (when?)
- Break down into smaller pieces
- Cancel — no longer relevant
- Just do it now (if small)
```

**Then stalled tasks (in "doing" for 2+ weeks):**

```
These have been in progress for a while:
```

For each:
```
[Task ID]: [Title]
In progress since: [date]
Project: [project]

Still working on this? Options:
- Keep going (update with a note on where you are)
- Break it down — what's the actual next step?
- Move back to todo (not actively working)
- Cancel — it's not going to happen
```

**Execute decisions immediately:**
- Reschedule → `update_metadata(note_path: "...", metadata_json: '{"due_date": "YYYY-MM-DD"}')`
- Cancel → `cancel_task(task_path: "...", reason: "Cancelled during weekly review")`
- Complete → `complete_task(task_path: "...")`
- Break down → `create_task` for subtasks
- Log progress → `log_to_note(note_path: "...", content: "...")`

**Log decisions to affected project notes:**
After processing tasks for a project, log a summary to its project note:
```
log_to_note(
  note_path: "[project note path]",
  content: "Weekly review ([week]): [Rescheduled [[TASK-ID]] to MM-DD / Cancelled [[TASK-ID]] / Broke down [[TASK-ID]] into subtasks]"
)
```
Batch per project — one log entry per project covering all decisions, not one per task.

**Energy checkpoint:**
If the user has been making lots of decisions, check in:
```
Good progress. Want to do the reflection step, or jump straight to planning next week?
```

### 7. Update This Week's Note (Reflection)

Write the review into the finishing week's note.

**Ensure the note exists first:**
**Call:** `create_weekly_note(week: "today")` — idempotent; creates the current week's note if it doesn't exist yet.

**Then call:** `append_to_note` on the current week's note path (e.g., `Journal/2026/Weekly/2026-W08.md`)

**Wins section:**
```
I'll add these wins to your weekly note:
- [Win 1]
- [Win 2]
- [Win 3]

Anything else you want to add?
```

Write to `## Wins` or `## Reflections` subsection.

**Challenges (reframe as information):**
```
What got in the way this week?
(Not what you did wrong — what external factors or ADHD moments happened?)
```

One sentence is fine. Write to weekly note.

**One takeaway:**
```
What's ONE thing you're taking away from this week?
(A lesson, a pattern you noticed, or just how you feel about it)
```

Optional — skip if they're done reflecting.

### 8. Plan Next Week

Create next week's note and set ONE focus.

**Call:** `create_weekly_note(week: "today + 1w")`

**Suggest a focus based on data — don't just ask cold:**

If last week's focus is still in progress or a project has strong momentum, lead with that:
```
Looking at next week:
- [Upcoming deadlines if any]
- [Carry-over from stalled task review]
- [Current project momentum]

[If last week's focus is unfinished: "Last week's focus was [X] — still relevant, or time to shift?"]
[If clear momentum: "You've got momentum on [project] — continue with that as the focus?"]
[If no obvious candidate: "What's the ONE main focus for next week? (Everything else is secondary)"]
```

Offer the suggestion but accept whatever they choose. One focus only.

**After they choose:**
- Write the focus to next week's note under `## Focus` or `## Goals`
- If they mention specific tasks, schedule them by setting `planned_for`:
  ```
  update_metadata(
    note_path: "[task note path]",
    metadata_json: '{"planned_for": "YYYY-MM-DD"}'
  )
  ```
- **Distribute across workdays only** — default to Monday–Friday. Don't schedule tasks on Saturday/Sunday unless the user explicitly asks. If a deadline falls on a weekend, schedule the task for the Friday before.
- **Check effort capacity:** Sum `effort` values of tasks planned per day. Flag if a single day exceeds ~1d:
  ```
  Monday has ~2d of work planned — that's tight.
  Want to spread [task] to Tuesday instead?
  ```
  If tasks don't have `effort` metadata, skip the capacity check — don't prompt the user to estimate effort for every task, as that adds friction. Only flag obvious overloads (e.g., 4+ tasks planned on a single day).
- Resist adding more than 2-3 planned tasks per day. Less is more.

**Create daily notes and pre-fill the week:**

After scheduling is confirmed, create daily notes for each workday that has planned tasks or relevant context:

```
create_daily_note(date: "YYYY-MM-DD")  // for each workday with planned tasks
```

**Fix the "Created" log entry:** `create_daily_note` logs `- HH:MM : Created` using the current time, which is misleading for pre-created notes. After creating each note, edit the Logs section to replace the `Created` entry with:
```
- [[YYYY-MM-DD]] HH:MM: Created during weekly review
```
Where the wikilink date and time are *today's* (when the review session is happening), not the note's date.

Pre-fill each daily note with a lightweight agenda via `log_to_daily_note`:
```
log_to_daily_note(
  date: "YYYY-MM-DD",
  content: "## Plan\n- Focus: [weekly focus]\n- [[task-1-title]]\n- [[task-2-title]]\n- [deadline] is due [today/in X days]"
)
```

Keep it minimal — just the focus reminder, planned tasks as wikilinks, and any deadlines for that day or upcoming. Don't over-plan; the `start-day` skill will flesh things out on the morning of.

Only create notes for days with something specific to show. Empty days don't need a note yet.

**Log to the focus project note:**
```
log_to_note(
  note_path: "[focus project note path]",
  content: "Set as next week's focus ([week]). Scheduled tasks: [[TASK-ID-1]], [[TASK-ID-2]]"
)
```

```
Next week's focus is set: [ONE thing]
[If tasks planned: "Scheduled [X] tasks across [Y] days"]
[If daily notes created: "Pre-filled [Y] daily notes with your plan"]
```

#### 8b. Generate Week at a Glance (MANDATORY)

**Do NOT skip this step.** Always generate the mermaid gantt chart after scheduling and append it to the **next week's** weekly note. This gives a glanceable visual of the planned week.

**Use date-based format** — each task spans one or more days. Group by theme/project.

**Mark critical/deadline items** with `:crit` for red highlighting.

**Template:**
````
```mermaid
gantt
    title [Week ID] — [date range]
    dateFormat YYYY-MM-DD
    axisFormat %a %d

    section [Theme 1]
    [Task label]     :[id], YYYY-MM-DD, Nd

    section [Theme 2]
    [Task label]     :crit, [id], YYYY-MM-DD, Nd

    section Admin
    [Task label]     :[id], YYYY-MM-DD, Nd
```
````

**Guidelines:**
- Group tasks into 3-5 sections by theme (project name, life area, or category)
- Tasks spanning multiple days get multi-day bars (e.g., "FMA-005 Draft" spanning Mon–Wed)
- Single-day tasks get `1d`
- Use `:crit` for deadline-sensitive items or blockers
- Keep section names short (e.g., "WMD Infra", "Honeymoon", "Admin")
- Only include scheduled/planned tasks, not the full backlog

**Write to next week's note:**
```
append_to_note(
  note_path: "[next week's note path]",
  content: "[mermaid gantt block as above]",
  subsection: "Plan"
)
```

### 9. Close Positively

```
Weekly Review Done — [Week]

Wins: [brief list or count]
Inbox: [X] items processed
Decisions: [stalled/overdue tasks addressed]
Next week's focus: [ONE thing]

Nice work reflecting. See you next week.
```

**Offer visual dashboard** (already generated during step 1):
```
Want me to embed the visual dashboard in your weekly note?
(PNG chart with activity timeline, project progress, and task breakdown — already generated)
```

If yes:
```
append_to_note(
  note_path: "[weekly note path]",
  content: "![[assets/dashboards/dashboard-vault.png]]"
)
```

**Log to daily note:**
```
log_to_daily_note("Completed weekly review for [Week]. Focus for next week: [X]")
```

## What NOT to Do

- Don't start with problems or overdue counts
- Don't list all incomplete tasks (shame trigger)
- Don't require detailed reflection (decision fatigue)
- Don't set multiple goals for next week (overwhelm)
- Don't compare negatively to "productive" weeks
- Don't use words like "failed", "didn't", "should have"
- Don't rush through inbox processing (each item deserves a moment)
- Don't skip celebrating wins even if the week was rough
- Don't force all steps if user is low energy — ask what to skip

## If the Week Was Hard

Some weeks are survival mode. That's okay.

```
Looks like this was a tough week — and that's completely valid.
You're here doing this review, which means you're still in the game.

What's one small thing you can acknowledge yourself for this week?
```

Find the win. There's always something.

For hard weeks, offer a lighter review:
```
Want to do the full review, or just:
1. Note one win and set next week's focus
2. Process inbox only
3. Just close the week — no review needed

Any of these count as a weekly review.
```

## Quick Mode

If user wants a fast review:

```
Quick review for [Week]:
- Completed: [X] tasks
- Active projects: [list with one-liner each]
- Overdue: [count] tasks
- Inbox: [count] items unprocessed
- Focus next week: [ask for ONE thing]

Done. Logged.
```

Skip reflection, skip inbox processing, skip stalled task review.

## Adapting to Energy

Read the user's energy from their messages:
- **High energy** → Full review with all steps, process all inbox items
- **Medium energy** → Standard review, batch inbox items, brief reflection
- **Low energy** → Quick mode or "just wins + next week focus"
- **Very low** → "Let's just close the week. You showed up."

Don't ask "how's your energy?" — infer from response length and tone.
