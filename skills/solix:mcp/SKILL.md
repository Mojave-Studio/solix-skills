---
name: solix:mcp
description: "Tidy MCP servers across every agent CLI on this machine — find failed, redundant, and disabled servers, remove the dead ones, and reauthorize expired OAuth. Use when asked to clean up, dedupe, fix, or reauth MCPs, or when an agent reports an MCP 'Needs authentication' or 'Failed to connect'."
argument-hint: "[check | clean | reauth <name>]"
---

# Solix MCP — health, dedupe, reauth

Each CLI keeps its own MCP config; inspect every one that's installed.

```text
claude mcp list               health-checks each server (slow — up to a minute)
claude mcp get <name>         scope + config file it lives in
claude mcp remove <name> [-s user|project|local]
claude mcp login <name>       OAuth (re)auth for HTTP/SSE servers
codex mcp list                table: Status (enabled/disabled), Auth
codex mcp remove|login|logout <name>
gemini mcp list | remove|enable|disable <name>
```

## Triage — `claude mcp list` status → action

| Status | Meaning | Action |
|---|---|---|
| `✔ Connected` | healthy | keep, unless redundant (below) |
| `! Needs authentication` | token missing/expired | `claude mcp login <name>` |
| `✘ Failed to connect — ENOENT …` | its binary isn't installed | remove, or install the binary if the user still wants it |
| `✘ Failed to connect` (other) | server down / bad URL | `claude mcp get <name>`; remove if the URL/package is gone |
| `⏸ Pending approval` | project `.mcp.json` never approved | ask; redundant → remove, wanted → approve in `claude` |

Codex: `Auth` = `Not logged in`/expired → `codex mcp login <name>`.
`disabled` rows are dead weight — remove unless the user disabled it on
purpose recently.

## Redundant

- Same command + args or same URL under two names (e.g. `claude-flow` and
  `ruflo` both `npx -y ruflo@latest mcp start`) — keep the one agents'
  instructions reference, remove the other.
- A manual server that duplicates a plugin-provided (`plugin:<p>:<name>`)
  or `claude.ai <Connector>` one — remove the manual copy; those two kinds
  are managed by their plugin / claude.ai, not `mcp remove`.
- Overlapping tools (two servers exposing the same service) — name the
  overlap and let the user pick; don't guess.

## Flow

1. Run every installed CLI's list. Build one table: name, CLI, scope,
   status, verdict (keep / reauth / remove / ask) with a one-line reason.
2. Show it. Reauth needs nothing destructive — offer to run it right away.
   `login` opens a browser; tell the user to finish there.
3. Removals only after the user says yes, per server. Pass the scope from
   `claude mcp get` so the right config file changes.
4. Re-run the lists and report what changed. Running agent sessions pick
   up MCP changes only after a restart — say so.

Never print env values or headers from configs; they hold secrets.
