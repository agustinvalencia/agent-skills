---
name: start-day
description: Start the day with a low-friction morning briefing. Shows ONE priority task, current focus, writes a standup to the daily note, and helps set a single intention. ADHD-friendly - minimal overwhelm, maximum momentum. Use when the user says good morning, wants to start their day, asks what's on the agenda, or says "standup" or "daily standup".
metadata:
  author: mdvault
  version: "3.2"
compatibility: Requires mdvault MCP server with vault configured
---

# Start Day

ADHD-friendly morning routine. Goal: get the user moving with ONE clear action.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))
**Linking**: Always use `[[wikilinks]]` when writing content that references tasks, projects, or other notes ([rules](../references/LINKING-RULES.md))
**Calendars**: Three main calendars — Work, Personal, Hemma (family). Hemma uses prefix conventions: `A:` = Agustín only, `S:` = Sofia only, no prefix = both ([details](../references/CALENDAR-CONVENTIONS.md))

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_context_focus` | Current focus project with task counts |
| `get_context_day` | Today's and yesterday's activity |
| `get_daily_dashboard` | Overdue/due today/in-progress tasks |
| `read_note` | Read today's daily note for pre-planned content |
| `create_daily_note` | Ensure today's note exists |
| `list_tasks` | Check for blocked tasks |
| `get_context_week` | Check if last week's review was done (Mondays only) |
| `append_to_note` | Write standup and intention to daily note |
| `update_metadata` | Mark intention as set |
| `log_to_daily_note` | Log the day start |
| **Apple Calendar MCP** | |
| `today_schedule` | Fetch today's calendar events automatically |
| `find_free_slots` | Identify available deep work windows |

## Steps

### 1. Gather Context (Silent)

Collect state using MCP tools - don't dump this on the user:

**Call these tools (in parallel where possible):**
- `get_context_focus` - Returns focus project with task counts and recent activity
- `get_context_day` with `date: "today"` - Returns daily note status and today's activity
- `get_context_day` with `date: "yesterday"` - Returns yesterday's completions and activity
- `get_daily_dashboard` - Returns overdue/due today/in-progress tasks
- `list_tasks` with `status_filter: "blocked"` - Any blocked work
- If today is **Monday**: `get_context_week` with `week: "last"` - Check if last week's review was done
- `today_schedule` (Apple Calendar MCP) - Today's meetings and events
- `find_free_slots` with `target_date: "today"` (Apple Calendar MCP) - Available time windows

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
- This MUST happen before any `append_to_daily_note`, `log_to_daily_note`, or `append_to_note` calls, otherwise a bare note without proper template sections will be created

### 1c. Read Daily Note for Pre-planned Content (Silent)

**This is critical.** The daily note may already contain content written by previous sessions — weekly planning (`/weekly-planning`), close-day (`/close-day`), or manual edits. Skipping this means ignoring work the user already did.

**Call:** `read_note(note_path: "[today's daily note path]")`

**Scan for pre-filled sections:**

| Section | What to look for | How it affects the flow |
|---------|-----------------|----------------------|
| `## Intention` | Text already written (from close-day or manual) | Skip step 6 — don't ask again, acknowledge it instead |
| `## To Do` | Tasks or plan items (from weekly-planning) | Use these as the priority list in step 5, don't override |
| `## Agenda` | Pre-filled calendar or meeting notes | Merge with live calendar data in step 7, don't duplicate |
| `## Notes` | Any pre-captured thoughts | Mention briefly ("You noted something last night…") |
| `## Logs` | Entries beyond "Created" | Shows prior activity today (late start, already working) |

**Store what you find** — the extracted pre-planned content feeds into steps 4, 5, 6, and 7.

### 1d. Monday Check: Weekly Review Done? (Silent)

If today is **Monday**, check whether last week's weekly review was completed. Use `get_context_week` with `week: "last"` and look for a weekly note with a filled-in review (wins, reflections, or a closed flag).

**If the review is missing or incomplete**, interrupt the normal start-day flow after the greeting (step 2) and suggest doing the weekly review first:

```
Heads up — last week's review hasn't been done yet.
Want to do a quick weekly review before we plan today? I can run /weekly-review now.
```

If the user agrees, invoke the `weekly-review` skill and resume `start-day` afterwards (the review will produce context that feeds into today's standup and planning). If they decline, continue normally — no pressure.

**If the review is done**, continue as normal. No need to mention it.

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
- "You already planned today during your weekly review — future-you thanks past-you!"

If the daily note had pre-planned content (from step 1c), acknowledge the planning effort. Planning ahead is a win worth celebrating, especially for ADHD brains.

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
- Planned for today:
  - [Tasks with planned_for = today, with effort if set]
  - [Items from daily note ## To Do section, if pre-filled — merge, don't duplicate]
- Next up:
  - [Next task from priority list if no planned tasks]

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

Don't list all tasks. Pick ONE based on this priority order:
1. **Pre-planned in daily note** (items from `## To Do` written by weekly-planning or close-day — the user's past self already decided)
2. **Planned for today** (`planned_for` = today — user's specific intention via task metadata)
3. Overdue with nearest deadline
4. Due today
5. Blocking other work
6. User's stated focus area

**Respect prior planning:** If the daily note already has a To Do list, treat it as the user's plan. Don't override it with dashboard priorities unless something is genuinely urgent (overdue + high priority). The whole point of planning ahead is that morning-you doesn't have to re-decide.

**Check effort load:** If multiple tasks are `planned_for` today, sum their `effort` values. If the total exceeds 1d, flag it gently:
```
You've got ~[total] of work planned today — that's ambitious.
Let's pick ONE to start with:
→ [Task title] ([effort] · Planned for today)
```

If only one task is planned, present it simply:

```
One thing that needs you today:
→ [Task title] ([effort] · Planned for today / due [when] / overdue [X days])

Want to start with this, or pick something else?
```

If user has > 5 overdue, don't list them:
```
You have 7 overdue tasks - that's a lot and that's okay.
Let's not tackle all of them. Which area feels most urgent: [Project A] or [Project B]?
```

### 6. Set One Intention

**If the daily note already has an intention (from step 1c):**

Don't ask again. Acknowledge it and move on:

```
Your intention for today: "[pre-written intention]"
Still feels right, or want to adjust?
```

If the user confirms or doesn't respond, keep it. If they want to change it, overwrite the section. Either way, ensure `intention: true` metadata is set.

**If no intention exists:**

Ask the user for a single intention. This anchors the day and prevents "raw dogging" — drifting without direction.

```
What's one thing that would make today feel successful?
(Just one sentence — this is your north star for the day)
```

**Write the intention to the daily note:**
```
append_to_note(
  note_path: "[today's daily note path]",
  content: "[intention text]",
  subsection: "Intention"
)
```

**Mark the intention as set:**
```
update_metadata(
  note_path: "[today's daily note path]",
  metadata_json: '{"intention": true}'
)
```

If the user declines or skips, that's fine — don't push. The `intention: false` metadata stays, which helps spot patterns later (e.g., "you set an intention 3 out of 5 days this week").

### 7. Show Today's Calendar & Suggest a Schedule

Use the calendar data gathered in step 1 to show meetings and free time. No need to ask — it's already fetched.

**If the daily note already has an `## Agenda` section (from step 1c):** Merge with live calendar data. If the pre-filled agenda matches the live data, don't rewrite it — just confirm. If there are new events or changes, update the section.

**If there are events today:**
```
Your calendar today:
- [time] [event title]
- [time] [event title]

Free blocks for deep work:
- [start]–[end] ([duration])
- [start]–[end] ([duration])
```

**If no events:**
```
Calendar is clear today — full day for deep work.
```

**If calendar is unavailable** (MCP error or no calendars configured), fall back to asking:
```
Any meetings today? (I'll add them to your agenda)
```

#### 7b. Suggest When to Do What

Map today's tasks to the available free slots. This is a **suggestion, not a rigid schedule** — ADHD brains rebel against over-structured plans but benefit from a loose shape to the day.

**Inputs:**
- Free slots from `find_free_slots` (step 1)
- Today's tasks: pre-planned (step 1c `## To Do`), `planned_for` today, priority task (step 5)
- Effort estimates from task metadata (if set)

**Matching rules:**
1. **Deep work tasks** (coding, writing, complex thinking) → longest free slot, preferably morning
2. **Quick tasks** (effort ≤ 0.5h) → short gaps between meetings or end of day
3. **Meetings prep** → slot immediately before the meeting
4. **Tasks without effort estimates** → assume 1h as a default for scheduling purposes
5. If total task effort exceeds available free time, flag it and help trim (don't silently overschedule)

**Present as a gentle suggestion:**
```
Here's a rough shape for the day:

  [09:00–11:30]  → [Deep work task] (2h estimated)
  [11:30–12:00]  → [Quick task] (30min)
  [12:00–13:00]  lunch
  [13:00–13:30]  → Prep for [meeting name]
  [13:30–14:30]  [Meeting]
  [14:30–16:00]  → [Second task] (1h estimated)

This is just a suggestion — shuffle as you like.
```

**If there's more work than time:**
```
You've got ~[total effort] of tasks but ~[free hours] of free time.
I'd suggest focusing on just:
→ [Top priority task]
→ [One quick win if there's a gap]

The rest can wait — better to finish one thing than half-start three.
```

**Write the suggested schedule to the daily note:**
```
append_to_note(
  note_path: "[today's daily note path]",
  content: "[schedule as above]",
  subsection: "Agenda"
)
```

#### 7c. Generate Daily Visual Timeline (MANDATORY)

**Do NOT skip this step.** Always generate the mermaid gantt chart after writing the text schedule and append it to the Agenda section. This gives the user a glanceable visual of their day with a red "now" marker line.

**Use real datetimes** (`YYYY-MM-DD HH:mm`) so mermaid renders proper thick bars AND shows the todayMarker (red current-time line). Use human-readable durations (`1h`, `30m`, `2h30m`, `90m`).

**Categorise blocks into sections:**
- `Deep Work` — coding, writing, complex thinking tasks
- `Meetings` — calendar events (mark as `crit` for red colour)
- `Admin` — quick tasks, emails, prep
- `Personal` — gym, lunch, errands, commute

**Template:**
````
```mermaid
---
config:
  gantt:
    barHeight: 30
    barGap: 6
    topPadding: 30
    sectionFontSize: 12
---
gantt
    title [Day name] [Date]
    dateFormat YYYY-MM-DD HH:mm
    axisFormat %H:%M
    tickInterval 1hour

    section Deep Work
    [Task label]       :YYYY-MM-DD HH:mm, [duration]

    section Meetings
    [Meeting label]    :crit, YYYY-MM-DD HH:mm, [duration]

    section Personal
    [Activity label]   :YYYY-MM-DD HH:mm, [duration]
```
````

**Duration formats:** `1h`, `2h`, `30m`, `90m`, `2h30m`, `55m`, etc.

**Example:**
```
    section Deep Work
    HPO-007 Honeymoon research       :2026-03-16 08:00, 2h
    WMD-025 prep                     :2026-03-16 11:00, 1h

    section Meetings
    90pct presentation 6GVE          :crit, 2026-03-16 10:00, 1h
    Rehearsal 10pct                  :crit, 2026-03-16 14:00, 30m

    section Personal
    Bike to Medley                   :2026-03-16 12:00, 10m
    Gym                              :2026-03-16 12:10, 1h
    Bike home + lunch                :2026-03-16 13:10, 30m
```

**Write to daily note:**
```
append_to_note(
  note_path: "[today's daily note path]",
  content: "[mermaid gantt block as above]",
  subsection: "Agenda"
)
```

**When to skip:** If the user is in Quick Mode, has no calendar data, or has only one task — don't generate a schedule. Just point them at the one thing.

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
- Don't ignore pre-planned content in the daily note — past-you already did the thinking
- Don't overwrite pre-filled sections (Intention, To Do, Agenda) — merge or confirm instead
- Don't re-ask for an intention if one was already set
- Don't create a rigid minute-by-minute schedule (ADHD brains rebel against over-structure)
- Don't silently overschedule — if tasks exceed free time, say so and help prioritise

## Edge Cases

### Late Starts

If the user is starting the day but the current time is no longer "morning",
adapt the greeting and keep it as a quick start:

```
Hey! It's [Day] afternoon.
Let's get oriented quickly...
```

Still ask for the intention (even a late-day anchor helps), but skip past meetings — only show what's left.
Still write the standup to the daily note. For the suggested schedule, only use remaining free slots from now onwards — don't show a plan for hours that already passed.

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
