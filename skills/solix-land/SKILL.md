---
name: solix-land
description: Land the current Solix terminal — close its window/viewers while the shell keeps running on the host, cached for later resume. Use when asked to land/park this terminal or wrap up and exit a Solix session.
---

# Solix Land

`solix land` IS the verb — it calls `terminal.land`, which releases the
window's kill-on-close binding and closes its tabs/viewers while the PTY
keeps running on the host (sessiond). Resumable later.

NEVER use `solix kill` for landing — kill destroys the PTY; that is the
opposite of caching it.

## Procedure

1. Leave the tree clean: commit/push pending work, or state clearly what is
   uncommitted. Never land with silent uncommitted work.
2. Run `solix land` LAST:
   - Inside a **managed** solix shell: bare `solix land` self-lands via
     `SOLIX_TERMINAL_ID` — your attach exits and the tab closes.
   - In a **foreign/external** terminal (no `SOLIX_TERMINAL_ID` — bare
     `solix land` errors with usage): find the id in `solix status` and run
     `solix land <id-prefix>`.

## Details

- External windows: `solix land <id>` records the recipe (command + cwd +
  emulator) in `landed-terminals.json` and closes solix viewers, but cannot
  close a Terminal/iTerm window it doesn't own — close that window yourself.
  Do NOT `solix adopt` to force it: adopt kills the foreign session and
  respawns it managed — destructive mid-work.
- Resume a landed terminal: `solix attach <id>` or `solix takeoff <id>`,
  or reopen from the Landed shelf in the Solix menu.
- Bots are separate: `solix bot land <bot>` parks a bot for takeoff;
  `solix bot takeoff <bot>` resumes it in place.
