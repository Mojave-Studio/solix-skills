---
name: solix:command-build
description: Save a shell command to the Solix Flight Plans register so it can be opened and run later as a plain terminal — no agent chat required. Use when the user wants a reusable one-tap/one-command shortcut (a build, a deploy step, a log tail) rather than something an agent needs to reason about each time.
argument-hint: "<name> — what the command should do"
---

# Solix Command Build

A Flight Plan is a saved shell command Solix can open in a terminal on
demand — the host runs it like any other terminal, it just didn't need
retyping. It is not an agent: nothing reads or reasons about the output,
it is exactly `solix new --cmd "<the command>"` with a name attached.

Use this when the user wants a shortcut to a shell one-liner or a short
script, not when they want an agent watching a task.

1. Work out the exact command line the user wants saved, and where it
   should run from (a project directory, or none — the login shell's home).
   `{{name}}` placeholders pull from the Values register at run time
   (`solix value set <name> <value>`) — use one instead of hardcoding
   anything the user is likely to change later (a branch name, a host, a
   port).
2. Save it:
   `solix command new <name> --cmd "<shell>" [--dir <path>]`
   `<name>` is how it's found again — case-insensitive, rename-safe.
3. Confirm what got saved: `solix command show <name>` prints the name,
   directory, command, and any `{{var}}`s it references.
4. Tell the user how to run it later — any of:
   - `solix command run <name>` — opens a terminal on the host and runs it
     immediately, from wherever they already have a shell.
   - From inside the `solix` TUI: `^G h` opens the Helm dashboard, select
     Flight Plans, press Enter on the row.
   - `solix helm` — the standalone Helm dashboard, same Flight Plans list,
     runnable without the TUI multiplexer running first.
   - The Mac app's Helm window, or the Crew app's Helm tab, under Flight
     Plans — tap it, it opens the same way.

Editing later: `solix command new <name> --cmd "…"` again overwrites the
body (matched by name); `solix command rename <old> <new>` renames without
losing the id other setups may reference. Delete with `solix command rm <name>`.
