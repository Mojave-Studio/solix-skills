---
name: solix-handoff
description: Leave a durable handoff note in Solix memory — what this chat did, what's next, and what's blocking — so the next agent or session can pick up without re-reading transcripts. With a harness argument, also spawn a successor bot on that provider (optional model) and brief it to continue the work immediately.
argument-hint: "[harness: claude|codex|devin|antigravity|kimi|cursor-agent] [model]"
---

# Solix Handoff

Three modes — arguments arrive as text after the command (`$ARGUMENTS`
on Claude Code, appended `ARGUMENTS:` on others):

- `/solix:handoff` — write the note, done.
- `/solix:handoff providers` (or `?`) — run `solix providers` and show
  the installed harnesses with their models and cheapest pick. No note,
  no spawn — this is how you see the live options when the provider
  list changes.
- `/solix:handoff <harness> [model]` — write the note, then spawn a
  successor on that provider and hand it the work. "Harness" is a
  provider id from `solix providers` (claude, codex, devin,
  antigravity, kimi, cursor-agent). Model is optional — omit it for the
  provider default.
- If the first argument isn't a provider id, treat the arguments as
  extra context for the summary and skip the spawn.

## 1. Write the note

Summarize this chat for whoever comes next — goal, what was accomplished,
what remains, the immediate next step, and any blockers. When a harness
was given, also capture the live state a successor needs: cwd, branch,
uncommitted files, running processes, open questions. Facts only — no
transcript dumps, no internal reasoning.

Record it:

```text
solix memory add handoff "<summary>"
```

The command prints the new node's uuid. Capture it — the successor's
brief points at it.

If this chat belongs to a group (check `solix memory list` for a
`group:<name>` node), link them:

```text
solix memory add handoff "<same summary>" --link relatesTo:<group-uuid>
```

or, if the group node already has a chat resource, link `continues:` to
that chat's node instead.

## 2. No harness → stop

Report the node id to the user. Done.

## 3. With a harness → spawn the successor

```text
solix ping                        host must be up
solix providers                   confirm <harness> is installed;
                                 if not, show the list and stop
```

If `solix limits` shows that provider walled, say so and ask whether to
use it anyway or pick another harness.

Pick a name: `<your-bot-name>-next` when you know your Solix bot name
(launch brief / `solix bot list`); otherwise `<project-or-cwd>-handoff`.
Carry `--project` from this chat's project (match cwd in
`solix project list`); add `--parent <you>` when you are a bot.

```text
solix bot new <name> --provider <harness> [--model <model>] [--project <p>] [--parent <you>]
```

## 4. Brief it

```text
solix send <successor> "You succeed <you>. First: run \`solix memory list\` and read handoff <uuid>. cwd: <dir>. Done: <one line>. Next: <one line>. If a First Mate supervises this crew, re-register per solix-assign."
```

The brief is a pointer; the handoff node carries the detail. Confirm it
woke:

```text
solix wait <successor> --until active --timeout 60
```

## 5. Yield

Report the handoff node id and successor name to the user, then stop
working — the successor owns the task now; keep going and two agents
edit the same files. Suggest `/solix:land` if this terminal should park.
