---
name: solix:assign
description: Register this thread with the Solix First Mate — report the task up front, then stream milestone updates into its terminal so the orchestrator can track, redirect, or intervene.
argument-hint: "[what this thread is working on]"
---

# Solix Assign

Put this thread under First Mate supervision. The First Mate is the `★`
orchestrator bot; updates arrive as input in its managed terminal, where it
can read them, re-plan, or delegate.

## Register

1. Find the First Mate — the `★` row in:
   `solix bot list`
   If no orchestrator is running, ask the user whether to wake one
   (`solix mate --no-attach`) rather than spawning silently.
2. Announce this thread — one line, facts only:
   `solix send <mate> "ASSIGN — <provider/chat>: <task>. scope: <repo or
   project>. updates to follow."`
   Name the bot by name or id prefix — `solix send` resolves either.

## Report

Send an update at every meaningful transition — not on a timer:

```text
solix send <mate> "UPDATE — <what just landed / what changed / blocker>"
```

- Landed work, plan changes, blockers, and anything needing a decision.
- If the First Mate gave you an issue number, cite it — `"UPDATE — #<n>
  <progress>"` — so the relay lands on the GitHub issue.
- Keep each update to one or two lines; transcripts belong to the terminal,
  not the orchestrator's input queue.
- Never send secrets or secret values — names are permits only.

## Close out

```text
solix send <mate> "DONE — <outcome>. <artifact paths / repo state>"
solix memory add outcome "<summary>"   # durable, for the next chat
```

If the thread is ending unfinished, send `HANDOFF —` instead of `DONE —` and
persist the remainder with `/solix:handoff` so a successor picks it up.
