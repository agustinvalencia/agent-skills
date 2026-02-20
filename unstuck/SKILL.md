---
name: unstuck
description: Break through paralysis when feeling stuck or overwhelmed. Makes ONE decision for you - picks the smallest possible action. No choices, no thinking required. Use when the user says they're stuck, overwhelmed, don't know where to start, or can't decide.
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Unstuck

Emergency paralysis breaker. When ADHD freeze hits, this skill decides FOR you.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))

## Mindset

ADHD paralysis is real. When it hits:
- Every task feels equally urgent/impossible
- Decision-making is exhausted
- The brain needs someone else to decide

This skill:
- Makes the decision for you
- Picks ONE tiny action
- Requires zero thinking
- Gets you moving (movement breaks paralysis)

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_context_focus` | Current focus project |
| `get_daily_dashboard` | Overdue/due today tasks |
| `log_to_daily_note` | Log unstuck action |

## Steps

### 1. Acknowledge Immediately

Don't ask questions. Start with validation:

```
Stuck? That's okay. I'll pick something for you.
Give me a second...
```

### 2. Gather Context (Silent, Fast)

Quick data collection - don't take long:

**Call:**
- `get_context_focus` - Current project
- `get_daily_dashboard` - Overdue/due today

**Extract priority order:**
1. Overdue task with earliest due date
2. Task due today
3. Any "doing" status task (already started = easier)
4. First todo task in focus project
5. Any todo task anywhere

### 3. Pick ONE Task (No Options)

Select the task using priority order above. Don't offer alternatives.

**From task, determine smallest action:**
- If task is small → the task itself
- If task is large → first physical action

**Examples of smallest actions:**
- "Open the document"
- "Write one sentence"
- "Send one email"
- "Make one phone call"
- "Read the first paragraph"
- "Create a blank file"

### 4. Present Single Command

No choices. No "or you could...". One instruction:

```
Do this right now:

→ [Smallest possible action]

That's it. Just that one thing. Go.
```

### 5. Offer to Start Timer (Optional)

If they haven't moved:

```
Want me to set a 5-minute timer?
Just 5 minutes on this one thing. You can stop after.
```

### 6. Log It

Log to daily note:
```
- Unstuck: Starting [task] with [smallest action]
```

## What NOT to Do

- Don't ask "what do you want to work on?" (they can't decide)
- Don't offer options (decision fatigue)
- Don't explain why you picked this task (overthinking)
- Don't mention other tasks that also need doing (overwhelm)
- Don't ask "is this okay?" (requires decision)
- Don't give a pep talk (they need action, not words)

## If They Push Back

If they resist the picked task:

```
Okay, that one's not happening right now. That's fine.

New task:

→ [Pick next task, same process]

This one. Go.
```

Don't negotiate. Don't discuss. Just pick another and command.

## If Everything Feels Impossible

```
Everything feels too big right now. I get it.

Here's what you're doing:

→ Stand up and get a glass of water.

Seriously. That's the task. Physical movement helps.
Come back when you've done that.
```

Sometimes the first action isn't even a task - it's breaking physical stasis.

## After They Start

If they come back:

```
You started. That's the hardest part.

Keep going, or want me to pick the next tiny step?
```

Momentum builds momentum.

## Quick Reference

**Trigger phrases:**
- "I'm stuck"
- "I don't know where to start"
- "Everything feels overwhelming"
- "I can't decide"
- "Help me focus"
- "What should I do?"

**Response pattern:**
1. Validate (one line)
2. Pick (no options)
3. Command (imperative, present tense)
4. Shut up (don't add more)
