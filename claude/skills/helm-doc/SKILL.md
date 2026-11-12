---
name: helm-doc
metadata:
  internal: true
description: Manage the user's Solix Helm Docs register — add notes or links, adopt a project's AGENTS.md/CLAUDE.md, list, show bodies, or remove docs via the solix CLI. Use when the user wants to store, fetch, or delete reference text the crew can pull on demand.
argument-hint: "<verb> [name|id] — add | adopt | list | show | rm"
---

# Solix Helm — Docs

Docs are stored reference text — notes and links. Prompts carry titles;
`show` fetches the body on demand. All verbs are `solix` CLI calls:

```text
new      → solix docs add note|link <title> <text|url>
adopt    → solix docs adopt <project-path> [title]   (reads that
           project's canonical AGENTS.md, falling back to CLAUDE.md,
           and upserts it as a note — the project directory name is
           the default title)
refresh  → solix docs adopt-all   (re-adopts every `solix project`-
           registered project whose path exists on this machine;
           reports what it skipped and why — no local path, or no
           instructions file)
read     → solix docs list            (titles + previews only)
edit     → solix docs add <kind> <title> …   (upserts by title)
use      → solix docs show <name|id>   (prints the body — the lazy
           read path; prompts carry titles, this fetches on demand)
rename   → not supported — add under the new title, rm the old
delete   → solix docs rm <name|id>
```

There is no `vault`/`folder` doc kind — `DocKind` only models `note`/`link`
(`solix docs add vault|folder` errors on purpose). A whole folder of
reference material is either `adopt`ed project instructions, or added as
a `note` with the path in the body.

## Rules of the register

- Titles are the handle.
- `add` upserts by title, so `edit` is `add` on an existing title;
  `adopt`/`adopt-all` re-running re-reads the file and upserts the same
  way — it is a one-shot pull, not a live sync, so re-run `adopt-all`
  after project instructions change (there is no watcher or scheduled
  refresh).
- A `*` on a doc's kind marks it private — the operator's shelf,
  readable only by their devices and the First Mate's terminal. Worker
  terminals can't list, read, edit, or delete it; never relay its
  contents into a worker's brief.
- To insert docs into this chat, `solix load docs` (skill `solix-load`)
  — titles and summaries; load a name for the full body.
