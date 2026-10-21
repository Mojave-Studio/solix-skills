---
name: solix
description: Drive a Solix host through the `solix` CLI — persistent terminals, a crew of coding agents with a First Mate orchestrator, the routed task queue, projects, shared memory, secrets, the Helm registers, fleet machines, git, and Mac controls. Use when coordinating agents, tasks, projects, or terminals on a machine running Solix, or when the user mentions Solix, the First Mate, or `solix`.
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
SHELLS & TERMINALS
  solix                                       toolbar dashboard — ⏎ opens a
                                              shell, ^] returns
  solix mux                                   multiplexer — ^G o switch ·
                                              ^G n new · ^G l usage · ^] detach
  solix list                                  every live terminal
  solix new [--title T] [--cwd D] [--cmd C] [--permit SECRET]…
              [--secret ENV=SECRET]… [--on HOST]
                                              --on runs the shell over ssh
                                              (~/.ssh/config alias, user@host,
                                              a Tailscale name)
  solix open [--title T] [--cwd D] [--cmd C]  new + attach in one
  solix send <term|bot> [text]                type into it — multi-line pastes
                                              as one block; pipe a body on stdin
  solix read <term|bot> [--bytes N]           scrollback tail
  solix attach <id> | chat <bot>              live view — Ctrl-] detaches
  solix land [id|bot]                         close windows, shell keeps running
  solix takeoff <id|bot>                      undo a land
  solix adopt <id>                            re-home an external window onto a
                                              solix PTY — command restarts
  solix watch|unwatch <id|bot>                put under / drop First Mate
                                              supervision
  solix rename <id> <name>                    retitle a terminal in the roster
  solix kill <term|bot>

CREW
  solix bot list                              roster + states
  solix bot new <name> --provider <id>        spawn a specialist agent
              [--model <m>] [--effort <e>] [--project <name>]
              [--parent <bot>] [--issue <repo>#<n>] [--secret ENV=SECRET]…
              [--paperclip]
  solix wait <bot> --until <state> [--timeout S]
  solix bot queue <bot> <message>             park a message until the bot
                                              needs input
  solix bot issue <bot> <repo>#<n>|none       link a bot to a git issue —
                                              state lands as solix:* labels
  solix bot land|takeoff <bot>                park for later / resume in place
  solix bot rename <bot> <name> | bot kill <bot>
  solix mate [--project <name>] [--provider P] [--model M]
             [--name n] [--instructions t] [--paperclip|--no-paperclip]
             [--no-attach]                    wake the First Mate — --name mints
                                              a specialist mate (git, iMessage)
  solix providers                             installed agent CLIs, cheapest
                                              model, cost tier, promos
  solix limits [--history]                    usage windows: % left, resets, walls
  solix runs | run rate <id> <1-5> [notes]    measured results per run

TASKS & ROUTING
  solix task new <title> [--brief t|--brief-file f] [--project p]
              [--issue repo#n] [--provider id] [--model m] [--effort l]
              [--depends-on id]… [--approve] [--elevated]
              [--scope prefix]… [--require path]…
                                              the durable work queue — the host
                                              routes, spawns, re-routes on walls
                                              and verifies completion
  solix task list | show | approve | cancel <id>
  solix route [--project p] [--provider id] [--model m] [--effort l]
              [--exclude id]…                 the open executor with the most
                                              headroom — skips walls and the
                                              First Mate's own provider
  solix consult <chatgpt|claude|gemini|grok|kimi> [--context t] [--no-open] <prompt>
                                              ask a fresh consumer chat for
                                              planning/research advice
  solix consult list | status <uuid>

FLEET (paired remote hosts)
  solix pair                                  one-time pairing invite + code
  solix fleet | fleet add <name> <invite> | fleet show <name>
  solix delegate <machine> <task>             run work on a fleet machine —
                                              --mate briefs its First Mate,
                                              --attach follows live

PROJECTS, MEMORY & DOCS
  solix project list | new <name> --path <dir> | show <name> | rm <id>
  solix project update <name> [--file path]… [--secret ENV=SECRET]…
              [--skill name]… [--providers a,b] [--startup cmd]…
              [--unfile…] [--unskill…] [--unsecret…] [--provider id]
  solix project scan | import <path>…         register roots other agent
                                              CLIs already know
  solix memory list | add <kind> <summary> [--detail t] [--link rel:uuid]
  solix docs list | show <title|id>           the Docs register — where agents
                                              should look; * = private to the
                                              operator + the mate
  solix docs add note|link <title> [body|url] | docs rm <title|id>
  solix docs add vault|folder <path>          Obsidian vaults & folders route
                                              to their own live stores
  solix vault scan|list|import <path> [--project p]|notes|read|rm

HELM (the user's saved rig)
  solix command list | show | new <n> --cmd "…" [--dir p] | run <n> [--var k=v]…
             | rename <old> <new> | rm <n>
  solix value list | set <n> <v> | rename | rm
                                              the {{var}} table
  solix settings list | set <n> <v> | rename | rm
                                              host config — autonomy, mate
                                              bindings, alert routes
  solix file list | set <name> <path> | show <name> | rename | rm
                                              name → path pointers (key/cert
                                              material — contents stay on disk)
  solix skill list | show <name> | add <owner/repo|path> | rm <name>
  solix load helm|secrets|skills|docs|values|commands|files
              [--all] [--name N] [--term id]  insert into THIS chat (Mac popup)
  solix agents audit | unify [--apply]        align AGENTS.md / CLAUDE.md …
  solix helm | solix usage                    standalone dashboards

SECRETS
  solix secret list | types                   names + kinds — values never shown
  solix add secret: <name> [--type K]         add/rotate; value via stdin only
  solix secret set <name> [--type K] | secret rm <name>
  solix secret apply "<name>" [--env VAR] -- <cmd>…
                                              host runs <cmd> with the value on
                                              stdin (or as $VAR); output redacted
  solix secret grant|revoke <term> <name>     permit a terminal's marker
  solix pass <term> <name>                    operator injects at a prompt

  "Use the secret X" means `solix secret apply`, never ask for or print it:
    solix secret apply "Pela Open AI key" -- npx wrangler pages secret put OPENAI_API_KEY --project-name <p>

MESSAGING
  solix slack setup                           Slack CLI project for bot "Solix";
                                              then `slack install` + `slack run`
  solix text --slack <channel> [--thread <ts>] "<reply>"
                                              answer a Slack message in its thread
  solix text --whatsapp <digits> | --line <user-or-group> | --managed-line <uid>
                                              reply through WhatsApp / LINE /
                                              the managed Solix LINE account
  solix webhooks [--bind h:p]                 local WhatsApp/LINE webhook edge —
                                              needs public HTTPS for callbacks
  solix line-link                             one-time code to bind a sender

GIT & MACHINE
  solix git status|repos|scan|log|diff|draft [--kind commit|pr|branch]
             |commit [--ai] [--push]|fetch|push|branch [new|rm]|checkout
             |pr [list|new [--ai]]|init|clone|add|exec -- <args>
  solix machine lock | awake [30m|1h|4h|until|off|+N] | mute
             | volume up|down | brightness <0-100>
  solix machine sleep --yes | restart --yes   ends sessions — ask first
  solix sleep off|on|30m|1h|4h|+N             keep-awake — off defeats clamshell
                                              sleep on battery too

MCP
  solix mcp                                   stdio MCP server for local clients
  solix mcp --http [h:p] [--expose]           local Streamable HTTP + optional
                                              personal Cloudflare tunnel
  solix mcp cloud on|off|status|signin|signout
                                              host-owned bridge to
                                              mcp.solix.fyi (multi-tenant OAuth)
  solix mcp --check                           handshake self-check
```

Specialised skills cover the deeper workflows — load them when the task
calls for it: `solix-first-mate`, `solix-git`, `solix-helm`,
`solix-load`, `solix-usage`, `solix-revive`, `solix-agents`,
`solix-mcp`, `solix-skills`, `solix-land`.

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

- **Bot states:** ● active (working) · ◐ holding (waiting on input — read
  it and decide) · ◔ limited (provider rate-limited) · ✓ landed (parked —
  `solix bot takeoff` resumes it) · ✔ done (finished) · drifting (quiet) ·
  ? dark (unknown).
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
/solix:land         land this terminal — windows close, shell keeps running
/solix:load-helm    insert every Helm register into this chat
/solix:load-secrets operator picks all secrets or one (Mac popup)
/solix:load-skills  operator picks all skills or one
/solix:load-docs    operator picks all docs or one
/solix:load-values  operator picks all values or one
/solix:load-commands operator picks all commands or one
/solix:load-files   operator picks all file pointers or one
```

Agent CLIs that don't register `:` names invoke this skill with the
subcommand as its argument (`/solix first-mate`, `/solix join <project>`).
Route it: run `solix skill show solix-<arg>` and follow that. A `load` or
`load-*` argument routes to `solix skill show solix-load`. A bare
`/solix <name>` that isn't a known subcommand means `solix-join <name>`.

## Bare `/solix` — register this terminal

`/solix` with NO subcommand and NO argument at all means "register this
terminal." Run `solix register` (pass `--title <name>` guessing something
identifying — the agent/provider name if known). Then tell the operator
it's now visible in Solix as an external terminal: listed and killable from
the app, but Solix can't attach to it or send it input, since it didn't
spawn this terminal and doesn't own its PTY.

## Working pattern

1. `solix status` and `solix providers` — see what's running and installed.
2. `solix limits` — don't hand work to a provider that's walled.
3. `solix bot new scout --provider codex --project <name> --parent <you>`
4. `solix send scout "<task — specific, with file paths and a stopping condition>"`
5. `solix wait scout --until holding` (or `landed`), then `solix read scout`.

Delegate instead of doing everything yourself. Bring the user in for
judgment calls. Never run destructive commands — kills, sleep, restart,
force pushes — without asking first.
