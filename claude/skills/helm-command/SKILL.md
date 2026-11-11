---
name: helm-command
metadata:
  internal: true
description: Manage the user's Solix Helm Commands register — create, list, show, edit, run, rename, or delete named shell commands via the solix CLI. Use when the user wants to save, inspect, change, run, or remove a reusable shell command on the host.
argument-hint: "<verb> [name] — new | list | show | run | rename | rm"
---

# Solix Helm — Commands

A saved command is a named shell line the host can open in a terminal on
demand — it runs like any terminal, nothing reads or reasons about the
output. All verbs are `solix` CLI calls:

```text
new      → solix command new <name> --cmd "<shell>" [--dir <path>]
read     → solix command list  /  solix command show <name>
edit     → solix command new <name> --cmd "…"      (upserts by name)
use      → solix command run <name> [--var k=v]…   (opens a shell)
rename   → solix command rename <old> <new>        (keeps the id)
delete   → solix command rm <name>
```

## Variables

Command bodies may carry `{{name}}` placeholders. At `run` time the host
substitutes them from the Values register (skill `solix-helm-value`);
`--var k=v` on `solix command run` overrides for that one run. Unknown
`{{name}}`s stay literal — check `solix command show <name>` (its `vars`
line) against `solix value list` before running. Secrets are NOT
variables — they only enter through `solix:pass:` markers (skill
`solix-helm-secret`).

## Rules of the register

- Names are the handle — keep them short, lowercase, hyphenated.
- `new` upserts by name, so `edit` is `new` on an existing name.
- `rename` preserves the object's id — setups referencing it keep working.
- Deleting a command a setup references leaves the reference dangling —
  warn the user if `solix command list` shows a `{{var}}` that no value
  defines.
- To insert commands into this chat, `solix load commands` (skill
  `solix-load`). Building a new one end-to-end: skill
  `solix-command-build` walks it.
