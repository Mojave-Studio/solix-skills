---
name: mcp
description: "Wire Solix as an MCP server (`solix mcp` stdio, `solix mcp --http --expose` for ChatGPT) so a chat can send work to First Mate, or tidy MCP servers across agent CLIs — find failed, redundant, and disabled servers, remove the dead ones, and reauthorize expired OAuth. Use when asked to expose Solix to ChatGPT/Claude/Grok, add a Solix MCP connector, clean up, dedupe, fix, or reauth MCPs, or when an agent reports an MCP 'Needs authentication' or 'Failed to connect'."
argument-hint: "[check | clean | reauth <name> | wire]"
---

# Solix MCP — expose Solix, then health / dedupe / reauth

## `solix mcp` — Solix as an MCP server

`solix mcp` is a stdio MCP server on the `solix` CLI. It speaks JSON-RPC 2.0
over stdin/stdout (newline-delimited; Content-Length framing is accepted)
and wraps the existing host control surface (`HostConnection` →
`HostRequestContext`). Logs belong on stderr — stdout is the protocol.

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

Tools (conservative First Mate surface): `mate_send`, `bot_list`, `bot_read`,
`bot_send`, `bot_new`, `terminal_list`, `terminal_read`, `wait`, `limits`,
`decide`, `project_list`, `value_get`. **Not** exposed: secrets, env values,
kill, value set. Operator requests in ChatGPT ("check sitting diffs on my
machines") go through `mate_send`.

Handshake methods: `initialize`, `notifications/initialized`, `tools/list`,
`tools/call`.

### ChatGPT — Streamable HTTP

ChatGPT cannot launch `solix mcp` as a subprocess. The public endpoint is a
Cloudflare Worker (`solix-mcp`) that proxies `/mcp` through a **private**
named tunnel (`solix-mcp`) to `127.0.0.1:8743`. Skypiea / UFO / opentoad are
untouched.

```text
solix mcp --http --expose
```

`--http` binds `127.0.0.1:8743`. `--expose` runs that named tunnel (falls
back to a quick tunnel if the Solix cloudflared config is missing). Keep
the process running.

Token: `SOLIX_MCP_TOKEN`, or `~/Library/Application Support/Solix/mcp-token`.
ChatGPT cannot send `Authorization` headers — the process prints a connector
URL with `?token=`. In ChatGPT pick **No authentication**.

Wire it:

1. Plugins → Add custom MCP server (or Settings → Apps & Connectors → Create).
2. Name: Solix. URL: the printed `https://solix-mcp.…workers.dev/mcp?token=…`.
   Auth: None.
3. New chat → `@` Solix → "check on the sitting diffs on my machines".

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
