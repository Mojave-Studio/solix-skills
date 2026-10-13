---
name: load
description: Load Helm register items into THIS chat — secrets, skills, docs, values, commands, rules, or the whole Helm. The operator picks all-vs-one in a Mac popup the agent never sees; selected items are inserted as incoming work.
argument-hint: "[helm|secrets|skills|docs|values|commands|rules]"
---

# Solix Load

Insert Helm items into THIS chat as incoming work. A Mac popup lets the
operator pick all-vs-one; you never see the picker. After it returns, the
host types a `[solix] Loaded …` block into this terminal.

## Run

From this managed chat:

```text
solix load helm
solix load secrets
solix load skills
solix load docs
solix load values
solix load commands
solix load rules
```

Aliases: `solix load-helm`, `solix load-secrets`, and the same for each
register. `load helm` confirms on the Mac, then inserts every register
(skills and docs as catalogs — names and summaries). The others open a
Mac popup: All …, or one name. `--all` skips the popup. `--name N` (or a
trailing name) loads that entry. `--term` if `SOLIX_TERMINAL_ID` is unset.

If `$ARGUMENTS` names a register (`helm`, `secrets`, `load-secrets`, …),
pass it through: `solix load <register>`.

## After it lands

Use the `[solix] Loaded` block. Secret rows are names and kinds only —
this terminal is then permitted for `solix:pass:<name>`. Never print secret
values. A catalog skill or doc is a table of contents; load that name for
the full body. Private docs stay off the worker shelf; the First Mate can
see them.
