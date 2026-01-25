---
name: create-project
description: Create a new project in the vault with standardised structure. Gathers title, context (work/personal/family), and expected outcome. Low friction with sensible defaults. Use when the user wants to start a new project or says "new project".
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured
---

# Create Project

Standardized project creation. Consistent structure regardless of which agent is used.

**Read first**: [ADHD Principles](../references/ADHD-PRINCIPLES.md)

## Required Information

| Field | Required | Source | Default |
|-------|----------|--------|---------|
| title | Yes | Ask user | - |
| context | Yes | Ask user | - |
| outcome | Recommended | Ask user | (can skip) |

## Procedure

### 1. Get Project Title

If not provided in the initial request:

```
What's the project called?
(A short, clear name - e.g., "Kitchen Renovation", "Q1 Report")
```

**Validation:**
- Should be concise (2-5 words ideal)
- No special characters except spaces and hyphens
- If too long, suggest shortening

### 2. Get Context

Context determines where in life this project lives:

```
What area is this for?
- work
- side-project
- family
- university
```

If user gives something else, map it:
- "job", "office", "company" → work
- "home", "me", "self" → personal
- "wedding", "partner", "kids" → family
- "study", "thesis", "paper" → research

### 3. Get Expected Outcome (Recommended)

This is the most important part for ADHD brains - clear success criteria:

```
What does "done" look like for this project?
(One sentence describing the end state)

Example: "Kitchen is renovated with new counters and appliances installed"
```

If user wants to skip:
```
That's fine - you can add it later. Sometimes we figure it out as we go.
```

### 4. Create the Project

Use MCP tool:

```
create_project(
  title: "[title]",
  context: "[context]",
  extra_vars: {
    "outcome": "[expected outcome]"
  }
)
```

### 5. Offer to Set Focus

After creation:

```
Project created: [Project ID] - [Title]
Path: Projects/[slug]/[slug].md

Want to focus on this project now?
```

If yes, use `set_focus` with the project name.

### 6. Log and Confirm

Log to daily note:
```
- Created project: [ID] - [Title]
```

Final confirmation:

```
Done! [Project ID] - [Title] is ready.

Path: [path]
Context: [context]
Outcome: [outcome or "To be defined"]

You can start adding tasks with /create-task
```

## Quick Mode

If user provides everything upfront:
```
"Create a project called Kitchen Reno, it's personal, done when kitchen is finished"
```

Skip all questions, create directly, confirm.

## What NOT to Do

- Don't ask for priority, status, or other optional fields (friction)
- Don't require outcome if user doesn't have one yet
- Don't create tasks automatically (separate concern)
- Don't overwhelm with options
- Don't set focus without asking

## Examples

**Minimal:**
```
User: new project
Agent: What's the project called?
User: Wedding Planning
Agent: What area? (work/personal/family/research)
User: family
Agent: What does "done" look like?
User: skip
Agent: [creates project]
       Done! HPO - Wedding Planning is ready.
```

**Complete:**
```
User: create project "API Migration" for work, done when all endpoints are on v2
Agent: [creates project with outcome]
       Done! APM - API Migration is ready.
       Outcome: All endpoints are on v2
```
