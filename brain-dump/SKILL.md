---
name: brain-dump
description: Get everything out of your head into the vault, then help prioritise ONE thing. Clears mental clutter, captures all floating thoughts, and picks a single next action. Use when the user feels overwhelmed, has too much in their head, or says "brain dump" or "clear my head".
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Brain Dump

Empty your head into the vault. Then pick ONE thing.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))

## Mindset

ADHD brains carry too much:
- Unwritten tasks circling
- Ideas that might be lost
- Worries about forgetting
- Mental load that blocks action

This skill:
- Gets everything OUT of your head
- Captures it all (no filtering yet)
- Then helps pick just ONE thing
- Clears the mental load

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `add_to_daily_note` | Capture items to daily note Inbox |
| `log_to_daily_note` | Log brain dump session |

## Steps

### 1. Open the Floodgates

Start with permission to dump everything:

```
Let's clear your head. Tell me everything that's floating around:
- Tasks you're worried about
- Ideas you don't want to lose
- Things you need to remember
- Anything at all

Just stream it out. I'll capture everything.
```

### 2. Capture Everything

As user dumps, capture in real-time or batch at end:

**For each item, call:**
```
add_to_daily_note(
  content: "- [ ] [item]",
  subsection: "Inbox"
)
```

Or batch capture:
```
add_to_daily_note(
  content: "- [ ] Item 1\n- [ ] Item 2\n- [ ] Item 3...",
  subsection: "Inbox"
)
```

**Don't:**
- Categorise yet
- Ask which project
- Judge importance
- Interrupt the flow

### 3. Acknowledge the Dump

When they're done:

```
Got it all. [X] items captured.

They're safe in your daily note. Your brain can let them go now.
```

### 4. Optional: Quick Categorisation

Only if user wants and has energy:

```
Want to quickly sort these? I can help assign to projects.
Or we can leave them in Inbox for later.
```

If yes, go through items quickly:
```
"[Item]" - which project? (or skip)
```

Keep it fast. Skipping is fine.

### 5. Pick ONE Thing

Now the key step - reduce to action:

```
Everything's captured. Now: what's the ONE thing?

Looking at what you dumped, what feels most:
- Urgent (has a deadline)
- Important (high impact)
- Quick (easy win to build momentum)

Pick one. Or I can pick for you.
```

If they can't decide, pick for them (like /unstuck):
```
I'll pick: [Most urgent or time-sensitive item]

Start there. Everything else is captured and waiting.
```

### 6. Set Up for Action

Once ONE thing is picked:

```
Your one thing: [Item]

The smallest first step:
→ [Tiny action to start]

Everything else is in your Inbox. It'll be there when you're ready.
Go.
```

### 7. Log the Dump

```
log_to_daily_note("Brain dump: captured [X] items, focusing on [chosen item]")
```

## What NOT to Do

- Don't interrupt the dump with questions
- Don't judge or prioritise during capture
- Don't say "that's too many" (shame)
- Don't require categorisation (friction)
- Don't present all items as a to-do list (overwhelm)
- Don't skip the "pick ONE" step

## If Nothing Comes Out

Sometimes the prompt doesn't work:

```
User: I don't know, nothing specific
Agent: That's okay. Let me prompt:

- Anything you're worried you'll forget?
- Any deadlines coming up?
- Something you keep meaning to do?
- An idea that's been nagging you?
```

Or try categories:
```
What about:
- Work stuff?
- Home/personal?
- People you need to contact?
- Things you promised someone?
```

## Large Dumps (>15 items)

If it's a big dump:

```
Wow, [X] items. No wonder you felt overwhelmed.
That's a lot to carry around. But now it's out.

We're not going to tackle all of these. Just one.
Which ONE feels most pressing right now?
```

Don't try to process them all. One is enough.

## Recurring Brain Dumps

If user does this often, suggest rhythm:

```
This was helpful, right? Maybe a weekly Inbox review?
Or a daily 2-minute capture habit?

For now, let's focus on your one thing: [Item]
```

## Example Session

```
User: brain dump
Agent: Let's clear your head. Tell me everything...

User: I need to call the dentist, and there's that report due Friday,
      oh and mom's birthday is coming up, need to get a gift,
      also should exercise more, and the car needs an oil change,
      and I had an idea for the API refactor...

Agent: Got it. 7 items captured:
       - Call dentist
       - Report due Friday
       - Mom's birthday coming up
       - Get birthday gift for mom
       - Exercise more
       - Car oil change
       - API refactor idea

       They're all in your Inbox now. Your brain can let go.

       What's the ONE thing? I'd suggest "Report due Friday"
       since it has a deadline.

User: yeah the report

Agent: Your one thing: Report due Friday

       First step:
       → Open the report document

       Everything else is captured. Go.
```
