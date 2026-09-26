---
name: solix:handoff
description: Leave a durable handoff note in Solix memory — what this chat did, what's next, and what's blocking — so the next agent or session can pick up without re-reading transcripts.
argument-hint: "[extra context]"
---

# Solix Handoff

Summarize this chat for whoever comes next, then persist it:

1. Write a one-or-two sentence summary: the goal, what was accomplished,
   what remains, and any blockers. Facts only — no transcript dumps, no
   internal reasoning.
2. Record it:
   `solix memory add handoff "<summary>"`
   The command prints the new node's uuid.
3. If this chat belongs to a group (check `solix memory list` for a
   `group:<name>` node), link them:
   `solix memory add handoff "<same summary>" --link relatesTo:<group-uuid>`
   or, if the group node already has a chat resource, link `continues:`
   to that chat's node instead.
4. Report the node id to the user so they can reference it later.
