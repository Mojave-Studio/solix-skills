# solix-skills

The Solix skill set — agent-agnostic instructions that teach any coding agent
to drive a [Solix](https://solix.fyi) host: persistent terminals, a bot crew,
the First Mate orchestrator, projects as containers, and provider-agnostic
memory. Works with Devin, Claude Code, Codex, Copilot, Cursor, Grok, Gemini,
Kimi, and any agent that can read a `SKILL.md`.

## Install — for humans

```sh
# Into a Solix host (imports every skill in this repo):
solix skill add Mojave-Studio/solix-skills

# Or standalone — clone and link into your agent's skills dir:
git clone https://github.com/Mojave-Studio/solix-skills ~/.config/solix-skills
~/.config/solix-skills/install.sh
```

`install.sh` links each skill into every agent skills directory it finds on
your machine (`~/.config/devin/skills`, `~/.claude/skills`, `~/.codex/skills`,
`~/.copilot/skills`, `~/.cursor/skills`, `~/.agents/skills`, `~/.grok/skills`,
`~/.config/goose/skills`, `~/.config/crush/skills`, `~/.codeium/windsurf/skills`,
`~/.config/kimchi/harness/skills`, `~/.antigravity/skills`). It never
overwrites — existing directories are skipped.

## Install — for agents

> If an agent is reading this: fetch each `SKILL.md` and place it at
> `<your skills dir>/<skill name>/SKILL.md`. Use whichever of these directories
> your platform reads — create it if missing. Steps:
>
> 1. Identify your skills directory from the list above (or your platform's
>    documented equivalent). On Linux/macOS `~` is the user's home.
> 2. For each name `solix`, `solix:first-mate`, `solix:join`, `solix:handoff`, `solix:assign`, `solix:command-build`, `solix:revive`, `solix:git`, `solix:helm`, `solix:flight-plan`, `solix:usage`:
>    ```sh
>    mkdir -p "<skills-dir>/<name>"
>    curl -fsSL "https://raw.githubusercontent.com/Mojave-Studio/solix-skills/main/<name>/SKILL.md" \
>         -o "<skills-dir>/<name>/SKILL.md"
>    ```
> 3. If your platform can't resolve skill names containing `:` — skip those
>    two files; the base `solix` skill documents the `/solix <subcommand>`
>    fallback form that works everywhere.
> 4. Tell the user the skills are installed and which directory you used.

## The skills

| skill | what it does |
|---|---|
| `solix` | the `solix` CLI surface — commands, vocabulary, the `-<skill>` invoke marker. Base fallback for providers without `:` skill names: `/solix first-mate`, `/solix join <project>`, `/solix handoff` |
| `solix:first-mate` | commandeers the current agent as the First Mate orchestrator — crew management, routing charter (locality → capacity → cost → measured runs) |
| `solix:join` | attach the current chat to a Solix project — adopts its path, working files, secret permits, and provider |
| `solix:handoff` | write a durable handoff note into Solix memory for the next agent |
| `solix:assign` | put this thread under First Mate supervision — announce the task, stream milestone updates into its terminal, close out with DONE or HANDOFF |
| `solix:command-build` | save a shell command as a Flight Plan so Solix can open and run it as a plain terminal later — no agent chat needed |
| `solix:revive` | hand this chat's work to a fresh successor bot before running out of context — handoff, spawn, brief, exit cleanly |
| `solix:git` | drive the user's git repos through `solix git` — status, diff, AI-drafted commits, branches, pull requests, push; plain-speech requests map to ops |
| `solix:helm` | manage the user's Helm registers — commands, skills, secrets, values, rules — through one verb-object grammar (`solix command new`, `solix secret read`, …) |
| `solix:flight-plan` | work a flight plan — a queued checklist fed to assigned terminals; details and outcomes recorded in the shared doc |
| `solix:usage` | read usage across every linked provider — windows, % left, resets, walls, promo pools, and measured run results |

A project-specific command (`/solix:<project>`) is just a copy of
`solix:join` with the project name baked in.

## Requirements

A Solix host to talk to — the macOS menu-bar app plus the `solix` CLI on
`PATH`. The skills degrade gracefully without one: they describe the
orchestration model but commands will report the host unreachable.

## Security model (short version)

- Everything rides the local machine's AF_UNIX socket or the local network —
  there is no public control plane.
- New devices pair with a one-time token: QR scan on iPhone, or `solix pair`
  which prints an invite blob + a short verification code to compare on both
  ends (the headless path — works for machines with no camera).
- Secrets are named permits stored in the macOS keychain; agents see permit
  names, values are injected into the spawned process environment and never
  cross the wire.
- Per-device permissions gate every remote operation; a freshly paired device
  gets view-status only.
