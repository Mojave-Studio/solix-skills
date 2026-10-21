---
name: solix-mcp
description: "Wire Solix as an MCP server (`solix mcp` stdio, `solix mcp --cloud` to the production Cloudflare MCP) so a chat can send work to First Mate, or tidy MCP servers across agent CLIs — find failed, redundant, and disabled servers, remove the dead ones, and reauthorize expired OAuth. Use when asked to expose Solix to ChatGPT/Claude/Grok, add a Solix MCP connector, clean up, dedupe, fix, or reauth MCPs, or when an agent reports an MCP 'Needs authentication' or 'Failed to connect'."
argument-hint: "[check | clean | reauth <name> | wire]"
---

# Solix MCP — expose Solix, then health / dedupe / reauth

## `solix mcp` — Solix as an MCP server

`solix mcp` is a stdio MCP server on the `solix` CLI. It speaks JSON-RPC 2.0
over stdin/stdout (newline-delimited; Content-Length framing is accepted)
and wraps the host control surface. Logs belong on stderr — stdout is the protocol.

### What this increment covers

Local desktop clients that **launch a subprocess**:

| Client | How to wire |
|---|---|
| **Claude Desktop** | `~/Library/Application Support/Claude/claude_desktop_config.json` → `mcpServers.solix.command = "solix"`, `args = ["mcp"]` |
| **Claude Code** | `claude mcp add solix -- solix mcp` (user or project scope) |
| **Cursor** | `.cursor/mcp.json` or Cursor Settings → MCP: same `command` / `args` |
| **Grok Desktop** | MCP / plugin config with stdio command `solix` arg `mcp` (same shape as Claude) |
| **Codex** | `codex mcp add solix -- solix mcp` if the CLI supports stdio servers |

Example Claude Desktop snippet:

```json
{
  "mcpServers": {
    "solix": {
      "command": "solix",
      "args": ["mcp"]
    }
  }
}
```

`solix` must be on the client's `PATH` (typically `~/.local/bin/solix` after
`solix install`). Restart the desktop app after editing config.

Think in the chat. `mate_send` delivers a verified execute brief to First
Mate (★) — compact goal, paths, stopping condition; First Mate must not
re-plan. The local stdio server exposes 20 tools:

- Crew: `bot_list` `bot_read` `bot_send` `bot_new` `wait`
- Terminals: `terminal_list` `terminal_read` `terminal_new`
- Advice: `consult` (ask a consumer chat for planning/research — untrusted
  advice, never an execution result) and `consult_complete` (the trusted
  Grok-automation callback, not an operator-reply channel)
- Read-only state: `limits` `git_repos` `git_status` `git_diff`
  `project_list` `machines_list` (paired fleet machines) `providers_list`
  `value_get` `file_get` (Helm file pointers — paths only, never contents)

**Not** exposed on stdio: secrets, env, kill, value set, task_*,
decide, machine lock / sleep / restart / mute / volume / brightness /
keep-awake.

Handshake methods: `initialize`, `notifications/initialized`, `tools/list`,
`tools/call`.

### Production Cloudflare MCP

The public listing is Streamable HTTP at `https://mcp.solix.fyi/mcp` with
OAuth (Solix account). It is multi-tenant: Claude never talks to a personal
tunnel. The host owns an outbound WebSocket bridge — enable it once:

```text
solix mcp cloud on        # enable (the app keeps it connected)
solix mcp cloud signin    # one-time Solix account sign-in, if needed
solix mcp cloud status    # connected / connecting / off
solix mcp cloud off
solix mcp cloud signout   # forget the stored session
```

The cloud server carries a different surface than local stdio: the core
set (mate_send, bot_*, terminal_*, wait, limits, git_*, project_list,
value_get — no consult, machines_list, providers_list, or file_get), plus
the durable work queue and a grant-gated elevated group:

- Tasks & routing: `task_submit` `task_list` `task_get` `task_approve`
  `task_cancel` `route` (dry-run the provider pick)
- Elevated — each category is refused until the operator enables its grant
  at `https://mcp.solix.fyi/grants`:
  - `"secrets"`: `secret_list` `secret_set` `secret_delete` `secret_apply`
    (values cross the relay write-only, never read back)
  - `"kill"`: `terminal_kill` `bot_kill`
  - `"values"`: `value_set` `value_delete`
  - `"machine"`: `machine_control` (lock, sleep, restart, display, mute,
    volume, brightness, keep_awake)

### Local HTTP MCP

`solix mcp --http [host:port]` serves the same Streamable HTTP shape on
this machine for clients that can't spawn stdio. Bearer token comes from
`SOLIX_MCP_TOKEN` or `~/Library/Application Support/Solix/mcp-token`.
`--expose` bolts on a personal Cloudflare tunnel — a public URL straight
to this machine; prefer `mcp cloud on` (the multi-tenant bridge) unless
a personal tunnel is exactly what's needed.

The menu bar's "MCP" row and Settings → Messages → MCP Cloud do the same
thing without a terminal. `signin` opens the Solix page (Google/Apple)
once; the session persists in
`~/Library/Application Support/Solix/mcp-cloud-auth.json`.
`solix mcp --cloud [--url https://mcp.solix.fyi]` runs the same bridge in
the foreground for debugging — it dies with the terminal, and `--logout`
forgets the stored session. Plugin `.mcp.json` already points at
`https://mcp.solix.fyi/mcp`; complete OAuth when the client asks.

### ChatGPT

Add a custom MCP connector at `https://mcp.solix.fyi/mcp`. ChatGPT registers
as an OAuth client; you sign in with the same Solix account. The Mac must
already be connected (`solix mcp cloud on`, or the menu-bar MCP row).

`solix mcp --check` exercises initialize + tools/list without the host.

Do not print env values or headers from other MCP configs; they hold secrets.

# Health, dedupe, reauth

Each CLI keeps its own MCP config; inspect every one that's installed.

```text
claude mcp list               health-checks each server (slow — up to a minute)
claude mcp get <name>         scope + config file it lives in
claude mcp remove <name> [-s user|project|local]
claude mcp login <name>       OAuth (re)auth for HTTP/SSE servers
codex mcp list                table: Status (enabled/disabled), Auth
codex mcp remove|login|logout <name>
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

- Same command + args or same URL under two names — keep the one agents'
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
