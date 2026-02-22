---
name: create-project
description: Create a new project or area in the vault with standardised structure. Gathers title, kind (project vs area), context (work/personal/family), and expected outcome or health criteria. Low friction with sensible defaults. Use when the user wants to start a new project, create an area, or says "new project".
metadata:
  author: mdvault
  version: "1.1"
compatibility: Requires mdvault MCP server with vault configured
---

# Create Project or Area

Standardized project/area creation. Consistent structure regardless of which agent is used.

**Principles**: One thing at a time · Wins first · No shame · Low friction · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `create_project` | Create project note from template |
| `set_focus` | Optionally focus on new project |
| `log_to_daily_note` | Log project creation |

## Required Information

| Field | Required | Source | Default |
|-------|----------|--------|---------|
| title | Yes | Ask user | - |
| kind | Yes | Ask user | project |
| context | Yes | Ask user | - |
| outcome/health | Recommended | Ask user | (can skip) |

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
- personal
- family
- uni
```

If user gives something else, map it:
- "job", "office", "company" → work
- "home", "me", "self", "side project" → personal
- "wedding", "partner", "kids" → family
- "study", "thesis", "paper", "research", "university" → uni

### 3. Get Kind

Determine if this is a project (finite goal) or an area (ongoing responsibility):

```
Is this a project or an area?
- project — has a clear end goal (e.g., "Kitchen Renovation", "Q1 Report")
- area — ongoing responsibility with no finish line (e.g., "Health", "Finances", "Home Maintenance")
```

If user gives something that clearly maps:
- "ongoing", "recurring", "life area", "responsibility" → area
- "goal", "deliverable", "one-time", "build", "ship" → project

If unsure, default to **project** — it's easy to change later.

### 4. Get Expected Outcome or Health Criteria (Recommended)

**For projects** — clear success criteria:

```
What does "done" look like for this project?
(One sentence describing the end state)

Example: "Kitchen is renovated with new counters and appliances installed"
```

**For areas** — health criteria instead:

```
How do you know this area is going well?
(One sentence describing what "healthy" looks like)

Example: "Exercising 3x/week and sleeping 7+ hours"
```

If user wants to skip:
```
That's fine - you can add it later. Sometimes we figure it out as we go.
```

### 5. Create the Project

Use MCP tool:

```
create_project(
  title: "[title]",
  context: "[context]",
  kind: "[project or area]",
  extra_vars: {
    "outcome": "[expected outcome or health criteria]"
  }
)
```

### 6. Offer to Set Focus

After creation:

```
[Project/Area] created: [Project ID] - [Title]
Path: Projects/[slug]/[slug].md

Want to focus on this now?
```

If yes, use `set_focus` with the project name.

### 7. Log and Confirm

Log to daily note:
```
- Created [project/area]: [ID] - [Title]
```

Final confirmation:

```
Done! [Project ID] - [Title] is ready.

Path: [path]
Kind: [project/area]
Context: [context]
Outcome: [outcome/health criteria or "To be defined"]

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

**Minimal project:**
```
User: new project
Agent: What's it called?
User: Kitchen Renovation
Agent: Is this a project (finite goal) or an area (ongoing)?
User: project
Agent: What area? (work/personal/family/uni)
User: personal
Agent: What does "done" look like?
User: skip
Agent: [creates project]
       Done! KRN - Kitchen Renovation is ready.
```

**Area:**
```
User: create an area for Health
Agent: What area? (work/personal/family/uni)
User: personal
Agent: How do you know this area is going well?
User: Exercising 3x/week and sleeping well
Agent: [creates area]
       Done! HLT - Health is ready.
       Kind: area
       Health criteria: Exercising 3x/week and sleeping well
```

**Complete project:**
```
User: create project "API Migration" for work, done when all endpoints are on v2
Agent: [creates project with outcome]
       Done! APM - API Migration is ready.
       Outcome: All endpoints are on v2
```
