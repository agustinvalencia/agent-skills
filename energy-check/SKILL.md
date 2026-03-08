---
name: energy-check
description: Quick energy self-assessment before picking a task. Matches current energy level to appropriate tasks from the backlog. Prevents starting something that will be abandoned in 10 minutes. Use when the user says "energy check", "what should I work on", "what can I do right now", "low energy", or "how's my energy".
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Energy Check

Match your energy to your tasks. 1-2 minutes, zero judgment.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))
**Linking**: Always use `[[wikilinks]]` when writing content that references tasks, projects, or other notes ([rules](../references/LINKING-RULES.md))

## Mindset

ADHD energy is unpredictable:
- High energy moments get wasted on admin
- Low energy moments turn into guilt spirals from trying hard tasks
- Starting the wrong task leads to abandonment in 10 minutes
- "I should be doing X" ignores what the brain can actually do right now

This skill:
- Takes 1-2 minutes total
- Matches available energy to appropriate tasks
- All energy levels are valid and productive
- Logs energy for pattern tracking over time
- Prevents the start-abandon-shame cycle

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `list_tasks` | Available tasks to match against |
| `get_context_focus` | Current focus project |
| `get_daily_dashboard` | Due/overdue/in-progress tasks |
| `log_to_daily_note` | Log energy level for pattern tracking |

## Steps

### 1. Ask ONE Question

No preamble. One question:

```
How's your energy right now?

- High — deep focus possible, brain is firing
- Medium — can do routine work, steady pace
- Low — easy wins only, keep it light
```

That's it. One question. Wait for the answer.

If the user already stated their energy in the trigger (e.g., "low energy", "I'm wiped"), skip the question and use what they said.

### 2. Gather Tasks (Silent)

While processing their answer, collect context quickly:

**Call in parallel:**
- `get_context_focus()` — current project
- `get_daily_dashboard()` — due/overdue/in-progress
- `list_tasks(status_filter: "todo")` — available tasks

### 3. Match Energy to Tasks

Filter and sort tasks by energy level:

**High energy** — deep focus possible:
- Tasks with high effort (`1d+`)
- Tasks requiring creative thinking or problem-solving
- Blocked or complex tasks that need sustained attention
- Architecture decisions, writing, coding new features
- Prioritize: overdue high-effort tasks first, then due soon, then focus project

**Medium energy** — routine work:
- Tasks with moderate effort (`0.5d` - `1d`)
- Familiar work, incremental progress
- Reviews, updates, follow-ups
- Tasks already started (lower re-initiation cost)
- Prioritize: in-progress tasks first, then due soon, then focus project

**Low energy** — easy wins:
- Tasks with low effort (`0.5d` or less)
- Admin, filing, quick replies, small fixes
- Tasks with clear, simple next actions
- Anything that can be done on autopilot
- Prioritize: quickest wins first, then overdue small tasks

**When effort metadata is missing:** Use task title and context to estimate complexity. Short, concrete tasks (e.g., "send email to X") are low energy. Open-ended tasks (e.g., "design new architecture") are high energy.

### 4. Suggest 1-3 Matching Tasks

Present a short list based on the energy match. No more than 3:

```
[Energy level] energy — here's what fits:

→ [Task 1 title] ([effort] · [due info or project])
→ [Task 2 title] ([effort] · [due info or project])
→ [Task 3 title] ([effort] · [due info or project])

Any of these feel right?
```

If only one task matches well, present just that one:

```
[Energy level] energy — this one's a good match:

→ [Task title] ([effort] · [due info or project])

Want to start on this?
```

**Cap at 3.** Don't overwhelm with options.

### 5. Log Energy to Daily Note

Log the energy check for pattern tracking. Do this silently after presenting tasks:

```
log_to_daily_note(
  content: "Energy check: [high/medium/low]"
)
```

This builds a record over time. Patterns like "always low energy on Mondays" or "high energy after lunch" become visible in retrospect.

### 6. Set Focus on Chosen Task (Optional)

If the user picks a task, offer to set focus:

```
Want me to set focus on this? I can log it so you're locked in.
```

If yes, use the appropriate tool to update focus/status. If they just want to go, let them go.

## What NOT to Do

- Don't judge energy levels ("you should push through")
- Don't suggest high-effort tasks for low energy (recipe for abandonment)
- Don't list all available tasks (overwhelm)
- Don't ask follow-up questions about why energy is low (not a therapy session)
- Don't suggest "maybe try a coffee first" (patronizing)
- Don't frame low energy as a problem to fix
- Don't skip the logging — the pattern data is valuable long-term

## Edge Cases

### No Tasks Available

```
No open tasks right now. That's either very organized or very suspicious.

Want to capture something to work on? Or just enjoy the calm.
```

### All Tasks Are High Effort but Energy Is Low

```
Everything on the list is heavy right now. That's okay.

Options:
→ Break a big task into a smaller first step
→ Do something not on the list (email, tidying, reading)
→ Take a break — low energy is your brain saying something

No shame in any of these.
```

### User Says "I Don't Know" for Energy Level

```
That's fine. Let's figure it out:

Could you read a dense document right now?
- Yes → you're probably Medium or High
- No way → you're Low, and that's fine

[Then proceed with that level]
```

Keep it to one follow-up, not a quiz.

### Energy Changes Mid-Session

If the user comes back and says energy shifted:

```
Energy shifted? That's normal. Let me re-match.

[Re-run matching with new level]
```

No commentary about the change. Just adapt.

## Quick Mode

If user seems rushed or already stated their level:

```
User: low energy, what can I do
Agent: Low energy — easy wins:

→ [Task 1] ([effort])
→ [Task 2] ([effort])

Logged. Pick one and go.
```

Skip the question. Match, suggest, log, done.

## Trigger Phrases

- "energy check"
- "how's my energy"
- "what should I work on"
- "what can I do right now"
- "low energy"
- "I'm tired"
- "brain fog"
- "feeling sharp"
- "what matches my energy"
- "easy wins"
