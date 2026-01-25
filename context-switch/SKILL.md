---
name: context-switch
description: Properly close current work context and open a new one. More thorough than set-focus - captures state, processes open loops, and fully transitions. Use when the user is switching between major contexts (work→personal, deep work→meetings) or ending one work session to start another.
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Context Switch

Full context transition with proper closure. More thorough than quick focus switch.

**Read first**: [ADHD Principles](../references/ADHD-PRINCIPLES.md)

## Mindset

Major context switches are costly for ADHD:
- Old context bleeds into new
- Open loops create anxiety
- Mental residue blocks new focus
- Incomplete transitions waste energy

This skill:
- Fully closes the current context
- Captures any open loops
- Clears mental state
- Opens new context fresh

## When to Use

Use context-switch (vs set-focus) when:
- Switching between life areas (work ↔ personal)
- Ending a deep work session
- Before/after meetings
- Major project transitions
- End of day transitions

Use set-focus for:
- Quick switches within same area
- Temporary project hops
- When you know you'll return soon

## Steps

### 1. Acknowledge the Transition

```
Context switch time. Let's close out properly and start fresh.
```

### 2. Capture Current Context

**Call:** `get_context_focus()`
**Call:** `get_context_day(date: "today")`

Identify:
- Current focus project
- What was being worked on
- Any in-progress tasks

### 3. Close Current Context

**3a. Capture open loops:**
```
Before we switch - anything floating in your head from [Current Context]?
- Unfinished thoughts
- Things to remember
- Follow-ups needed

(Quick capture, or skip if clear)
```

Capture anything to Inbox:
```
add_to_daily_note(
  content: "[captured items]",
  subsection: "Inbox"
)
```

**3b. Note where you left off:**
```
Where are you leaving [Current Project]?
(One line - e.g., "halfway through section 3" or "waiting on email response")
```

Log to project:
```
log_to_project_note(
  project_path: "[path]",
  content: "Paused: [their note]. Context switch to [new context]."
)
```

**3c. Explicit closure:**
```
Closing out [Current Context]. ✓

Open loops captured.
State saved.
You can let it go now.
```

### 4. Mental Transition

Brief pause between contexts:

```
[Current Context] is closed.

Take a breath.

Ready for [New Context]?
```

This pause is intentional. Context switches need a moment.

### 5. Open New Context

**If switching to specific project:**
```
set_focus(
  project: "[new project]",
  note: "Context switch from [previous]"
)
```

**If switching to general area (e.g., "personal time"):**
```
Entering: Personal time

No specific project focus. That's fine.
What would you like to do?
```

**If switching to meetings/reactive mode:**
```
Entering: Meeting mode

Focus cleared. You're in reactive mode now.
Deep work is saved for when you return.
```

### 6. Orient to New Context

Quick orientation based on context type:

**For project:**
```
get_context_focus()  // Now shows new project

[Project Name]
- [X] tasks open
- Last activity: [what]
- Suggested next: [task]
```

**For general area:**
```
Personal time. Options:
- Pick a personal project
- Free form / rest
- Something specific in mind?
```

**For meetings:**
```
You have: [meetings from calendar if available]
Or just in reactive mode until you're done.
```

### 7. Log Transition

```
log_to_daily_note("Context switch: [Previous] → [New]. [Brief note if relevant]")
```

## Quick Context Switch

If user wants fast transition:

```
User: switch to personal
Agent: Switching: Work → Personal

Quick save from work:
- Was on: [project]
- Note: [if any]

Personal time now. What's up?
```

Skip the detailed capture questions.

## Common Transitions

**Work → Personal:**
```
Leaving work mode.
- [Capture any lingering work thoughts]
- Work is done for now.

Personal time. Work will be there tomorrow.
```

**Personal → Work:**
```
Entering work mode.
- [Capture any personal to-dos that popped up]
- Personal stuff is captured.

Work focus. What's the priority?
```

**Deep work → Meetings:**
```
Pausing deep work.
- Saved: [what you were doing]
- You can resume after meetings.

Meeting mode now. Reactive time.
```

**Meetings → Deep work:**
```
Meetings done. Transitioning to deep work.

Any follow-ups from meetings to capture?
[Capture if yes]

Clear. Deep work time.
What's the focus?
```

## What NOT to Do

- Don't rush the transition (it needs a moment)
- Don't list all tasks from old context (overwhelming)
- Don't carry guilt from old context
- Don't make capture mandatory (friction)
- Don't skip the mental transition pause

## Context Bleed Prevention

If user keeps mentioning old context:

```
I notice you're still thinking about [old context].
That's captured and waiting.

Right now we're in [new context].
Can you give yourself permission to be here?
```

Help them let go of the old context.

## Emergency Context Switch

If user must switch immediately:

```
User: gotta switch now / urgent
Agent: Quick switch.

[Old context]: Paused. (I'll note: interrupted)
[New context]: Go.

We can clean up later.
```

Don't block urgent switches with process.

## End of Day Context Switch

Special case - switching from "work mode" to "done for the day":

```
Closing out for the day.

Quick capture of anything lingering:
[capture]

Day closed. Tomorrow is a fresh start.

(Consider running /close-day for full wind-down)
```

Suggest close-day skill for more thorough evening routine.
