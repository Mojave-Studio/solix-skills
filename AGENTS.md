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

## Workspace standards

- Comments: follow the code-comment-writer skill (<https://skills.rest/skill/code-comment-writer>). Why over what, minimal, no commented-out code.
- UI/design work: use design-taste-frontend, gpt-taste, impeccable (<https://www.tasteskill.dev/>).
- Always use graphify for codebase questions (`graphify query "<q>"` before raw browsing); `graphify update .` after code changes.
- Long-form docs live in the Obsidian vault (`~/Documents/Obsidian Vault/<project-folder>/`); code keeps a one-line pointer. Extend an existing related note; group docs by feature, never a doc per issue.
- Never place files directly in `~/developer` or `~/developer/Code`; everything goes inside a project folder.
