#!/bin/sh
# Link the solix skills into every agent skills directory on this machine.
# Safe to re-run — existing entries are left alone.
set -eu

SRC="$(cd "$(dirname "$0")" && pwd)"
# Derive the skill set from the repo — every skills/ subdirectory.
SKILLS=$(ls -d "$SRC"/skills/*/ | xargs -n1 basename)

DIRS="$HOME/.agents/skills
$HOME/.claude/skills
$HOME/.copilot/skills
$HOME/.codex/skills
$HOME/.config/devin/skills
$HOME/.config/kimchi/harness/skills
$HOME/.codeium/windsurf/skills
$HOME/.grok/skills
$HOME/.config/goose/skills
$HOME/.config/crush/skills
$HOME/.antigravity/skills
$HOME/.cursor/skills"

found=0
for dir in $DIRS; do
    if [ -d "$dir" ]; then
        found=1
        for skill in $SKILLS; do
            target="$dir/$skill"
            if [ -e "$target" ]; then
                echo "skip  $target (exists)"
            else
                ln -s "$SRC/skills/$skill" "$target"
                echo "link  $target"
            fi
        done
    fi
done

if [ "$found" -eq 0 ]; then
    echo "no agent skills directories found — create one and re-run,"
    echo "or copy the skill folders manually into your provider's skills dir."
fi
