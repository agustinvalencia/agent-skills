---
name: read-paper
description: Guided multi-pass paper reading with active engagement. Overcomes initiation friction, enforces proven reading techniques, captures insights, and extracts atomic zettels. Use when the user wants to read/study a paper, says "read paper", "study paper", or shares a paper link/title.
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Read Paper

Guided academic paper reading. Beats initiation friction and enforces multi-pass technique.

**Read first**: [ADHD Principles](../references/ADHD-PRINCIPLES.md)

## Mindset

ADHD + papers = struggle:
- Hard to start (initiation friction)
- Default to reading straight through (hyperfocus)
- Poor retention without active engagement
- Forget to use techniques you know work

This skill:
- Makes starting trivially easy
- Externalises the multi-pass technique
- Forces active engagement at each step
- Captures insights before they're forgotten
- Supports resuming interrupted reading

## Literature Note Metadata

Track reading progress in frontmatter:

```yaml
type: literature
title: "Paper Title"
authors: ["Author 1", "Author 2"]
year: 2024
url: "https://..."
status: skimming | reading | completed | abandoned
pass_1_date: null
pass_2_date: null
pass_3_date: null
research_question: "What brought me to this paper?"
verdict: null | relevant | not-relevant | revisit-later
```

## Steps

### 1. Setup (Lower the Barrier)

**If paper specified:**
```
User: read paper "Attention is All You Need"
Agent: [Search for existing literature note or prepare to create]
```

**If no paper specified:**
```
What paper are you reading?
(Title, link, or just describe it)
```

**Create or open literature note:**

If note exists:
```
Found existing note for this paper.
Status: [status] | Pass 1: [done/not done] | Pass 2: [done/not done]

Resume where you left off?
```

If new:
```
Creating literature note for: [Title]
```

**Call:** Create literature note with template, or open existing

### 2. Research Question (Before Reading)

This is crucial for retention:

```
Before we dive in:
What question are you hoping this paper answers?

(This primes your brain to read actively)
```

Capture response to `research_question` in frontmatter and note body.

**Update metadata:**
```
update_metadata(
  note_path: "[literature note]",
  metadata_json: '{"research_question": "[their question]", "status": "skimming"}'
)
```

### 3. Pass 1: Skim (5-10 minutes max)

Set expectations:

```
Pass 1: Quick skim (5-10 min)

Read ONLY:
- Title and abstract
- Section headings
- Figures and captions
- Conclusion

DON'T read the full text yet.

Ready? Go skim, then come back.
```

**When they return:**

```
Quick skim done. Based on that:

1. What's this paper about (one sentence)?
2. Is it relevant to your question: "[their research question]"?

[ ] Relevant - continue to Pass 2
[ ] Not relevant - stop here, note why
[ ] Unsure - continue to Pass 2 to clarify
```

**Capture to note:**
```
append_to_note(
  note_path: "[literature note]",
  content: "## Pass 1 Notes\n- One-liner: [their summary]\n- Relevance: [their assessment]",
  subsection: "Summary"
)
```

**Update metadata:**
```
update_metadata(
  note_path: "[literature note]",
  metadata_json: '{"pass_1_date": "[today]", "verdict": "[relevant/not-relevant/revisit-later]"}'
)
```

**If not relevant:**
```
Paper marked as not relevant. That's a valid outcome.
Knowing what NOT to read deeply is valuable.

Note saved. Moving on.
```

Log and exit.

### 4. Pass 2: Understand (20-30 minutes)

```
Pass 2: Understanding the contribution

Read:
- Introduction fully
- Methods (skim for approach, not details)
- Key results (focus on main findings)

Guiding questions:
- What problem are they solving?
- What's their approach?
- What did they find?

Take your time. Come back when ready.
```

**Offer timer:**
```
Want me to check in after 25 minutes? (Pomodoro-style)
```

**When they return:**

```
Pass 2 complete. Let's capture:

1. What problem does this paper address?
2. What's their core approach/method?
3. What are the main findings?
```

**Capture responses to Key Ideas section:**
```
append_to_note(
  note_path: "[literature note]",
  content: "## Pass 2 Notes\n### Problem\n[response]\n\n### Approach\n[response]\n\n### Findings\n[response]",
  subsection: "Key Ideas"
)
```

**Update metadata:**
```
update_metadata(
  note_path: "[literature note]",
  metadata_json: '{"pass_2_date": "[today]", "status": "reading"}'
)
```

**Offer break:**
```
Good progress. Take a break?

[ ] Yes - we'll resume at Pass 3
[ ] No - continue to Pass 3 now
[ ] Done for now - paper captured, can go deeper later
```

### 5. Pass 3: Deep Read (Optional, as needed)

```
Pass 3: Deep dive

Now read sections relevant to YOUR question:
- "[their research question]"

Focus on:
- Details that matter for your work
- Things you might cite
- Methods you might use

Capture quotes or insights as you go.
Ready?
```

**During reading, offer quick capture:**
```
Found something worth noting? Tell me and I'll add it.
```

Capture to Quotes or Key Ideas section.

**When complete:**

```
Deep read done. Wrapping up:

1. Key insight for your research?
2. Any quotes to save?
3. Questions this raised?
```

**Update metadata:**
```
update_metadata(
  note_path: "[literature note]",
  metadata_json: '{"pass_3_date": "[today]", "status": "completed"}'
)
```

### 6. Discussion (Optional)

Offer Feynman-style discussion:

```
Want to discuss this paper? I can:
- Ask you to explain it back (tests understanding)
- Challenge assumptions or gaps
- Help connect to your research
- Just listen while you think out loud

Or skip - the notes are saved.
```

**If yes, discussion prompts:**

```
Explain it back:
"Pretend I haven't read this paper. What's the key contribution in 2-3 sentences?"
```

```
Challenge:
"What's the main weakness or limitation of this approach?"
```

```
Connect:
"How does this relate to [their research question / current project]?"
```

Capture insights from discussion to note.

### 7. Extract Zettels (Optional)

```
You've captured several insights. Want to extract any as permanent zettels?

From your notes:
1. "[insight 1]"
2. "[insight 2]"
3. "[insight 3]"

Which are worth making atomic? (numbers, 'all', or 'skip')
```

**For each selected insight:**

```
Creating zettel: "[insight title]"

Checking for connections...
```

**Call:** `suggest_related_notes(note_path: "[literature note]")`

**Present connections:**
```
Suggested connections:
- [[existing-zettel-1]] - [why related]
- [[existing-zettel-2]] - [why related]
- [[project-note]] - [why related]

Add these links? (yes/no/select)
```

**Create zettel:**
```
# [Atomic insight title]
**Origin**: [[literature-note-title]]

## Core Idea
[The insight in their words]

## Context & Connections
- Related to [[connection-1]]
- Related to [[connection-2]]
- Relevant for [[project]]

## References
- Source: [[literature-note-title]]
```

**Update literature note:**
```
append_to_note(
  note_path: "[literature note]",
  content: "- [[zettel-title]]",
  subsection: "Atomic Notes (Extracted)"
)
```

### 8. Wrap Up

```
Paper reading complete: [Title]

Status: [completed]
Passes: 1 ✓ | 2 ✓ | 3 [✓/skipped]
Zettels extracted: [N]

Literature note: [[note-path]]

Nice work engaging deeply with this paper.
```

**Log:**
```
log_to_daily_note("Completed reading: [Paper Title]. [N] zettels extracted.")
```

## Resuming Interrupted Reading

If user returns to a paper they started:

```
Welcome back to: [Paper Title]

You left off at: Pass [N]
Research question: "[their question]"

Ready to continue?
```

Pick up from the appropriate pass.

## Quick Mode

If user just wants to skim:

```
User: quick skim this paper
Agent: Quick skim mode.

Read: title, abstract, figures, conclusion.

Come back with:
- One sentence summary
- Relevant or not?

Go.
```

Skip passes 2-3, just capture verdict.

## What NOT to Do

- Don't let them skip the research question (key for retention)
- Don't rush through passes (defeats the purpose)
- Don't require all passes (pass 1 might be enough)
- Don't force zettel extraction (optional)
- Don't make it feel like homework

## Paper Sources

Handle various inputs:

- **Title only**: Create note, user fills details
- **URL/DOI**: Extract metadata if possible
- **PDF mention**: Note the file location
- **"That paper about X"**: Help identify, then proceed
