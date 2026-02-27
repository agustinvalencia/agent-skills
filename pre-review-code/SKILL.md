---
name: pre-review-code
description: Pre-review a merge request or pull request using the local git clone. Produces a plain-English summary of what actually changed, flags anything worth the reviewer's attention, and saves a dated note to the vault. Use when the user says "review MR", "review PR", "pre-review", "check this branch", or shares a head SHA and target branch.
metadata:
  author: mdvault
  version: "1.1"
compatibility: Requires bash tool and mdvault MCP server with vault configured
---

# Pre-Review Code

Pre-review a merge request (MR) or pull request (PR) from the local git clone. No API, no token — just git.

**Principles**: Scope before depth · Flag, don't fix · Only what's in the diff · The vault remembers ([full guide](../references/ADHD-PRINCIPLES.md))

**For ML repositories, also read**: [ML Review Patterns](references/ML-REVIEW-PATTERNS.md)

## Mindset

Code review can trigger ADHD side-quests — you start checking a library used in the diff, end up reading unrelated documentation, and never finish the review. This skill:
- Uses `--stat` to scope before diving in (prevents hyperfocus on the first file)
- Limits review to what's in the diff (no rewriting, no tangents)
- Produces a concrete output (vault note) so there's a finish line
- Flags items for the reviewer, doesn't try to fix them

Stay in the diff. If something outside the diff looks suspicious, note it as a flag and move on — don't investigate.

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `search_notes` | Check if a review note already exists |
| `append_to_note` | Add a new review section to an existing note |
| `log_to_daily_note` | Log review completion |

Note creation uses the `Write` tool (standard Claude Code tool) since there is no `create_note` MCP tool.

## What You Need from the User

Minimum required:
- `repo_path` — absolute path to the local clone
- `head_sha` — tip commit of the MR/PR branch (copy from the GitLab/GitHub page)
- `target_branch` — branch being merged into (e.g. `main`, `develop`)

Optional but useful:
- `label` — MR/PR identifier (`!47`, `#123`) or branch name, used to name the vault note
- `mr_url` — link back to the MR/PR page

If any required field is missing, ask for it before starting. Don't proceed with incomplete information.

---

## Steps

### 1. Gather Inputs

If the user hasn't provided all required fields:

```
I need a few things to review this:

- Repo path (absolute, e.g. /home/agustin/code/myrepo)
- Head SHA (tip commit — find it on the MR/PR page)
- Target branch (e.g. main)

Optional: MR/PR number/label and the URL.
```

Once you have them, confirm before proceeding:

```
Reviewing:
  Repo:   [repo_path]
  Head:   [head_sha]
  Target: [target_branch]

Fetching and computing diff base...
```

### 2. Fetch and Resolve Base

Always fetch first — the SHA might not be in the local clone yet.

```bash
git -C [repo_path] fetch origin
```

Compute the merge base (the true diff base, not just the branch tip):

```bash
git -C [repo_path] merge-base [head_sha] [target_branch]
```

Store the output as `base_sha`. Use this — not `target_branch` itself — as the base for all diffs and logs.

### 3. Read the Commits

```bash
git -C [repo_path] log --format="%h %s%n%b" [base_sha]..[head_sha]
```

Read the commit messages. Note:
- Are the subjects clear and specific, or vague ("fix stuff", "WIP", "changes")?
- Does the sequence tell a coherent story, or is it scattered?
- Are there any "oops" commits that patch earlier ones in the same MR?

### 4. Get the Overview

```bash
git -C [repo_path] diff --stat [base_sha]..[head_sha]
```

This shows scope immediately — how many files, which areas of the codebase, rough line counts. Use it to calibrate how deep to go per file.

Also get the file list for reference:

```bash
git -C [repo_path] diff --name-only [base_sha]..[head_sha]
```

### 5. Read the Diffs

For each file that looks interesting (changed logic, not just formatting or generated files):

```bash
git -C [repo_path] diff -U5 [base_sha]..[head_sha] -- [file_path]
```

Adjust `-U5` to `-U10` or `-U20` if you need more context around a hunk to understand it.

For very large files where the diff alone is not enough, check out a worktree to read the full file:

```bash
git -C [repo_path] worktree add --detach /tmp/mr-review-[short_sha] [head_sha]
# read files from /tmp/mr-review-[short_sha]/[file_path]
git -C [repo_path] worktree remove --force /tmp/mr-review-[short_sha]
```

Always remove the worktree when done.

### 6. Apply ML-Specific Checks (if applicable)

If the changed files include any of the following, load the ML patterns reference and apply the relevant sections:

- Model definitions, training loops, or loss functions → **PyTorch**, **General ML**
- `LightningModule`, `LightningDataModule`, `Trainer` → **PyTorch Lightning**
- `ray.remote`, `ray.tune`, `ray.init`, Actor classes → **Ray**
- `mlflow.*` calls, experiment tracking, run logging → **MLflow**
- KAN, spline, grid, `kan.KAN` → **KAN**
- `logger.` calls, `loguru` imports → **loguru**
- `yaml.load`, `yaml.safe_load`, config file loading → **PyYAML**
- `typer.Typer`, `app.command`, CLI entry points → **Typer**
- Config + training pipeline wired together → **Cross-Cutting**

Only load the sections that are actually touched by the diff — don't apply PyTorch checks to a YAML-only change.

Flag any matches found. Mark severity clearly: [critical], [warn], or [style].

### 7. Form the Review

Produce two things:

**Summary** — plain English, 3–6 sentences. What does this MR/PR actually do, beyond what the commit messages say? What is the blast radius if something goes wrong?

**Flags** — a bulleted list of items deserving the reviewer's attention. Each flag is one clear sentence. Include severity markers ([critical] / [warn] / [style]) for ML-specific flags. See the heuristics section below.

If there are no flags, say so explicitly — a clean MR is worth noting.

### 8. Write the Vault Note

Check whether a note already exists:

```
search_notes(query: "[label] [repo_name]", folder: "reviews")
```

**If no existing note**, create one using the `Write` tool:

Path: `[vault_root]/reviews/MR_[repo_name]_[label].md`

```markdown
---
repo: [repo_name]
label: [label]
target_branch: [target_branch]
head_sha: [head_sha_short]
mr_url: [mr_url or omit]
tags:
  - review
  - git
---

# [title — infer from commits if not given]

- **Repo:** `[repo_name]`
- **Target:** `[target_branch]`
- **Head SHA:** `[head_sha_short]`
[- **MR/PR:** [mr_url]]

## Review — [date UTC]

### Summary

[summary]

### Flags

[- flag 1]
[- flag 2]

---
```

**If a note already exists**, append a new dated section:

```
append_to_note(
  note_path: "reviews/MR_[repo_name]_[label].md",
  content: "## Review — [date UTC]\n\n### Summary\n\n[summary]\n\n### Flags\n\n[- flag 1]\n\n---"
)
```

Then log to the daily note:

```
log_to_daily_note("Pre-reviewed [label] in [repo_name]: [one-line summary of what it does]")
```

### 9. Present to the User

```
[label] — [title]

[summary]

Flags ([N]):
- [flag 1]
- [flag 2]

Note saved: reviews/MR_[repo_name]_[label].md
```

If there are no flags:
```
No flags — this looks clean. Worth a quick read but nothing jumps out.
```

---

## Review Heuristics

Things to look for and flag:

**Logic and correctness**
- Off-by-one errors, wrong comparison operators, inverted conditions
- Unhandled edge cases (empty input, null, zero, very large values)
- Error handling that silently swallows exceptions
- Race conditions or missing locks in concurrent code
- Incorrect assumption about ordering or state

**Code quality**
- Magic numbers or strings with no constant or comment explaining them
- Functions doing more than one thing (hard to name, hard to test)
- Long functions with no inline explanation of non-obvious sections
- Copy-pasted code that should be a shared function
- Commits within the MR that patch or undo each other (messy history)

**Tests**
- New logic with no tests at all
- Tests that only test the happy path
- Tests that test implementation rather than behaviour (brittle)
- Deleted tests with no explanation

**Security-sensitive changes**
- Auth or permissions logic touched — worth a careful read even if it looks fine
- Input going into shell commands, SQL, or file paths without sanitisation
- Credentials, tokens, or keys anywhere in the diff (even in comments)
- Changes to logging that might start recording sensitive data

**Operational concerns**
- Schema migrations with no rollback plan
- New external calls with no timeout or retry limit
- Configuration changes with no documentation update
- Breaking API changes with no version bump or deprecation notice

**Common patterns in less experienced code**
- Overly complex solution to a simple problem
- Framework or library used in an unidiomatic way
- Inconsistent style with the rest of the codebase
- Vague or missing commit messages

---

## What NOT to Do

- Don't skip `git fetch` — the SHA might not exist locally yet
- Don't use `target_branch` directly as the diff base — always compute `merge-base` first, otherwise you include unrelated commits already on the target branch
- Don't try to read every file in a large MR — use `--stat` to prioritise
- Don't leave worktrees behind — always remove them
- Don't soften flags to the point of uselessness — a flag should be actionable
- Don't invent issues that aren't in the diff — only flag what you can see
- Don't append to the vault note before checking whether it already exists
- Don't rabbit-hole into code outside the diff — note the concern and move on
- Don't try to fix the code or suggest rewrites — flag and let the reviewer decide

---

## Edge Cases

### Very Large MRs (100+ files)

Don't attempt to read every diff. Triage:
1. Use `--stat` to identify the high-change files
2. Skip generated files (lock files, migrations, compiled assets)
3. Focus on files with logic changes (not just renames or formatting)
4. Mention the scope in the summary: "This MR touches 147 files — I focused on the 12 with substantive logic changes."

### Binary or Generated Files

Skip binary files entirely. For generated files (e.g. protobuf output, compiled CSS), only flag if the generator config changed but the output wasn't regenerated, or vice versa.

### Merge Commits in the History

If the log contains merge commits from the target branch, the branch history is noisy. Note this in the summary — it makes the commit story harder to follow but doesn't affect the diff (since we use `merge-base`).

### Empty Diff

If `merge-base` equals `head_sha`, there's nothing to review:
```
No changes between [head_sha] and [target_branch]. The branch may already be merged or may be identical to the target.
```

### No Label Provided

Default `label` to the short SHA (`head_sha[:8]`). The vault note path becomes `reviews/MR_[repo_name]_[short_sha].md`.

---

## Quick Mode

If the user just wants a fast pass with no vault note:

```
User: quick look at this MR, head abc1234 targeting main, repo ~/code/myrepo
```

Run steps 2–7 only. Present the summary and flags inline. Skip the vault write unless the user asks for it.
