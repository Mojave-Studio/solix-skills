# Solix

[Solix](https://solix.fyi) puts your Mac's terminals, coding agents, and
controls on your iPhone. This plugin is the Claude side of that host: a
production MCP server on Cloudflare plus skills that teach Claude to run the
crew, join a project, hand off work, and drive git and Helm through the
`solix` CLI.

## Requirements

A Solix account and a running Solix host. Downloads and setup:
[solix.fyi](https://solix.fyi). On the machine keep `solix mcp --cloud`
running. The first run asks for the Solix email and password (same
Firebase account as the iPhone app); later runs reuse that session.

## What you get

**MCP server (`https://mcp.solix.fyi/mcp`)** — Streamable HTTP with OAuth.
Claude signs in with the Solix account, then tools reach the connected host
through Cloudflare. Tools: `mate_send`, `bot_list`, `bot_read`, `bot_send`,
`bot_new`, `terminal_list`, `terminal_read`, `terminal_new`, `wait`,
`limits`, `git_repos`, `git_status`, `git_diff`, `project_list`,
`value_get`. Secrets, env values, kill, value-set, decide, and machine
controls are not exposed.

**Skills** — invoked as `/solix:<name>`, for example `/solix:first-mate`,
`/solix:join`, `/solix:assign`, `/solix:handoff`, `/solix:git`.

Ask Claude to list terminals, attach this chat to a project, or send work
to First Mate. After adding the plugin, complete MCP login when Claude asks
to authorize Solix.

## Data

Skills are Markdown instructions. MCP traffic goes to Cloudflare
(`mcp.solix.fyi`), then to the Solix host you connected with
`solix mcp --cloud`. Secret values never appear in chat, MCP tool output,
or `solix read`; names are permits only. Do not publish this Mac on the
public internet.

## License

MIT for this plugin's skills and manifests. The Solix host app and CLI
are proprietary; see [solix.fyi/license](https://solix.fyi/license).
