---
name: helm-doc
metadata:
  internal: true
description: Manage the user's Solix Helm Docs register — add notes, links, vaults, or folders; list; show bodies; or remove docs via the solix CLI. Use when the user wants to store, fetch, or delete reference text the crew can pull on demand.
argument-hint: "<verb> [name|id] — add | list | show | rm"
---

# Solix Helm — Docs

Docs are stored reference text — notes, links, whole vaults and folders.
Prompts carry titles; `show` fetches the body on demand. All verbs are
`solix` CLI calls:

```text
new      → solix docs add note|link <title> <text|url>
           (vaults/folders: solix docs add vault|folder <path>)
read     → solix docs list            (titles + previews only)
edit     → solix docs add <kind> <title> …   (upserts by title)
use      → solix docs show <name|id>   (prints the body — the lazy
           read path; prompts carry titles, this fetches on demand)
rename   → not supported — add under the new title, rm the old
delete   → solix docs rm <name|id>
```

## Rules of the register

- Titles are the handle.
- `add` upserts by title, so `edit` is `add` on an existing title.
- A `*` on a doc's kind marks it private — the operator's shelf,
  readable only by their devices and the First Mate's terminal. Worker
  terminals can't list, read, edit, or delete it; never relay its
  contents into a worker's brief.
- To insert docs into this chat, `solix load docs` (skill `solix-load`)
  — titles and summaries; load a name for the full body.
