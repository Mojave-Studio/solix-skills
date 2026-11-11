---
name: helm-setting
metadata:
  internal: true
description: Manage the user's Solix Helm Settings register — set, list, rename, or delete host-read config (autonomy level, mate bindings, alert routes, issue triggers) via the solix CLI. Use when changing how the Solix host itself behaves.
argument-hint: "<verb> [name] [value] — set | list | rename | rm"
---

# Solix Helm — Settings

Settings are config the host itself reads — autonomy level, mate
bindings, alert routes, issue triggers. `solix value set` on a known
config name lands here too. All verbs are `solix` CLI calls:

```text
new      → solix settings set <name> <value>
read     → solix settings list
edit     → solix settings set <name> <new-value>   (upserts by name)
use      → the host reads it — nothing to invoke
rename   → solix settings rename <old> <new>        (keeps the id)
delete   → solix settings rm <name>
```

## Rules of the register

- Names are the handle — keep them short, lowercase, hyphenated.
- `set` upserts by name, so `edit` is `set` on an existing name.
- `rename` preserves the object's id — setups referencing it keep working.
