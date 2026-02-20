---
name: monthly-report
description: Generate a monthly summary report aggregating weekly data, project progress, and accomplishments. Useful for work updates, personal tracking, or reflection. Outputs a formatted report. Use when the user wants a monthly summary, needs to report progress, or says "monthly report".
metadata:
  author: mdvault
  version: "3.1"
compatibility: Requires mdvault MCP server (v0.3.4+) with vault configured
---

# Monthly Report

Generate a comprehensive monthly summary with separate work and personal sections. The work section is designed to be copy-pasteable for work reports.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))

## Mindset

Monthly reports serve different purposes than weekly reviews:
- More formal/shareable output (especially the work section)
- Bigger picture patterns across weeks
- Useful for work updates, self-advocacy, and manager syncs
- Can highlight accomplishments you've forgotten

This skill:
- Produces a structured note in `Journal/Monthly/`
- Separates work and personal clearly
- Builds a narrative per project (not just bullet points)
- Connects to the previous report to show continuity
- Keeps ADHD-friendly framing throughout

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `create_monthly_report` | Create the monthly report note from template |
| `get_activity_report` | Aggregated monthly/weekly metrics |
| `get_context_week` | Per-week breakdown for the period |
| `get_project_progress` | All projects with completion rates |
| `get_project_status` | Kanban view per project |
| `list_projects` | Active project list with context (work/personal) |
| `list_tasks` | Query completed/active tasks |
| `search_notes` | Find previous monthly report |
| `read_note` | Read previous report for continuity |
| `append_to_note` | Write sections to the report note |
| `log_to_daily_note` | Log report generation |
| `get_metadata` | Check intention/closed flags on daily notes |
| `update_metadata` | Mark report as final |

## Steps

### 1. Determine Period

**If not specified:** Use current month, or previous month if we're in the first week of a new month.

**If specified:** Parse from user input:
- "January" → 2026-01
- "last month" → previous month
- "2026-01" → as specified
- "since last report" → find last report and use its end date as start

**For non-calendar periods** (e.g., work reporting cycles):
Ask if the period matches the calendar month or has custom boundaries.

### 2. Find Previous Report

Search for the most recent monthly report to establish continuity.

**Call:**
```
search_notes(query: "type: monthly-report", folder: "Journal/Monthly")
```

If found, read it:
```
read_note(note_path: "Journal/Monthly/YYYY-MM.md")
```

**Extract from previous report:**
- What projects were active
- What "Looking Ahead" items were mentioned
- The narrative thread to continue
- The period_end date (to determine this report's period_start)

### 3. Gather Data (Silent)

Collect everything before generating. Call in parallel:

**Activity data:**
- `get_activity_report(month: "YYYY-MM")` — aggregated metrics
- `get_context_week` for each week in the period — weekly breakdown

**Project data:**
- `list_projects(status_filter: "active")` — all active projects
- `get_project_progress()` — completion rates across all projects
- For each active project: `get_project_status(project_name: "...")` — task-level detail

**Task data:**
- `list_tasks(status_filter: "done")` — completed tasks (filter by period)
- `list_tasks(status_filter: "doing")` — in-progress tasks (carry-overs)

**Habit data:**
- `get_metadata` on each daily note in the period — collect `intention`, `closed`, `meds`, `exercise` flags
- Count totals: days with intention set, days closed, days with daily note created

### 4. Create the Report Note

**Call:**
```
create_monthly_report(period: "YYYY-MM")
```

Or with custom period boundaries:
```
create_monthly_report(
  period: "YYYY-MM",
  period_start: "YYYY-MM-DD",
  period_end: "YYYY-MM-DD"
)
```

This creates `Journal/Monthly/YYYY-MM.md` with the template structure.

### 5. Categorise Projects

Split projects by context for the work/personal sections:

**Work projects:** context = "work" or "uni"
**Personal projects:** context = "personal" or "family"

For each project, prepare:
- Progress change (compare to previous report if available)
- Tasks completed this period
- Key milestones or achievements
- Current status and next steps

### 6. Write the Work Section

This section should be **narrative-style, formal enough to share with a manager**. Not bullet points — tell the story.

**Call:** `append_to_note` to write under `## Work`

#### 6a. Work Summary

A 2-3 paragraph high-level narrative of the reporting period. Connect to the previous report's "Looking Ahead" section.

```
append_to_note(
  note_path: "Journal/Monthly/YYYY-MM.md",
  content: "[narrative summary]",
  subsection: "Summary"
)
```

**Writing style:**
- Paragraph form, not bullet points
- Lead with accomplishments
- Connect to previous period: "Following up on last month's focus on X..."
- Mention key decisions and their outcomes
- Professional but not dry

**Example:**
> This period saw significant progress on the NOMS conference preparation,
> culminating in the paper acceptance. The focus shifted mid-month from
> paper revisions to presentation preparation and travel logistics.
> On the tooling side, the mdvault MCP server received several quality-of-life
> improvements including task cancellation support and automated logging.

#### 6b. Work Project Subsections

For each work project with activity, create a subsection under `### Projects`:

```
append_to_note(
  note_path: "Journal/Monthly/YYYY-MM.md",
  content: "#### [Project Name]\n\n[narrative + key items]",
  subsection: "Projects"
)
```

**Per project, include:**
- 1-2 sentence narrative of what happened
- Key completed tasks (grouped logically, not as a raw list)
- Progress: X% → Y% (if measurable)
- Current status

**Example:**
> #### NOMS 2026
> Paper accepted after successful rebuttal. Shifted focus to presentation
> preparation and conference logistics. Registration confirmed, travel
> arrangements in progress.
>
> - Completed: rebuttal submission, camera-ready version, conference registration
> - Progress: 60% → 85%
> - Next: finalise presentation slides, book flights

**For projects with no activity:**
Include only if they were mentioned in the previous report's "Looking Ahead".
Note them briefly: "No significant progress this period — expected given [reason]."

#### 6c. Work Looking Ahead

What carries into next period:

```
append_to_note(
  note_path: "Journal/Monthly/YYYY-MM.md",
  content: "[looking ahead items]",
  subsection: "Looking Ahead"
)
```

Include:
- In-progress tasks that carry over
- Upcoming deadlines in the next period
- Planned focus areas
- Any blockers or dependencies

### 7. Write the Personal Section

More relaxed tone. Celebrate life progress.

#### 7a. Personal Highlights

Brief acknowledgment of personal wins:

```
append_to_note(
  note_path: "Journal/Monthly/YYYY-MM.md",
  content: "[highlights]",
  subsection: "Highlights"
)
```

**Format:** Can be bullet points or short narrative. Less formal than work.

**Example:**
> - Moving apartment: key handover done, most logistics sorted
> - Honeymoon planning: narrowed down to Sardinia, researching areas
> - Started weekly review habit — maintained 3/4 weeks

#### 7b. Personal Project Subsections

Same pattern as work but lighter touch. Only include projects with notable activity.

### 8. Write Metrics

Aggregate numbers for the period:

```
append_to_note(
  note_path: "Journal/Monthly/YYYY-MM.md",
  content: "[metrics table]",
  subsection: "Metrics"
)
```

**Format:**
```markdown
| Metric | This Month | Last Month |
|--------|-----------|------------|
| Active days | X / Y | A / B |
| Tasks completed | N | M |
| Tasks created | P | Q |
| Notes modified | R | S |

**Work projects active:** X
**Personal projects active:** Y
**Projects completed:** Z
```

**Habits:**
```markdown
| Habit | This Month | Last Month |
|-------|-----------|------------|
| Intention set | X / Y days | A / B days |
| Day closed | X / Y days | A / B days |
| Meds | X / Y days | A / B days |
| Exercise | X / Y days | A / B days |
```

Frame habit trends gently — this is self-awareness data, not a scorecard:
- Improving → "Intention-setting is becoming a habit — nice trend"
- Steady → "Consistent with closing your days"
- Declining → "Fewer intentions set this month. Some months are like that — no pressure"

Include comparison to previous month if available. Frame trends positively.

### 9. Write Reflections

Ask the user for their input. Keep it optional and light:

```
Any reflections on the month? Things like:
- What worked well
- What you'd do differently
- Patterns you noticed
- How you're feeling about your projects

A sentence or two is plenty. Or we can skip this.
```

Write to `## Reflections` subsection.

### 10. Finalise

Present a summary of the report:

```
Monthly Report — [Period] — Done

Work:
- [X] projects covered
- Key: [1-2 sentence highlight]

Personal:
- [Y] projects covered
- Key: [1-2 sentence highlight]

The report is at Journal/Monthly/YYYY-MM.md
Status is "draft" — want me to mark it as final?
```

If they confirm:
```
update_metadata(
  note_path: "Journal/Monthly/YYYY-MM.md",
  metadata_json: '{"status": "final"}'
)
```

**Log:**
```
log_to_daily_note("Generated monthly report for [Period]")
```

## Quick Mode

If user wants a fast report:

```
Quick monthly report — [Period]:

Work:
- [Project A]: [one-liner]
- [Project B]: [one-liner]

Personal:
- [one-liner highlight]

Stats: [X] tasks completed, [Y] active days

Saved to Journal/Monthly/YYYY-MM.md
```

Skip reflections, skip detailed narratives, skip comparison to last month.

## Work-Only Mode

If user says "work report" or "for my manager":

- Only generate the `## Work` section content
- More formal language
- Present it in a format ready to copy-paste
- Offer to output it separately from the vault note

```
Here's your work report for [Period]:

---
[Full work section content, clean markdown]
---

This is also saved in the monthly note.
Want me to adjust the tone or add anything?
```

## Connecting Reports (The Story)

When a previous report exists, build continuity:

1. **Reference the previous "Looking Ahead"**: Address each item — did it happen?
2. **Track project arcs**: "Project X moved from planning to execution this month"
3. **Note trajectory**: "Third month of sustained progress on Y" or "Returning to Z after a pause"
4. **Acknowledge shifts**: "Priorities shifted from A to B due to [reason]"

This turns individual monthly reports into chapters of an ongoing narrative.

## What NOT to Do

- Don't list uncompleted tasks (shame)
- Don't compare negatively to "better" months
- Don't emphasise low activity weeks
- Don't make the personal section feel like a performance review
- Don't include tasks from outside the period
- Don't overwhelm with raw data — tell the story
- Don't make it longer than needed — respect the reader's time

## Handling Sparse Months

If the month had low activity:

```
This was a quieter month — and that's okay.
Sometimes life needs space. Here's what did happen:

- [Whatever did happen, however small]
- [Any maintenance or continuation]
- [You showed up X days]
```

For the work section specifically, frame quieter periods:
- "Consolidation period after the intense push on X"
- "Focus was on [non-vault-tracked work like meetings, reading, thinking]"
- "Laying groundwork for next month's deliverables"
