---
name: process-inbox
description: Process unprocessed inbox items from daily notes. Sort each item into a task, note, or discard. Lightweight daily triage without a full weekly review. Use when the user says "process inbox", "clear inbox", "triage", or wants to sort captured items.
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server (v0.3.0+) with vault configured
---

# Process Inbox

Standalone inbox triage. Sort captured items without doing a full weekly review.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))
**Linking**: Always use `[[wikilinks]]` when writing content that references tasks, projects, or other notes ([rules](../references/LINKING-RULES.md))

## Mindset

Inbox items pile up between weekly reviews:
- Quick captures from `/quick-capture` and `/brain-dump`
- Thoughts dumped during the day
- Items that need a decision but not right now

This skill:
- Finds all unprocessed inbox items
- Presents them in small batches
- Helps sort each one quickly (task, note, discard)
- Respects energy — can stop anytime

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `search_notes` | Find inbox items across daily notes |
| `get_context_focus` | Current project for task assignment |
| `create_task` | Convert items to proper tasks |
| `update_task_status` | Mark processed items as done |
| `append_to_note` | Move items to relevant notes |
| `log_to_daily_note` | Log processing session |

## Steps

### 1. Find Inbox Items (Silent)

**Call:**
```
search_notes(
  query: "## Inbox",
  folder: "Journal",
  context_lines: 10
)
```

**Extract:**
- Unchecked items (`- [ ]`) from Inbox sections
- Plain bullets (`-`) that aren't checked off
- Note which daily note each item came from

**Also check** the current focus context:
```
get_context_focus()
```

### 2. Present Count

```
You have [X] inbox items across [Y] daily notes.

Want to process them now? We'll go in batches of 3-5.
(You can stop anytime — partial processing is fine)
```

**If zero items:**
```
Inbox is clear! Nothing to process.
```
Done. Log and exit.

### 3. Process in Batches

Present 3-5 items at a time:

```
Batch 1:

1. "[Item text]" (from [date])
   → Task, note, or discard?

2. "[Item text]" (from [date])
   → Task, note, or discard?

3. "[Item text]" (from [date])
   → Task, note, or discard?
```

### 4. Execute Decisions

**For each item, based on user's answer:**

**Task:**
```
create_task(
  title: "[item text, cleaned up]",
  project: "[user-specified or focus project]"
)
```
Then mark the inbox checkbox as done:
```
update_task_status(
  note_path: "[daily note path]",
  task_pattern: "[item text]",
  completed: true
)
```

**Note:**
```
append_to_note(
  note_path: "[relevant note]",
  content: "- [item text]"
)
```
Then mark inbox checkbox done.

**Discard:**
Just mark the inbox checkbox as done:
```
update_task_status(
  note_path: "[daily note path]",
  task_pattern: "[item text]",
  completed: true
)
```

### 5. Between Batches

After each batch, check energy:

```
[X] items processed. [Y] remaining.

Continue, or stop here?
```

If they stop, that's completely fine:
```
Processed [X] items. The rest will be here next time.
```

### 6. Close Out

When all items are processed (or user stops):

```
Inbox processing done.

- [N] items processed
- [T] became tasks
- [D] discarded
- [R] remaining

Nice work clearing mental clutter.
```

**Log:**
```
log_to_daily_note("Inbox processing: [N] items processed, [T] tasks created, [D] discarded")
```

## Quick Mode

If user wants fast processing:

```
User: quick inbox
Agent: [X] inbox items. Quick sort:

1. "Call dentist" → task? [y/n]
2. "Redis caching idea" → task? [y/n]
3. "Meeting at 3pm" → discard (past)? [y/n]
```

Yes/no only. No project assignment — everything goes to focus project.

## What NOT to Do

- Don't process items from the current day's inbox (too fresh — let them settle)
- Don't require project assignment for every task (use focus project as default)
- Don't force processing all items (respect energy)
- Don't judge items ("why did you capture this?" — never)
- Don't re-sort items that were already processed (checked off)

## Handling Many Items (>15)

```
You have [X] inbox items — that's a lot, and that's okay.

Options:
1. Process the oldest first (clear the backlog)
2. Just this week's items
3. Quick scan — I'll suggest which ones look like tasks

Pick one, or just start and we'll go batch by batch.
```

## Edge Cases

**Item is vague:**
```
"Think about the thing" — not clear enough for a task.
Want to:
- Clarify it now (what was this about?)
- Keep in inbox for later
- Discard
```

**Item is already done:**
```
"Buy milk" — already done? I'll mark it off.
```

**Item belongs to a different project:**
```
"API refactor idea" — this sounds like [Project X].
Add as task there? Or keep in current focus?
```
