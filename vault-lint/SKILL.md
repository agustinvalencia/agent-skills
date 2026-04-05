---
name: vault-lint
description: Check vault structural correctness — broken links, schema violations, orphans, and more. Like `cargo clippy` for your vault. Use when the user says "check my vault", "vault health", "lint", "any broken links?", or wants a structural review.
metadata:
  author: mdvault
  version: "1.0"
compatibility: Requires mdvault MCP server with vault configured and mdv CLI with `check` and `validate` commands
---

# Vault Lint

Structural health check for the vault. Goal: surface real problems without overwhelm.

**Principles**: Celebrate first · Cap output · Compassionate framing · One category at a time ([full guide](../references/ADHD-PRINCIPLES.md))
**Linking**: Always use `[[wikilinks]]` when writing content that references tasks, projects, or other notes ([rules](../references/LINKING-RULES.md))

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `vault_lint` | Run structural checks (broken links, orphans, db sync) |
| `validate_note` | Validate frontmatter against Lua type definitions (schema) |
| `read_note` | Read specific notes to help fix issues |
| `update_metadata` | Fix metadata issues on individual notes |

## Steps

### 1. Run Both Checks (Silent)

Run two checks in parallel — do not show raw output:
1. `vault_lint()` — structural health (broken references, orphans, consistency)
2. `validate_note()` — schema health (frontmatter against type definitions)

These are complementary: `vault_lint` checks structure, `validate_note` checks schemas.

### 2. Lead with the Health Score

Start with the positive:

```
Your vault is at [score]% health ([total] notes).
```

If 90%+:
```
Your vault is at 97% health (342 notes) — looking great!
```

If below 70%, keep it encouraging:
```
Your vault is at 64% health (342 notes) — let's tidy a few things up.
```

### 3. Show Clean Categories First

List the categories that passed with no issues:

```
All clear: Broken References, Schema Violations, Index Sync
```

This reduces anxiety and shows most things are fine.

### 4. Show Issues by Category (Capped)

For each category with issues, show a **maximum of 3-5 issues**. Use compassionate framing — describe the state, not a failure.

**Do:**
- "3 notes have missing metadata"
- "5 links point to notes that don't exist"
- "2 task notes are outside the expected directory"

**Don't:**
- "3 notes are broken"
- "You have 5 broken links"
- "2 notes are in the wrong place"

If more issues exist:
```
... and 12 more — want to see them?
```

### 5. Offer to Fix Fixable Issues

If `validate_note` found schema errors (missing required fields, wrong types):

```
3 notes have missing frontmatter fields that can be auto-filled with defaults. Want me to fix them?
```

Wait for confirmation before calling `validate_note(fix=True)`. To fix a specific note: `validate_note(path="Journal/2026/Daily/2026-04-05.md", fix=True)`.

For structural issues found by `vault_lint` that are fixable, offer those separately.

### 6. Help with Non-Fixable Issues

For issues that can't be auto-fixed, offer to help one at a time:

```
Want to tackle one of the broken links? I can read the note and help you fix it.
```

Don't dump the full list. One thing at a time.

### 7. Close with Updated Score

After fixes are applied, run `vault_lint()` again silently and report the new score:

```
Vault health: 64% → 78%! Nice work.
```

If no fixes were applied, skip this step.

## Scope Control

If the vault has many issues across categories, don't show everything. Ask:

```
There are issues in 4 categories. Which would you like to look at first?
- Broken References (5 errors)
- Schema Violations (12 errors)
- Orphaned Notes (8 warnings)
- Structural Consistency (3 warnings)
```

## What NOT to Do

- Don't dump the full list of issues (overwhelm)
- Don't use words like "broken", "wrong", "failed" (shame)
- Don't auto-fix without asking (trust)
- Don't show all categories in detail at once (cognitive load)
- Don't suggest "run mdv check" — you ARE the check
- Don't mix lint checks with staleness/review concerns (different skill territory)

## Edge Cases

### No Issues Found

```
Your vault is at 100% health (342 notes) — everything checks out!
No broken links, no schema issues, no orphans. Clean slate.
```

### Index Not Built

If `vault_lint()` returns an error about missing index:

```
The vault index needs to be built first. Want me to run a reindex?
```

### Single Category Request

If the user asks about a specific concern (e.g. "any broken links?"), run with the category filter:

```python
vault_lint(category="broken_references")
```

Only show that category's results.

### Validate a Specific Note or Type

If the user asks to validate a specific note or note type:

```python
validate_note(path="Journal/2026/Daily/2026-04-05.md")
validate_note(note_type="daily")
validate_note(note_type="task", limit=20)
```

Show per-note errors grouped clearly. Offer `fix=True` if there are fixable issues.
