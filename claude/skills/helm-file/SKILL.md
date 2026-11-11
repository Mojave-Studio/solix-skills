---
name: helm-file
metadata:
  internal: true
description: Manage the user's Solix Helm Files register — register a path to local key/cert material, list, show, rename, or delete file pointers via the solix CLI. The register holds the path, never the contents. Use when wiring a local file into Solix setups.
argument-hint: "<verb> [name|path] — set | list | show | rename | rm"
---

# Solix Helm — Files

File entries are pointers to local key/cert material — the register
holds the PATH, never the contents. All verbs are `solix` CLI calls:

```text
new      → solix file set <name> <path>          (path must exist —
           registers a pointer to local key/cert material)
read     → solix file list  /  solix file show <name>
edit     → solix file set <name> <new-path>      (upserts by name)
use      → the register holds the PATH, never the contents —
           `cat "$(solix file show <name>)"` to read or pipe it
rename   → solix file rename <old> <new>          (keeps the id)
delete   → solix file rm <name>
```

## Rules of the register

- Names are the handle — keep them short, lowercase, hyphenated.
- `set` upserts by name, so `edit` is `set` on an existing name.
- `rename` preserves the object's id — setups referencing it keep working.
- Key/cert files are pinned: `set` hard-links cert-like extensions into
  `<state-dir>/pinned/` and stores that path, so the entry still resolves
  after the user moves the original (same volume). A `pinned/` path in
  `show`/`list` output is expected. Moves to another volume, or delete +
  re-download, still break the pin.
- To insert file entries into this chat, `solix load files` (skill
  `solix-load`).
