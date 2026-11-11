---
name: solix-helm-value
description: Manage the user's Solix Helm Values register — set, list, rename, or delete named variables that fill {{var}} placeholders in saved commands and host config, via the solix CLI. Use when the user wants to store, inspect, change, or remove a named value on the host.
argument-hint: "<verb> [name] [value] — set | list | rename | rm"
---

# Solix Helm — Values

Values are the `{{var}}` table: named strings the host substitutes into
command bodies at run time. All verbs are `solix` CLI calls:

```text
new      → solix value set <name> <value>
read     → solix value list
edit     → solix value set <name> <new-value>     (upserts by name)
use      → values are the {{var}} table — reference `{{name}}` in a
           command body (skill `solix-helm-command`); `--var k=v` on
           `solix command run` overrides for that one run
rename   → solix value rename <old> <new>          (keeps the id)
delete   → solix value rm <name>
```

## Rules of the register

- Names are the handle — keep them short, lowercase, hyphenated.
- `set` upserts by name, so `edit` is `set` on an existing name.
- `rename` preserves the object's id — setups referencing it keep working.
- Deleting a value a command's `{{var}}` references leaves it literal —
  check `solix command show <name>` (its `vars` line) against
  `solix value list` and warn the user.
- `solix value set` on a known host-config name lands in the Settings
  register instead — see skill `solix-helm-setting`.
- To insert values into this chat, `solix load values` (skill
  `solix-load`).
