---
name: take-break
description: Take a proper break with a clean pause point and gentle return. Logs where you left off so you can resume without anxiety. Use when the user needs a break, says "taking a break", "pause", or "stepping away".
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Take Break

Proper pause with clean handoff. Rest without anxiety about losing context.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))
**Linking**: Always use `[[wikilinks]]` when writing content that references tasks, projects, or other notes ([rules](../references/LINKING-RULES.md))

## Mindset

ADHD makes breaks hard:
- Fear of losing focus/momentum
- Anxiety about forgetting where you were
- Guilt about stopping
- Trouble returning after break

This skill:
- Creates a clean pause point
- Logs exactly where you were
- Removes guilt about stopping
- Makes returning easier

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_context_focus` | Current focus project |
| `get_context_day` | Today's activity and logs |
| `log_to_daily_note` | Log break start/return |
| `log_to_note` | Log pause state on project |

## Steps

### 1. Acknowledge the Break

No resistance. Breaks are good:

```
Taking a break. Good call.
Let me capture where you are so you can fully rest.
```

### 2. Capture Current State

**Call:** `get_context_focus()`

**Quick questions (optional, can skip):**
```
Quick checkpoint:
- What were you working on? [auto-fill from focus if set]
- Where did you leave off? (one line)
```

If they skip, that's fine. Use what we know:
```
Got it. You were on [focus project / last activity].
```

### 3. Log the Pause

```
log_to_daily_note("Break started. Was working on: [task/project]. Left off at: [note if provided]")
```

If they provided a note about where they left off:
```
log_to_note(
  note_path: "[focus project path]",
  content: "Paused: [their note]"
)
```

### 4. Set Break Duration (Optional)

```
How long are you stepping away?
- Quick break (5-15 min)
- Longer break (30+ min)
- Done for now (will return later)
- Not sure
```

This is just for context, not enforcement.

### 5. Permission to Rest

Clear, guilt-free closure:

```
Break time. Everything is saved:
- Focus: [project]
- Left off: [note or "captured"]

Your brain can let go now. Rest fully.

[If quick break]: See you in a bit.
[If longer]: Take your time. It'll all be here.
[If done]: Good stopping point. See you next time.
```

### 6. Return Prompt

When the user returns (possibly in a new session), rebuild context from the vault:

**Call:** `get_context_focus()` and `get_context_day(date: "today")`

Check today's daily note logs for the most recent "Break started" entry to find where they left off.

```
Welcome back! You were working on [project from focus context].
Left off at: [note from daily log]

Ready to continue, or need a moment?
```

Don't rely on conversation memory — the vault has the state.

## Quick Mode

For a fast break:

```
User: quick break
Agent: Break logged. You were on [focus].
       Rest up. It's all here when you're back.
```

No questions. Just capture and release.

## What NOT to Do

- Don't guilt about stopping
- Don't list what's still undone
- Don't mention deadlines during break
- Don't make capturing take too long
- Don't require detailed notes
- Don't question their need for a break

## Break Without Focus Set

If no focus was set:

```
Taking a break. No specific focus was set.
Is there something you want to note before stepping away?

(Or just go - it's fine)
```

## Types of Breaks

**Physical break:**
```
Going to move around? Great for ADHD brains.
Context saved. Stretch it out.
```

**Mental reset:**
```
Need to clear your head? Totally valid.
Everything's logged. Give your brain space.
```

**Unexpected interruption:**
```
User: someone at the door / phone call / etc
Agent: Go handle it. Quick save:
       - Working on: [project]
       - At: [last known point]

       It'll be here when you're back.
```

**End of work session:**
```
Done for now? Good session.
Here's where you'll pick up:
- Project: [focus]
- Next: [suggested next task]

Rest well. See you next time.
```

## Returning from Break

When user comes back (possibly a new session):

**First, rebuild context from vault:**
1. `get_context_focus()` — current project
2. `get_context_day(date: "today")` — today's logs
3. Check daily note for "Break started" or "Paused" log entries

```
User: I'm back / back from break
Agent: Welcome back!

You were on: [Project from focus context]
Left off at: [Note from daily/project logs]

[If quick break]: Ready to jump back in?
[If longer break]: Need a moment to reorient, or dive in?
```

Then offer:
```
Options:
- Continue where you left off
- Quick status check first
- Actually, different project now
```

## Guilt Management

If user expresses guilt about breaking:

```
User: I shouldn't be taking a break...
Agent: Yes you should. Breaks help ADHD brains:
       - Prevent burnout
       - Allow background processing
       - Reset attention capacity

       This is productive, not lazy. Go rest.
```

## Logging Format

Daily note entry:
```
- [HH:MM] Break started. Focus: [project]. Note: [where left off]
- [HH:MM] Back from break. Resuming [project].
```

This creates a record of work sessions that can be useful for understanding patterns.
