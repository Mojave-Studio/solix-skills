# solix-skills

A repository of agent-agnostic `SKILL.md` packages for driving a
[Solix](https://solix.fyi) host — persistent terminals, a bot crew, the First
Mate orchestrator, projects, and shared memory.

If you are an agent reading this: each directory under `skills/` is one
installable skill. Copy the ones you want into your platform's skills
directory (`~/.claude/skills`, `~/.codex/skills`, `~/.config/devin/skills`,
`~/.agents/skills`, or your platform's documented equivalent — create it if
missing). Fetch them individually:

```sh
mkdir -p "<skills-dir>/<name>"
curl -fsSL "https://raw.githubusercontent.com/Mojave-Studio/solix-skills/main/skills/<name>/SKILL.md" \
     -o "<skills-dir>/<name>/SKILL.md"
```

Or clone the repo and run `./install.sh` to link every skill into every agent
skills directory it finds. See [README.md](README.md) for the full install
matrix and the skill list.
