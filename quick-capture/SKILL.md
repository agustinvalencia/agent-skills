---
name: quick-capture
description: Instantly capture a thought, idea, or todo before it disappears. Zero friction - just dumps to daily note or inbox. No categorization, no decisions. Use when the user says "capture", "remember", "note to self", or mentions something they don't want to forget.
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Quick Capture

Instant thought capture. ADHD brains lose thoughts fast - this catches them.

**Read first**: [ADHD Principles](../references/ADHD-PRINCIPLES.md)

## Mindset

ADHD working memory is limited:
- Thoughts appear and vanish
- "I'll remember this" = you won't
- Any friction = thought lost

This skill:
- Captures in under 3 seconds
- Zero decisions required
- Dumps to daily note immediately
- Processing happens later (not now)

## Steps

### 1. Capture Immediately

No preamble. If user says something to capture, capture it:

**Call immediately:**
```
add_to_daily_note(
  content: "- [ ] [captured thought]",
  subsection: "Notes"
)
```

Or use the capture tool if configured:
```
capture_content(
  name: "inbox",
  text: "[captured thought]"
)
```

### 2. Confirm Instantly

One line confirmation:

```
Captured: "[thought]"
```

That's it. Done.

### 3. No Follow-up Questions

Do NOT ask:
- "What project is this for?"
- "When is this due?"
- "Should I create a task?"
- "Want to add more details?"

Capture now. Organize later.

## Formats

**If it sounds like a task:**
```
User: oh I need to call mom
Agent: Captured: "Call mom"
```
→ Add as checkbox: `- [ ] Call mom`

**If it's an idea:**
```
User: what if we used redis for caching
Agent: Captured: "Idea: use redis for caching"
```
→ Add as note: `- Idea: use redis for caching`

**If it's a reminder:**
```
User: remember to bring umbrella tomorrow
Agent: Captured: "Bring umbrella tomorrow"
```
→ Add as checkbox: `- [ ] Bring umbrella tomorrow`

**If it's random:**
```
User: the meeting is at 3pm not 2pm
Agent: Captured: "Meeting at 3pm not 2pm"
```
→ Add as note: `- Meeting at 3pm not 2pm`

## Where to Capture

**Default:** Daily note → Notes section

**If inbox configured:** Use `capture_content` with name "inbox"

**Never:** Don't try to file into projects/tasks (friction)

## Multi-Capture

If user dumps multiple things:

```
User: need to buy milk, also dentist appointment on Friday, and remind me about the proposal
```

Capture all at once:

```
add_to_daily_note(
  content: "- [ ] Buy milk\n- Dentist appointment Friday\n- [ ] Follow up on proposal",
  subsection: "Notes"
)
```

Confirm:
```
Captured 3 items.
```

## Voice-Style Capture

If input is messy/stream-of-consciousness:

```
User: so yeah I was thinking we should probably do the thing with the API before the other thing launches and also Sarah mentioned something about the budget
```

Clean it up minimally:
```
Captured:
- API work before launch
- Sarah mentioned budget (follow up)
```

Preserve meaning, reduce noise, don't overthink.

## What NOT to Do

- Don't ask clarifying questions (thought will be lost)
- Don't suggest organizing it now (friction)
- Don't create formal tasks (overhead)
- Don't add to project notes (requires decision)
- Don't ask which section (decision)
- Don't offer options for where to put it

## After Capture

If user wants to process what they captured:

```
User: actually make that a real task
Agent: [Use create-task skill]
```

But don't suggest this proactively. Capture is capture.

## Trigger Phrases

- "capture"
- "remember"
- "note to self"
- "don't let me forget"
- "quick note"
- "jot this down"
- "before I forget"
- Random thought mid-conversation

## Speed Benchmark

From user input to "Captured:" should be < 3 seconds.
If you're asking questions, you're too slow.
