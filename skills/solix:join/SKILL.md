---
name: solix:join
description: Add this chat to a Solix project — loads the project's context (working files, secret permits, provider) and records the membership in the shared memory graph.
argument-hint: "<project>"
---

# Solix Join

Add THIS chat to the Solix project named by the trailing argument. A
project is a container: a root path, the working files that serve one
purpose, a provider, and a secrets permit list — its helm items.

1. Run `solix project list`. Match the argument to a project (name or
   id prefix). If it doesn't exist, ask before creating it with
   `solix project new <name> --path <dir>` — cwd is the usual path.
2. Run `solix project show <name>` and adopt its context:
   - Its `path` and `file` entries are your working scope — the files
     that contribute to this project's purpose.
   - Its `secret` entries are permits only — env names you may use,
     never values to read or print.
   - Its `provider` is the project's preferred agent CLI.
3. Register the membership so any agent can see it:
   `solix memory add resource "chat:<provider> <cwd> → project:<name>"`
   If a `project:<name>` resource node already exists in
   `solix memory list`, link instead:
   `… --link relatesTo:<node-uuid>`
4. Tell the user the chat is attached and which scope/permits you picked
   up. Stay inside the project's scope unless the user widens it.

To mint a dedicated `/solix:<project>` command: copy this skill's
directory to `solix:<project>` under the Solix skill store, then put the
real name in `name:`/`description:` and bake it into the steps so no
argument is needed.
