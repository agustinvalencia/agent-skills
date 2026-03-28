#!/usr/bin/env bash
# uninstall.sh — Remove agent-skills symlinks.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"

echo "Removing agent-skills symlinks..."
echo ""

count=0
for skill_dir in "$REPO_DIR"/*/; do
    skill_name="$(basename "$skill_dir")"

    # Skip non-skill directories.
    [ -f "$skill_dir/SKILL.md" ] || continue

    link="$SKILLS_DIR/$skill_name"
    if [ -L "$link" ]; then
        rm "$link"
        echo "  [ok]   removed $link"
        count=$((count + 1))
    elif [ -e "$link" ]; then
        echo "  [skip] $link exists but is not a symlink — not removing"
    else
        echo "  [skip] $link does not exist"
    fi
done

echo ""
echo "Done. Removed $count skills."
