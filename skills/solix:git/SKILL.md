---
name: solix:git
description: Drive the user's git repos through the solix CLI — status, diff, AI-drafted commits, branches, pull requests, push — including plain-speech requests like "commit this repo and write a message then push".
argument-hint: "[what to do, in plain speech — e.g. 'commit Solix MAC with an AI message and push', 'open a PR for this branch']"
---

# Solix Git

The host owns the repos; every operation is a `solix git` call. Plain-speech
requests map to the ops below — pick the repo with `--repo <path>` or
`--project <name>` (cwd is the default when you're inside one).

```text
solix git status|log|diff [--staged] [--file f]
solix git repos                                — every registered repo
solix git commit [message|--ai] [--push] [--file f]…
solix git fetch|push
solix git branch                               — list, * = current
solix git branch new <name> [--stay] [--from ref]
solix git checkout <name>
solix git branch rm <name>                     — safe -d, refuses unmerged
solix git pr                                   — open PRs
solix git pr new [--ai] [--title t] [--body b] [--base b] [--draft]
solix git draft [--kind commit|pr|branch] [--provider p] [--model m] [--base b]
solix git exec -- <any git args>               — the escape hatch
solix git init|clone|add
```

## Plain-speech mapping

- "commit <repo> for me and write a message" →
  `solix git commit --ai --repo <repo>`
- "…then push after" → add `--push`, or `solix git push` after.
- "make a branch for this work" →
  `solix git draft --kind branch` prints a suggested name, then
  `solix git branch new <name>`.
- "open a PR" → `solix git pr new --ai` (drafts title+body from the
  branch's commits vs its base, pushes `-u` first if unpublished).
- Anything the named ops don't cover → `solix git exec -- <args>` —
  `git stash`, `git rebase -i` (no — interactive; skip), `git tag`, etc.

## Drafting providers

`--ai` drafts run a provider CLI over the diff — the diff leaves the
machine for remote providers. Resolution order: `--provider`/`--model`
flags → the `git-draft-provider` / `git-draft-model` values → first
installed of claude/gemini/codex.

- `solix value set git-draft-provider ollama` +
  `solix value set git-draft-model llama3.2` → local drafts, free.
- `solix value set git-draft-provider codex` → Codex CLI.
- `--provider ollama --model qwen3` on a single call overrides the config.

## Rules of the register

- `commit --ai` with a clean tree fails honestly ("nothing to commit").
- `pr new` with no title uses `gh --fill`; `--ai` drafts from
  `base...HEAD` — it needs commits on the branch, not a dirty tree.
- `git exec` is write-gated and runs verbatim — quote args after `--`.
- Deleting the current branch or force-anything is the user's call —
  `git exec` is the door, but confirm first.
