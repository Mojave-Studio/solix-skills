<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/wordmark-dark.png">
    <img src="assets/wordmark-light.png" width="260" alt="Solix">
  </picture>
</p>

<h1 align="center">solix-skills</h1>

<p align="center">
  <em>Your Mac stays put. Your agent reaches it.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/github/stars/Mojave-Studio/solix-skills?style=flat-square&color=111111&label=stars" alt="Stars">
  <img src="https://img.shields.io/badge/skills-11-111111?style=flat-square" alt="11 skills">
  <img src="https://img.shields.io/badge/works%20with-any%20SKILL.md%20agent-111111?style=flat-square" alt="Works with any SKILL.md agent">
  <img src="https://img.shields.io/badge/license-MIT-111111?style=flat-square" alt="MIT license">
</p>

---

The Solix skill set — agent-agnostic instructions that teach any coding agent
to drive a [Solix](https://solix.fyi) host: persistent terminals, a bot crew,
the First Mate orchestrator, projects as containers, and provider-agnostic
memory. Works with Devin, Claude Code, Codex, Copilot, Cursor, Grok, Gemini,
Kimi, and any agent that can read a `SKILL.md`.

## Get the app

The skills drive a Solix host — grab the app first:

```sh
curl -fLO https://solix.fyi/Solix-macOS.zip && unzip Solix-macOS.zip && cd Solix
xattr -dr com.apple.quarantine Solix.app   # signed run-locally, not notarized
open Solix.app                           # menu bar — keep it running
./solix install                          # CLI → ~/.local/bin · app + login agent
```

Then pair your iPhone from the app. Windows and Linux hosts are single
binaries — install steps at [solix.fyi](https://solix.fyi/#get).

## Install the skills

### In the app

```sh
solix skill add Mojave-Studio/solix-skills
```

Imports every skill in this repo into the host's store and links them into
each installed agent's skills directory — no editor config needed.

### Claude Code

```
/plugin marketplace add Mojave-Studio/solix-skills
```
```
/plugin install solix@solix-skills
```

### Codex

```bash
codex plugin marketplace add Mojave-Studio/solix-skills
codex plugin add solix@solix-skills
```

### Devin CLI

```bash
devin plugins add Mojave-Studio/solix-skills
```

### Standalone — every agent at once

`install.sh` links each skill into every agent skills directory it finds on
your machine. It never overwrites — existing entries are skipped.

```sh
git clone https://github.com/Mojave-Studio/solix-skills ~/.config/solix-skills
~/.config/solix-skills/install.sh
```

It scans `~/.config/devin/skills`, `~/.claude/skills`, `~/.codex/skills`,
`~/.copilot/skills`, `~/.cursor/skills`, `~/.agents/skills`, `~/.grok/skills`,
`~/.config/goose/skills`, `~/.config/crush/skills`,
`~/.codeium/windsurf/skills`, `~/.config/kimchi/harness/skills`, and
`~/.antigravity/skills`.

### Install — for agents

> If an agent is reading this: fetch each `SKILL.md` and place it at
> `<your skills dir>/<skill name>/SKILL.md`. Use whichever of the directories
> above your platform reads — create it if missing. Steps:
>
> 1. Identify your skills directory from the list above (or your platform's
>    documented equivalent). On Linux/macOS `~` is the user's home.
> 2. For each name `solix`, `solix:first-mate`, `solix:join`, `solix:handoff`, `solix:assign`, `solix:command-build`, `solix:revive`, `solix:git`, `solix:helm`, `solix:flight-plan`, `solix:usage`:
>    ```sh
>    mkdir -p "<skills-dir>/<name>"
>    curl -fsSL "https://raw.githubusercontent.com/Mojave-Studio/solix-skills/main/skills/<name>/SKILL.md" \
>         -o "<skills-dir>/<name>/SKILL.md"
>    ```
> 3. If your platform can't resolve skill names containing `:` — skip those
>    files; the base `solix` skill documents the `/solix <subcommand>`
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

## Uninstall

| Install path | Command |
|---|---|
| Solix host | `solix skill remove <name>` per skill |
| Claude Code | `/plugin remove solix` |
| Codex | `codex plugin remove solix` |
| Devin CLI | `devin plugins remove solix` |
| `install.sh` links | delete the `solix*` symlinks it created under each agent skills dir |

## License

[MIT](LICENSE).
