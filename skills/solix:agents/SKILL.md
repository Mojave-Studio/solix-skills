---
name: solix:agents
description: "Audit and unify agent instruction files (AGENTS.md, CLAUDE.md, GEMINI.md, Windsurf rules, …) so every agent CLI on this machine reads the same rules. Use when asked to unify agent memory/instructions, check instruction drift, or when agents are behaving differently because they read different rule files."
argument-hint: "[audit | unify | unify for <dir>]"
---

# Solix Agents — instruction unify

Every agent CLI reads its own instruction file. Solix inventories them all
(user-global plus every project directory that has them) and repoints drift
at one canonical `AGENTS.md` per scope.

```text
solix agents audit                          inventory + drift report
solix agents unify [--scope dir|user]       fix plan — dry run, writes nothing
solix agents unify --apply [--scope …]      write it (originals backed up first)
```

Audit markers: `✓` canonical · `●` sole file · `~` divergent · `→` pointer
to canonical · `·` empty · `–` missing · `≠` exempt.

## Flow

1. `solix agents audit`. No `~` rows → say "unified" and stop.
2. For each divergent file, read it next to the canonical one and list what
   it holds that the canonical lacks. Unify replaces it with a pointer —
   anything unique in it is lost from that agent's view unless merged first.
3. Merge the unique, still-true rules into the canonical `AGENTS.md`
   yourself. Drop duplicates and stale rules; say which you dropped.
4. `solix agents unify` — show the user the plan (backup / write / point /
   link lines) plus your merge summary. Ask before applying.
5. On yes: `solix agents unify --apply`, then `solix agents audit` again and
   confirm zero divergent.

Never hand-edit pointer files or delete backups — `unify` owns both. Scope
the run with `--scope <dir>` when the user named one project.
