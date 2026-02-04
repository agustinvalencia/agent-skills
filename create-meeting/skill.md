---
name: create-meeting
description: Create a new meeting note with auto-generated ID. Minimal friction - just needs a title. Attendees and date are optional. Use when the user mentions a meeting, says "meeting with", "schedule meeting", or "create meeting".
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server (v0.3.0+) with vault configured
---

# Create Meeting

Standardized meeting note creation. Minimal friction, auto-generated IDs.

**Read first**: [ADHD Principles](../references/ADHD-PRINCIPLES.md)

## Required Information

| Field | Required | Source | Default |
|-------|----------|--------|---------|
| title | Yes | Ask user or extract from request | - |
| attendees | No | Extract from context or ask | (empty) |
| date | No | Extract or infer | Today |

## Procedure

### 1. Extract Meeting Details

**From user input, extract:**
- Title (required)
- Attendees (if mentioned)
- Date (if mentioned)

**Examples:**
```
User: meeting with Alice about the API design
→ title: "API Design", attendees: "Alice"

User: team sync tomorrow
→ title: "Team Sync", date: tomorrow

User: create a meeting note for the design review
→ title: "Design Review"
```

### 2. Ask Only What's Missing

**If title is clear:** Proceed without asking.

**If title is unclear:**
```
What's this meeting about?
(e.g., "Team Sync", "Design Review", "1:1 with Alice")
```

**Never ask for:**
- Date (defaults to today, user can specify)
- Meeting ID (auto-generated)
- Location (not tracked)

### 3. Create the Meeting

**Call:**
```
create_meeting(
  title: "[title]",
  attendees: "[names or omit]",
  date: "[YYYY-MM-DD or omit for today]"
)
```

### 4. Confirm Simply

```
Created: MTG-2026-02-03-001 - [Title]
[Attendees: names - only if set]
[Date: date - only if not today]

→ Meetings/MTG-2026-02-03-001.md
```

No follow-up questions. Meeting note is created, done.

## Quick Mode (Default)

Most meeting creation should be instant:

```
User: meeting with bob
Agent: Created: MTG-2026-02-03-001 - Meeting with Bob
       Attendees: Bob
       → Meetings/MTG-2026-02-03-001.md
```

One line in, three lines out.

## Date Handling

| User says | Interpret as |
|-----------|--------------|
| (nothing) | Today |
| "tomorrow" | Tomorrow's date |
| "friday" | Next Friday |
| "next week" | Next Monday |
| "jan 15" | 2026-01-15 |

## Attendee Extraction

Extract names naturally:
- "meeting with Alice and Bob" → "Alice, Bob"
- "1:1 with Sarah" → "Sarah"
- "team sync" → (no attendees, it's a group)
- "design review with the frontend team" → "Frontend team"

Don't force structure. Natural names are fine.

## What NOT to Do

- Don't ask for meeting ID (auto-generated)
- Don't ask for date if not mentioned (defaults to today)
- Don't ask for attendees if not mentioned
- Don't ask for agenda (they'll add it to the note)
- Don't create calendar events (out of scope)
- Don't suggest meeting templates

## Edge Cases

**Recurring meeting mentioned:**
```
User: weekly team sync
Agent: Created: MTG-2026-02-03-001 - Weekly Team Sync
       (For recurring meetings, create a new note each time)
```

**Past meeting:**
```
User: create meeting note for yesterday's standup
Agent: Created: MTG-2026-02-02-001 - Standup
       Date: 2026-02-02
```

**Multiple meetings:**
```
User: I have meetings with Alice, Bob, and the design team today
Agent: Creating 3 meeting notes...

Created:
- MTG-2026-02-03-001 - Meeting with Alice
- MTG-2026-02-03-002 - Meeting with Bob
- MTG-2026-02-03-003 - Design Team Meeting
```

## Examples

**Instant:**
```
User: meeting with alice
Agent: Created: MTG-2026-02-03-001 - Meeting with Alice
       Attendees: Alice
```

**With details:**
```
User: design review tomorrow with the backend team
Agent: Created: MTG-2026-02-04-001 - Design Review
       Attendees: Backend team
       Date: 2026-02-04
```

**From conversation:**
```
User: I just had a great call with the investor
Agent: Want me to create a meeting note for that?
User: yes
Agent: Created: MTG-2026-02-03-001 - Investor Call
```

**Title only:**
```
User: /create-meeting Sprint Planning
Agent: Created: MTG-2026-02-03-001 - Sprint Planning
```
