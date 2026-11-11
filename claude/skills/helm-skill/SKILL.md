---
name: helm-skill
metadata:
  internal: true
description: Manage the user's Solix Helm Skills register — add a local skill directory to the store, list, show, inject one live into a chat, or remove store skills via the solix CLI. Use when adding, inspecting, updating, or deleting agent skills Solix holds.
argument-hint: "<verb> [name|path] — add | list | show | rm"
---

# Solix Helm — Skills

Store skills are agent instruction packs Solix holds; projects get them
in `.claude/skills`, and a running chat can pull one live. All verbs are
`solix` CLI calls:

```text
new      → write a <name>/SKILL.md dir, then `solix skill add <path>`
read     → solix skill list  /  solix skill show <name>
edit     → fetch with `show`, edit, re-add via a local path
use      → skills materialize into a project's agent dirs at creation;
           `solix send <bot> "-<name>"` injects one live
rename   → not supported — add under the new name, rm the old
delete   → solix skill rm <name>
```

## Rules of the register

- Names are the handle — keep them short, lowercase, hyphenated.
- To insert skills into this chat, `solix load skills` (skill
  `solix-load`) — a catalog of names and summaries; load one name for
  the full body.
