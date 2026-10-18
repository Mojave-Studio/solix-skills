#!/bin/sh
# Mirror skills/ into claude/skills/ with plugin-namespace-safe names.
# skills/solix-first-mate → claude/skills/first-mate (plugin command /solix:first-mate)
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/skills"
DST="$ROOT/claude/skills"

rm -rf "$DST"
mkdir -p "$DST"

for dir in "$SRC"/*/; do
    base="$(basename "$dir")"
    case "$base" in
        solix-*) dest="${base#solix-}" ;;
        *) dest="$base" ;;
    esac
    mkdir -p "$DST/$dest"
    awk -v new="$dest" '
        BEGIN { done = 0 }
        /^name: / && !done { print "name: " new; done = 1; next }
        { print }
    ' "$dir/SKILL.md" > "$DST/$dest/SKILL.md"
done
