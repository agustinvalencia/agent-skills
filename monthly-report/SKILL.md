---
name: monthly-report
description: Generate a monthly summary report aggregating weekly data, project progress, and accomplishments. Useful for work updates, personal tracking, or reflection. Outputs a formatted report. Use when the user wants a monthly summary, needs to report progress, or says "monthly report".
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Monthly Report

Generate a comprehensive monthly summary. Good for work updates, self-review, or tracking progress over time.

**Read first**: [ADHD Principles](../references/ADHD-PRINCIPLES.md)

## Mindset

Monthly reports serve different purposes than weekly reviews:
- More formal/shareable output
- Bigger picture patterns
- Useful for work updates or self-advocacy
- Can highlight accomplishments you've forgotten

This skill:
- Aggregates data across weeks
- Focuses on accomplishments (not failures)
- Produces a shareable document
- Keeps ADHD-friendly framing

## Steps

### 1. Determine Month

**If not specified:** Use current month (or previous month if early in new month)

**If specified:** Parse month from user input
- "January" → 2026-01
- "last month" → previous month
- "2026-01" → as specified

### 2. Gather Data (Silent)

Collect data for all weeks in the month:

**Call for each week in month:**
```
get_context_week(week: "2026-W01")
get_context_week(week: "2026-W02")
get_context_week(week: "2026-W03")
get_context_week(week: "2026-W04")
```

**Also call:**
```
get_project_progress()
list_tasks(status_filter: "done")  // Get completed tasks
```

**Aggregate from weekly data:**
- `summary.tasks_completed` - Sum across weeks
- `summary.tasks_created` - Sum across weeks
- `summary.notes_modified` - Sum across weeks
- `summary.active_days` - Sum across weeks
- `tasks.completed[]` - Combine all completed tasks
- `projects[]` - Which projects had activity each week

### 3. Calculate Metrics

**Activity metrics:**
- Total active days / total days in month
- Total notes modified
- Total tasks completed vs created
- Average tasks per week

**Project metrics:**
- Projects with most activity
- Projects with completed tasks
- Progress changes (if trackable)

### 4. Identify Accomplishments

From completed tasks, group by project and highlight:

**Major accomplishments** (prioritise):
- Tasks marked as high priority that were completed
- Projects with significant progress
- Multi-task completions in one area

**Format accomplishments positively:**
- "Completed API migration (5 tasks)"
- "Shipped wedding website MVP"
- "Finished NOMS paper rebuttal → accepted!"

### 5. Identify Patterns

Look for trends across weeks:
- Which projects dominated focus?
- Any weeks with low/high activity? (note, don't judge)
- Recurring themes in task types?

### 6. Generate Report

Present formatted report:

```markdown
# Monthly Report - [Month Year]

## Summary
- **Active days:** X / Y (Z%)
- **Tasks completed:** N
- **Tasks created:** M
- **Notes modified:** P

## Accomplishments

### [Project Name]
- Completed: [task 1], [task 2], [task 3]
- Key win: [highlight]

### [Project Name]
- Completed: [task 1]
- Progress: X% → Y%

## Project Activity

| Project | Tasks Done | Activity |
|---------|------------|----------|
| [name]  | N          | High     |
| [name]  | M          | Medium   |

## Patterns & Notes
- Primary focus this month: [project/area]
- [Any notable patterns]

## Looking Ahead
- Carrying forward: [in-progress items]
- Upcoming: [any known deadlines]
```

### 7. Offer to Save

```
Want me to save this report?
- As a monthly note in Journal/Monthly/
- Copy to clipboard
- Just display (done)
```

If saving, create note at `Journal/Monthly/YYYY-MM.md`

### 8. Log Generation

```
log_to_daily_note("Generated monthly report for [Month Year]")
```

## Report Variants

**Quick summary** (if user says "quick" or "brief"):
```
Monthly Report - [Month]

✓ [N] tasks completed
→ Top project: [name] ([X] tasks)
→ Active [Y] days

Key wins:
- [accomplishment 1]
- [accomplishment 2]
```

**Work-focused** (if user mentions "work" or "for my manager"):
- Group by work projects only
- Emphasise completed deliverables
- More formal language
- Include blockers/dependencies if relevant
- Prefer paragraph long-form writing over a collection of bullet points: Tell a story.
- If the report of the previous month is available try to connect the stories to show progress.

**Personal** (default):
- All projects included
- Celebratory tone
- Include life projects (wedding, moving, etc.)

## What NOT to Do

- Don't list uncompleted tasks (shame)
- Don't compare to "better" months (judgment)
- Don't emphasise low activity weeks (guilt)
- Don't include tasks from other months
- Don't make it overwhelming with data

## Handling Sparse Months

If month had low activity:

```
This was a quieter month - and that's okay.
Sometimes life needs space.

What did happen:
- [whatever did happen, however small]
- [you maintained X]
- [you showed up Y days]
```

Find something. There's always something.

## Week Number Reference

For calculating which weeks belong to a month:
- Week belongs to month if Thursday falls in that month (ISO standard)
- Or simpler: include week if majority of days are in month
- Edge weeks can be mentioned but don't stress precision

## Example Output

```markdown
# Monthly Report - January 2026

## Summary
- **Active days:** 22 / 31 (71%)
- **Tasks completed:** 12
- **Tasks created:** 18
- **Notes modified:** 156

## Accomplishments

### NOMS 2026
- Completed rebuttal submission
- **Paper accepted!** 🎉

### Moving Apartment
- Completed: Book truck, notify landlord, book elevator, buy supplies
- Hired cleaning company (SEM Städ)
- Progress: 15% → 27%

### MarkdownVault MCP
- Implemented context commands
- Added weekly review skill

## Project Activity

| Project | Tasks Done | Notes |
|---------|------------|-------|
| Moving Apartment | 4 | Primary focus |
| NOMS 2026 | 1 | Major milestone |
| MarkdownVault | 0 | Active development |

## Patterns
- January dominated by moving prep and NOMS deadline
- Consistent daily engagement (22/31 days)
- Research projects on hold (expected, given deadlines)

## Looking Ahead
- Moving date approaching (Feb)
- WM Distillation needs attention
- Wedding planning to resume
```
