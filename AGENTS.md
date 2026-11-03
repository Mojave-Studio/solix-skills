# solix-skills

Distribution source for the Solix agent skills — `skills/` holds the
authored skill directories; `install.sh` installs them per-agent.
`claude/` and other platform dirs are generated copies — edit `skills/`,
not the generated output.

## Workspace standards

- Always use graphify for codebase questions (`graphify query "<q>"` before
  raw browsing; `graphify path` / `graphify explain` for relationships and
  concepts); `graphify update .` after code changes. `graphify-out/` is
  regenerable and gitignored — never commit it.
- Long-form docs live in the Obsidian vault (`~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian Vault/<project-folder>/`); code keeps a one-line pointer.
