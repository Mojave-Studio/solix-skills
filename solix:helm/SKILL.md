---
name: solix:helm
description: Manage the user's Helm registers — commands, documents, skills, secrets, values, and rules — through one verb-object grammar. Create, read, edit, use, rename, or delete any register entry from the solix CLI.
argument-hint: "[verb-object + args — e.g. read-command, new-command deploy, use-command deploy]"
---

# Solix Helm

The Helm is the user's persistent rig: six registers of named objects stored
on the host. Everything below is a `solix` CLI call — one grammar, not a
skill per action.

## The grammar

`<verb>-<object>` where verb is `new`, `read`, `edit`, `use`, `rename`,
`delete` and object is `command`, `document`, `skill`, `secret`, `value`,
`rule`. The CLI spells it `<object> <action>`:

```text
new-command      → solix command new <name> --cmd "<shell>" [--dir <path>]
read-command     → solix command list  /  solix command show <name>
edit-command     → solix command new <name> --cmd "…"   (upserts by name)
use-command      → solix command run <name> [--var k=v]…   (opens a shell)
rename-command   → solix command rename <old> <new>
delete-command   → solix command rm <name>

new-document     → solix document new <name>          (body on stdin)
read-document    → solix document list / show <name>
edit-document    → solix document new <name>          (stdin overwrites)
use-document     → solix send <bot> "$(solix document show <name>)"
                   — or cite the file: `solix document` bodies live at
                   ~/Library/Application Support/Solix/Outlines/<name>.md
rename-document  → solix document rename <old> <new>
delete-document  → solix document rm <name>

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

new-rule         → solix rule new <name> --battery-below <n>|--at <iso|+30m>
                   --run "<cmd>"|--keep-awake|--sleep|--sleep-display|--release
read-rule        → solix rule list
edit-rule        → solix rule new <name> …             (upserts by name)
use-rule         → rules fire on their trigger — nothing to invoke
rename-rule      → not supported — rm and re-new
delete-rule      → solix rule rm <id|name>
```

## Variables

Command and document bodies may carry `{{name}}` placeholders. At `run`
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
