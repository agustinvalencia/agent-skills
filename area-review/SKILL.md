---
name: area-review
description: Deep dive review of a single area's health against its defined standards. Shows trends over 4 weeks, detects patterns, and offers to spawn corrective projects. Use when the user wants to review an area, says "how is my health tracking", "area review", or "check [area name]".
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Area Review

Deep dive into a single area's health against its defined standards. Shows trends, detects patterns, and offers corrective action.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))
**Linking**: Always use `[[wikilinks]]` when writing content that references tasks, projects, or other notes ([rules](../references/LINKING-RULES.md))

## Mindset

Areas are ongoing responsibilities — they never "fail". A standard being unmet is information, not judgment. This skill surfaces patterns so the user can make informed adjustments, not feel bad about their habits.

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_area_report` | Area criteria vs actuals for a specific period |
| `list_projects` | Find areas (kind: area) and their spawned projects |
| `get_project_status` | Kanban view of area's active tasks |
| `read_note` | Read area note for standard text and context |
| `create_project` | Spawn corrective project if needed |
| `create_task` | Create tasks within area or spawned project |
| `update_metadata` | Adjust criteria targets if needed |
| `append_to_note` | Write review findings to area note |
| `log_to_note` | Log review event |

## Steps

### 1. Identify the Area

If the user specifies an area name, use it. Otherwise, list areas and ask:

**Call:** `list_projects(kind_filter: "area")`

```
Which area would you like to review?
- Health — exercise, meds
- Finances — budget, banking
- Work Admin — reimbursements, HR
```

### 2. Gather Context (Silent)

**Call these in parallel:**
- `read_note(note_path: "[area note path]")` — get the Standard section and health_criteria
- `get_area_report(area: "[name]", period: "week")` — current week
- `get_area_report(area: "[name]", period: "[week-1]")` — last week
- `get_area_report(area: "[name]", period: "[week-2]")` — 2 weeks ago
- `get_area_report(area: "[name]", period: "[week-3]")` — 3 weeks ago
- `list_projects(status_filter: "active")` — find spawned projects linked to this area

### 3. Current Status

Start with where things stand right now:

```
[Area Name] — this week ([Week ID])

[For each criterion:]
- [Label]: [actual]/[target] [✓ or — ]

[If area has spawned projects:]
Active projects:
- [Project name] — [status/progress]
```

### 4. Trend (4-Week View)

Show the trajectory — are things improving, declining, or stable?

```
4-week trend:
         W08  W09  W10  W11
Exercise  1    2    2    3   ↑ improving
Meds      7    5    6    5   → fluctuating
```

**Frame the trend:**
- **Improving** → "Exercise is trending up — the gym slot seems to be working"
- **Stable (met)** → "Meds have been consistent — solid"
- **Stable (unmet)** → "Exercise has been at 2/3 for three weeks — a pattern worth noticing"
- **Declining** → "Meds slipped the last two weeks — any idea what changed?"

### 5. Pattern Detection

Look for correlations in the daily note data:

- **Day-of-week patterns**: "Exercise never happens on meeting-heavy days (Tue/Thu)"
- **Streak analysis**: "Longest meds streak this month: 5 days. Weekends break it."
- **Context correlation**: "Exercise happened on days with gym in the calendar"

Present only patterns that are actionable. Don't overanalyse.

```
Patterns I noticed:
- Exercise happens on gym-calendar days — having it scheduled makes it stick
- Meds get missed on weekends — maybe a different reminder?
```

### 6. Reflect and Adjust

Ask one open question:

```
Is the standard still right, or does it need adjusting?
- "Move 3x/week" — still the right target?
- "Daily meds" — realistic, or should we accept 5/7?

(Adjusting a target isn't giving up — it's calibrating to reality)
```

**Based on response:**
- **Keep as is** → no action
- **Adjust target** → `update_metadata` on area note to change `health_criteria.target`
- **Spawn project** → `create_project` with a concrete corrective goal
- **Create task** → `create_task` for a specific action

### 7. Log and Close

**Write findings to area note:**
```
log_to_note(
  note_path: "[area note path]",
  content: "Area review ([date]): [criterion] [actual]/[target] [trend]. [One insight]."
)
```

```
Area review done — [Area Name]

[One-sentence summary: "Exercise is improving, meds need a weekend strategy"]

Come back anytime with /area-review.
```

## What NOT to Do

- Don't present unmet criteria as failures
- Don't compare to other people's standards
- Don't suggest multiple changes at once (overwhelm)
- Don't deep-dive into individual task status (that's /project-review)
- Don't run this at night (close-day is for winding down, not reviewing)
- Don't force action — sometimes awareness is enough

## Quick Mode

If the user just wants a quick check:

```
[Area Name] this week:
- Exercise: 2/3 (↑ from 1 last week)
- Meds: 5/7 (→ same)

Looking good. Anything to adjust?
```

## If No Criteria Defined

```
[Area Name] doesn't have measurable criteria yet.

Your standard says: "[Standard text from note]"

Want to add some trackable metrics? For example:
- A daily note field to count (like exercise or meds)
- A target per week or month

Or keep it qualitative — that's fine too.
```
