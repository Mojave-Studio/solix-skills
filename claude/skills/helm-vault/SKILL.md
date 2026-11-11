---
name: helm-vault
metadata:
  internal: true
description: Manage the user's Solix Helm Vaults register — import an Obsidian vault, list vaults, read their notes, or remove imports via the solix CLI. Vaults read live from disk and route notes to their owning project. Use when the user wants to wire a notes vault into Solix.
argument-hint: "<verb> [name|path] — import | list | notes | read | rm"
---

# Solix Helm — Vaults

Vaults are imported Obsidian vaults — the host reads them live from
disk, so nothing goes stale, and notes route to the project that owns
the vault. All verbs are `solix` CLI calls:

```text
new      → solix vault import <path> [--project <p>]
read     → solix vault list  /  solix vault notes|read <name>
edit     → vaults read live from disk — nothing to edit here
use      → imported vaults stay current; notes route to the project
           that owns the vault
rename   → not supported — rm and re-import
delete   → solix vault rm <name>
```

## Rules of the register

- Names are the handle — keep them short, lowercase, hyphenated.
