---
name: solix:skills
description: "Tidy agent skills across every skills directory on this machine — find duplicates, broken links, shadowed copies, and stale versions, and remove or relink them. Use when asked to clean up, dedupe, audit, or fix installed skills, or when a skill loads the wrong version."
argument-hint: "[check | clean]"
---

# Solix Skills — dedupe and repair

Skills live in several places at once:

```text
~/.agents/skills   ~/.claude/skills   ~/.codex/skills   ~/.config/devin/skills
~/.copilot/skills  ~/.codeium/windsurf/skills   ~/.grok/skills   ~/.cursor/skills
<project>/.claude/skills        plugin caches (~/.claude/plugins/cache/…)
solix skill list                the Solix store — projects get them in .claude/skills
```

Plugin caches are owned by their plugin manager — report duplicates there,
never edit them.

## Checks

Run from a shell; `<dirs>` = the directories above that exist.

```sh
# broken symlinks
find <dirs> -maxdepth 1 -type l ! -exec test -e {} \; -print
# same skill name in several dirs, and whether the copies differ
for d in <dirs>; do for s in "$d"/*/SKILL.md; do
  printf '%s\t%s\t%s\n' "$(basename "$(dirname "$s")")" "$(shasum < "$s" | cut -c1-8)" "$s"
done; done | sort
```

Classify each finding:

- **Broken link** — target gone. Remove the link, or relink if the source
  moved (search for its `SKILL.md`).
- **Same name, same hash, real copies** — redundant. Keep one real copy
  (prefer the source repo or `~/.agents/skills`) and symlink the rest to it.
- **Same name, different hash** — drifted. Diff them; the newer or the one
  from the source repo wins. Ask when it's unclear.
- **Same frontmatter `name:` under different directory names** — the agent
  sees one and the other is dead. Remove the loser.
- **Superseded** — a `-v1`/`-old` twin of a skill the user runs, or a
  standalone copy of a skill a plugin now ships. Ask before removing.

## Flow

1. Run the checks; build one table: skill, locations, verdict (keep /
   relink / remove / ask), one-line reason.
2. Show it and ask. Nothing is deleted without a yes.
3. Apply: `rm` for links, relink with `ln -sfn`, move removed real copies
   to `~/.Trash` instead of `rm -rf`. Store skills go through
   `solix skill rm <name>`.
4. Re-run the checks and report the delta. Agents load skills at startup —
   running sessions need a restart to see changes.
