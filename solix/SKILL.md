---
name: solix
description: Drive the Solix crew — spawn bots, send them work, read and wait on their terminals. Use when coordinating agents, projects, or terminals on this machine.
---

# Solix

Solix runs a crew of bots — named agents in persistent terminals on this
Mac. The `solix` CLI is the whole API. Terminals keep running after you
detach; nothing is lost when a client disconnects.

## Commands

  solix bot list                              roster + states
  solix bot new <name> --provider <id>        spawn a specialist
              [--model <m>] [--effort <e>]
              [--project <name>] [--parent <bot>] [--secret ENV=SECRET]…
  solix send <bot> [text]                     give it work — multi-line
                                              pastes as one block; pipe
                                              a task body on stdin
  solix read <bot>                            tail its terminal
  solix wait <bot> --until <state>            block until it changes
  solix bot rename <bot> <name>
  solix bot kill <bot>
  solix project list | new <name> --path <dir> | show <name>
  solix project update <name> [--file path]… [--secret ENV=SECRET]…
              [--unfile path]… [--unsecret ENV]… [--provider id]
  solix project rm <id>
  solix skill list | show <name>              the local skill store
  solix providers                             agent CLIs + cheapest model,
                                              cost tier, and promos
  solix runs | run rate <id> <1-5> [notes]    measured results per run —
                                              the routing feedback loop
  solix secret list | set <name> | rm <name>  Mission Secrets — values
                                              enter via stdin only
  solix secret grant|revoke <term> <name>     permit a terminal's marker
  solix pass <term> <name>                    insert a secret at a
                                              concealed prompt

## Secrets without exposure

Programs in managed terminals sometimes prompt for a password (sudo, ssh,
a login). Feed it a stored secret without ever seeing it:

  solix send <term> 'solix:pass:<name>'

The host swaps the marker for the real value only when the terminal is
permitted for that name (`--permit` at spawn, or
`solix secret grant <term> <name>`), the prompt is concealed (no echo),
and the foreground process isn't an agent UI — otherwise the marker goes
through literally. The value never appears in scrollback, `solix read`,
env, or argv. Store secrets with `solix secret set <name>` (stdin, echo
off) or the app's Secrets menu; `solix pass <term> <name>` injects one
directly when the operator is at the keyboard.

Skill invoke: `-<skill>` is Solix's marker — `solix send <bot> -<skill>`
expands that skill's instructions into the message. A chat message of
`-<skill>` means: run `solix skill show <skill>` and follow it. `/`
commands belong to the provider CLI itself — not Solix.

Bot states: active (working) · holding (waiting on input — read it and
decide) · landed (finished) · drifting (quiet) · dark (unknown).

## /solix:* subcommands

Slash commands in the `solix:` namespace act on THIS chat:

  /solix:first-mate   commandeer this agent as the First Mate orchestrator
  /solix:join <proj>  add this chat to a Solix project
  /solix:handoff      leave a durable note for the next agent

Projects get their own slash command by copying `solix:join` into a skill
dir named `solix:<project>` with the name baked in — see `solix skill show
solix:join` for the template.

Fallback for agent CLIs that don't register `:` names: this skill was
invoked WITH a subcommand as its argument (`/solix first-mate`,
`/solix join <project>`, `/solix handoff`, `/solix <project>`). Route it —
run `solix skill show solix:<arg>` and follow those instructions. A bare
`/solix <name>` that isn't a known subcommand means `solix:join <name>`.

## Working pattern

1. `solix providers` to see what's installed.
2. `solix bot new scout --provider codex --project <name> --parent <you>`
3. `solix send scout` with the task — be specific, include file paths.
4. `solix wait scout --until holding` or `--until landed`, then
   `solix read scout` for the result.

Delegate instead of doing everything yourself. Bring the operator in for
judgment calls, and never run destructive commands without asking first.
