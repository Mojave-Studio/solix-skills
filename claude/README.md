# Solix

[Solix](https://solix.fyi) puts your Mac's terminals, coding agents, and
controls on your iPhone. This plugin is the Claude side of that host: a
local MCP server plus skills that teach Claude to run the crew, join a
project, hand off work, and drive git and Helm through the `solix` CLI.

## Requirements

A running Solix host on this machine, with `solix` on your `PATH`
(typically `~/.local/bin/solix` after `solix install`). Downloads and
setup: [solix.fyi](https://solix.fyi).

## What you get

**MCP server (`solix mcp`)** — Claude Code starts it as a local stdio
process. Tools: `mate_send`, `bot_list`, `bot_read`, `bot_send`,
`bot_new`, `terminal_list`, `terminal_read`, `wait`, `limits`, `decide`,
`project_list`, `value_get`. Secrets, env values, kill, and value-set are
not exposed.

**Skills** — invoked as `/solix:<name>`, for example `/solix:first-mate`,
`/solix:join`, `/solix:assign`, `/solix:handoff`, `/solix:git`.

Ask Claude to list terminals, attach this chat to a project, or send work
to First Mate. On claude.ai chat, the local MCP server is ignored; the
skills still load and use the `solix` CLI when this machine can run it
(Claude Code and Cowork on your computer).

## Data

This plugin does not send data to Mojave Studio. Skills are Markdown
instructions. The MCP server talks only to the Solix host already running
on this computer over stdio. Secret values never appear in chat, MCP
tool output, or `solix read`; names are permits only. Optional HTTP
expose (`solix mcp --http --expose`) is something you start yourself and
is not part of this listing.

## License

MIT for this plugin's skills and manifests. The Solix host app and CLI
are proprietary; see [solix.fyi/license](https://solix.fyi/license).
