---
name: solix:revive
description: Hand this chat's work to a fresh successor bot before running out of context — write the handoff, spawn a replacement on the same project, brief it, and exit cleanly instead of dying mid-task.
argument-hint: "[extra context for the successor]"
---

# Solix Revive

A bot that runs dry mid-task loses whatever it never wrote down. Revive
trades the last slice of context for continuity: near the limit, stop
taking on new work, record the state, spawn a successor, and exit
cleanly. Done at a milestone boundary the successor picks up where you
stopped; done late, it picks up from ruins.

## 1. Detect

Check your remaining context/token budget at every milestone — after a
landed edit, a test run, a subtask close:

- Read the provider CLI's own gauge: `claude` shows context-left
  percentage, `codex` prints token counts, others surface usage meters
  or compaction warnings. There is no `solix` command that reads a
  chat's context — the gauge lives in your own UI.
- No gauge? Self-assess: a compaction warning, a truncated recall of the
  original task, or a very long session all mean low.
- **Threshold: revive at ~20–25% context remaining.** Below that there
  may not be room to write a good handoff. Finish the current step,
  then revive — never start a new subtask below the line.

## 2. Hand off

Persist what a stranger needs — same conventions as `/solix:handoff`:
goal, what's done, what remains, blockers, key file paths. Facts only.

```text
solix memory add handoff "<goal — done — remaining — blockers — paths>"
```

The command prints the new node's uuid. Capture it — the successor's
brief points at it.

## 3. Spawn the successor

```text
solix bot new <yourname>-next --provider <id> --project <same> --parent <you>
            [--model <m>] [--effort <e>]
```

- Same project; same model/effort you were launched with (`solix bot
  list` shows provider and state, not model — carry it from your own
  brief). `--parent` marks the lineage — name or id prefix resolves.
- If this provider is WHY you ran dry — small context, wrong fit —
  route the successor elsewhere: `solix providers` for what's
  installed, `solix limits` for account headroom, `solix runs` for
  measured results. Note the reroute in the handoff.

## 4. Brief it

```text
solix send <successor> "You succeed <you>. First: run \`solix memory list\`
and read handoff <uuid>. cwd: <dir> — project <name>. Done: <one line>.
Next: <one line>. If a First Mate supervises this crew, re-register per
solix:assign."
```

The brief is a pointer; the handoff node carries the detail. Confirm the
successor woke:

```text
solix wait <successor> --until active --timeout 60
```

## 5. Stop

If a First Mate supervises you, report the succession —
`solix send <mate> "REVIVED — <successor> continues <task>; handoff
<uuid>"` — then exit cleanly. Do not keep working until truncation: a
stopped file beats a half-written one.

## First Mate: reviving a fading bot

`solix read <bot>` tails the provider's own context gauge in scrollback.
When a worker runs low:

1. Prefer `solix send <bot> -solix:revive` — the marker expands this
   skill into the bot's input and it runs the sequence itself.
2. If the bot is already unresponsive, run the steps on its behalf:
   write the handoff from its scrollback (`solix memory add handoff
   "on behalf of <bot>: <state>"`), spawn `<bot>-next` with
   `--parent <bot>`, brief the successor with the handoff uuid, then
   `solix bot kill <bot>` once the successor is working.
