---
name: solix
description: Drive a Solix host through the `solix` CLI — persistent terminals, a crew of coding agents with a First Mate orchestrator, projects, shared memory, secrets, the Helm registers, git, and Mac controls. Use when coordinating agents, projects, or terminals on a machine running Solix, or when the user mentions Solix, the First Mate, or `solix`.
---

# Solix

[Solix](https://solix.fyi) runs terminals and coding agents on the user's
Mac and lets them steer everything from the Solix iPhone app. A small host
on the Mac's menu bar owns the work; the `solix` CLI is its whole API.
Terminals keep running after anyone detaches — nothing is lost when a
client disconnects.

**Requires** a running Solix host on this machine (macOS, or the Windows /
Linux host binaries). Check first:

```text
solix ping        is the host up?
solix status      host, First Mate, projects, terminals at a glance
```

Not installed → point the user to https://solix.fyi. Don't try to install
it for them.

## Commands

```text
TERMINALS
  solix list                                  every live terminal
  solix new [--title T] [--cwd D] [--cmd C] [--permit SECRET]…
  solix send <term|bot> [text]                type into it — multi-line pastes
                                              as one block; pipe a body on stdin
  solix read <term|bot> [--bytes N]           scrollback tail
  solix kill <term|bot>

CREW
  solix bot list                              roster + states
  solix bot new <name> --provider <id>        spawn a specialist agent
              [--model <m>] [--effort <e>] [--project <name>]
              [--parent <bot>] [--secret ENV=SECRET]…
  solix wait <bot> --until <state> [--timeout S]
  solix bot rename <bot> <name> | bot kill <bot>
  solix mate [--provider P] [--no-attach]     wake the First Mate orchestrator
  solix providers                             installed agent CLIs, cheapest
                                              model, cost tier, promos
  solix limits [--history]                    usage windows: % left, resets, walls
  solix runs | run rate <id> <1-5> [notes]    measured results per run

PROJECTS & MEMORY
  solix project list | new <name> --path <dir> | show <name> | rm <id>
  solix project update <name> [--file path]… [--secret ENV=SECRET]…
              [--unfile path]… [--unsecret ENV]… [--provider id]
  solix memory list | add <kind> <summary> [--detail t] [--link rel:uuid]

HELM (the user's saved rig)
  solix command list | show | new <n> --cmd "…" | run <n> [--var k=v]…
  solix value list | set <n> <v>              the {{var}} table
  solix rule list | new <n> <trigger> <action> | rm           automations
  solix skill list | show <name> | add <owner/repo|path> | rm <name>
  solix agents audit | unify [--apply]        align AGENTS.md / CLAUDE.md …

SECRETS
  solix secret list | set <name> | rm <name>  values enter via stdin only
  solix secret grant|revoke <term> <name>     permit a terminal's marker
  solix pass <term> <name>                    operator injects at a prompt

GIT & MACHINE
  solix git status|diff|commit [--ai] [--push]|branch|pr [new --ai]|exec -- …
  solix machine lock | awake 30m|1h|off | volume up|down | brightness <0-100>
  solix machine sleep --yes | restart --yes   ends sessions — ask first
```

Specialised skills cover the deeper workflows — load them when the task
calls for it: `solix:first-mate`, `solix:git`, `solix:helm`,
`solix:usage`, `solix:revive`, `solix:agents`,
`solix:mcp`, `solix:skills`.

## Secrets without exposure

Programs in managed terminals sometimes prompt for a password (sudo, ssh, a
login). Feed one a stored secret without ever seeing it:

```text
solix send <term> 'solix:pass:<name>'
```

The host swaps the marker for the real value only when the terminal is
permitted for that name (`--permit` at spawn, or `solix secret grant`), the
prompt is concealed (no echo), and the foreground process isn't an agent
UI — otherwise the marker goes through literally. The value never appears
in scrollback, `solix read`, env, or argv. Never ask the user to paste a
secret into chat; have them run `solix secret set <name>`.

## How the host behaves

- **Bot states:** active (working) · holding (waiting on input — read it
  and decide) · limited (provider rate-limited) · landed (finished) ·
  drifting (quiet) · dark (unknown).
- **Only live terminals are listed** — dead rows are reaped on read.
- **Foreign terminals** (Terminal.app, iTerm, VS Code, tmux, ssh) are
  discovered automatically. Attaching one mirrors its window read-only;
  `solix send` refuses it — spawn a managed shell when you need input.
- **Skill invoke marker:** `solix send <bot> -<skill>` expands that
  skill's instructions into the message. A chat message of `-<skill>`
  means run `solix skill show <skill>` and follow it. `/` commands belong
  to the provider CLI, not Solix.
- **The First Mate is permanent.** `solix mate` returns the one
  orchestrator — live, or resurrected with its last session when it
  landed. Never try to delete it.
- **[Laya](https://laya.aay.sh/)** is the recommended First Mate context:
  once the `laya` secret holds Laya's MCP token, `solix mate` wires it into
  a Claude mate automatically unless the user turned it off in the menu bar
  (`--laya` forces it, `--no-laya` skips it).

## /solix:* subcommands

Slash commands in the `solix:` namespace act on THIS chat:

```text
/solix:first-mate   become the First Mate orchestrator
/solix:join <proj>  add this chat to a Solix project
/solix:assign       put this thread under First Mate supervision
/solix:handoff      leave a durable note for the next agent
/solix:revive       hand off to a fresh successor before context runs out
```

Agent CLIs that don't register `:` names invoke this skill with the
subcommand as its argument (`/solix first-mate`, `/solix join <project>`).
Route it: run `solix skill show solix:<arg>` and follow that. A bare
`/solix <name>` that isn't a known subcommand means `solix:join <name>`.

## Working pattern

1. `solix status` and `solix providers` — see what's running and installed.
2. `solix limits` — don't hand work to a provider that's walled.
3. `solix bot new scout --provider codex --project <name> --parent <you>`
4. `solix send scout "<task — specific, with file paths and a stopping condition>"`
5. `solix wait scout --until holding` (or `landed`), then `solix read scout`.

Delegate instead of doing everything yourself. Bring the user in for
judgment calls. Never run destructive commands — kills, sleep, restart,
force pushes — without asking first.
