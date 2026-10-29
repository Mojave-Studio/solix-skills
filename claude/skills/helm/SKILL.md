---
name: helm
metadata:
  internal: true
description: Manage the user's Helm registers — commands, skills, secrets, values, docs, and files — through one verb-object grammar. Create, read, edit, use, rename, or delete any register entry from the solix CLI.
argument-hint: "[verb-object + args — e.g. read-command, new-command deploy, use-command deploy]"
---

# Solix Helm

The Helm is the user's persistent rig: named registers of objects stored
on the host. Everything below is a `solix` CLI call — one grammar, not a
skill per action.

## The grammar

`<verb>-<object>` where verb is `new`, `read`, `edit`, `use`, `rename`,
`delete` and object is `command`, `skill`, `secret`, `value`, `setting`,
`doc`, `vault`, `file`. The CLI spells it `<object> <action>`:

```text
new-command      → solix command new <name> --cmd "<shell>" [--dir <path>]
read-command     → solix command list  /  solix command show <name>
edit-command     → solix command new <name> --cmd "…"   (upserts by name)
use-command      → solix command run <name> [--var k=v]…   (opens a shell)
rename-command   → solix command rename <old> <new>
delete-command   → solix command rm <name>

new-skill        → write a <name>/SKILL.md dir, then `solix skill add <path>`
read-skill       → solix skill list / show <name>
edit-skill       → fetch with `show`, edit, re-add via a local path
use-skill        → skills materialize into a project's agent dirs at
                   creation; `solix send <bot> "-<name>"` injects one live
rename-skill     → not supported — add under the new name, rm the old
delete-skill     → solix skill rm <name>

new-secret       → solix secret set <name>            (value on stdin — never argv)
read-secret      → solix secret list                  (names + kinds only,
                   values are unreadable by design — that includes you)
edit-secret      → solix secret set <name>            (overwrite)
use-secret       → in terminal input, type the marker `solix:pass:<name>` —
                   the host injects the value at a concealed prompt; you
                   never see it. Needs a permit: `solix secret grant`.
rename-secret    → solix secret set <new> then `solix secret rm <old>`
delete-secret    → solix secret rm <name>

new-value        → solix value set <name> <value>
read-value       → solix value list
edit-value       → solix value set <name> <new-value>
use-value        → values are the {{var}} table — see Variables below
rename-value     → solix value rename <old> <new>
delete-value     → solix value rm <name>

new-file         → solix file set <name> <path>          (path must exist —
                   registers a pointer to local key/cert material)
read-file        → solix file list  /  solix file show <name>
edit-file        → solix file set <name> <new-path>      (upserts by name)
use-file         → the register holds the PATH, never the contents —
                   `cat "$(solix file show <name>)"` to read or pipe it
rename-file      → solix file rename <old> <new>
delete-file      → solix file rm <name>

new-doc          → solix docs add note|link <title> <text|url>
                   (vaults/folders: solix docs add vault|folder <path>)
read-doc         → solix docs list            (titles + previews only)
edit-doc         → solix docs add <kind> <title> …   (upserts by title)
use-doc          → solix docs show <name|id>   (prints the body — the lazy
                   read path; prompts carry titles, this fetches on demand)
rename-doc       → not supported — add under the new title, rm the old
delete-doc       → solix docs rm <name|id>

new-vault        → solix vault import <path> [--project <p>]
read-vault       → solix vault list  /  solix vault notes|read <name>
edit-vault       → vaults read live from disk — nothing to edit here
use-vault        → imported Obsidian vaults stay current; notes route to
                   the project that owns the vault
rename-vault     → not supported — rm and re-import
delete-vault     → solix vault rm <name>

new-setting      → solix settings set <name> <value>
read-setting     → solix settings list
edit-setting     → solix settings set <name> <new-value>
use-setting      → the host reads it — autonomy level, mate bindings,
                   alert routes, issue triggers; `solix value set` on a
                   known config name lands here too
rename-setting   → solix settings rename <old> <new>
delete-setting   → solix settings rm <name>
```

## Variables

Command bodies may carry `{{name}}` placeholders. At `run`
time the host substitutes them from the Values register; `--var k=v` on
`solix command run` overrides for that one run. Unknown `{{name}}`s stay
literal — check `solix command show <name>` (its `vars` line) against
`solix value list` before running. Secrets are NOT variables — they only
enter through `solix:pass:` markers at a concealed prompt.

## Rules of the register

- Names are the handle — keep them short, lowercase, hyphenated.
- `new` upserts by name, so `edit` is `new` on an existing name.
- `rename` preserves the object's id — setups referencing it keep working.
- Deleting a command or value a setup references leaves the reference
  dangling; warn the user if `solix command list` shows a `{{var}}` that no
  value defines.
- A `*` on a doc's kind marks it private — the operator's shelf, readable
  only by their devices and the First Mate's terminal. Worker terminals
  can't list, read, edit, or delete it; never relay its contents into a
  worker's brief.
- To insert register items into this chat, `solix load <register>` (skill
  `solix-load`). The operator picks all-vs-one in a Mac popup you never see.
