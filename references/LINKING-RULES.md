# Vault Linking Rules

When writing any content to vault notes (daily notes, weekly notes, project logs, standup blocks, reports), **always use Obsidian wikilinks** for references to other notes.

## When to Link

Link whenever you mention:
- **Task IDs**: `[[PROJ-001-task-slug|PROJ-001]]`
- **Project/area names**: `[[project-slug]]` or `[[project-slug|Display Name]]`
- **Meeting notes**: `[[MTG-2026-03-01-001|Meeting Title]]`
- **Daily/weekly notes**: `[[2026-03-01]]`, `[[2026-W10]]`
- **Zettel notes**: `[[zettel-slug|Zettel Title]]`
- **Any other vault note** referenced by name

## Link Format

Use the **alias form** for readability when the filename is long:

```
[[WMD-014-implement-mlp-to-kan-distillation|WMD-014]]
[[MSM-002-review-second-version-of-mi-proposal|MSM-002]]: Review MI proposal
```

Use the **bare form** when the filename is already readable:

```
[[world-models-distillation]]
[[2026-W10]]
```

## Where This Applies

- `append_to_note` content (standups, closing thoughts, wins, reflections)
- `log_to_daily_note` and `log_to_note` messages
- Any narrative content written to weekly, monthly, or project notes
- Task/project lists written into note sections

## Examples

**Log entry:**
```
Completed [[WMD-014-implement-mlp-to-kan-distillation|WMD-014]]: MLP-to-KAN distillation on Pendulum
```

**Standup block:**
```
- Focus: [[world-models-distillation]]
- In progress: [[WMD-014-implement-mlp-to-kan-distillation|WMD-014]]: MLP-to-KAN distillation
```

**Weekly wins:**
```
- Completed [[WMD-014-implement-mlp-to-kan-distillation|WMD-014]] and [[WMD-015-implement-evaluation-metrics|WMD-015]] — research vertical slices done
```

## How to Get the Correct Filename

Use MCP tools to look up note paths before writing links:
- `list_tasks` returns task paths (extract filename without `.md`)
- `list_projects` returns project names (use as-is for `[[project-name]]`)
- `get_context_focus` returns the focused project path
- `get_task_details` returns the full task path

If you don't have the exact filename, use the task ID as a best-effort link: `[[PROJ-001]]`. Obsidian will show it as unresolved but it's still better than plain text.
