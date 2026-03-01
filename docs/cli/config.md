---
summary: "CLI reference for `anvika config` (get/set/unset config values)"
read_when:
  - You want to read or edit config non-interactively
title: "config"
---

# `anvika config`

Config helpers: get/set/unset values by path. Run without a subcommand to open
the configure wizard (same as `anvika configure`).

## Examples

```bash
anvika config get browser.executablePath
anvika config set browser.executablePath "/usr/bin/google-chrome"
anvika config set agents.defaults.heartbeat.every "2h"
anvika config set agents.list[0].tools.exec.node "node-id-or-name"
anvika config unset tools.web.search.apiKey
```

## Paths

Paths use dot or bracket notation:

```bash
anvika config get agents.defaults.workspace
anvika config get agents.list[0].id
```

Use the agent list index to target a specific agent:

```bash
anvika config get agents.list
anvika config set agents.list[1].tools.exec.node "node-id-or-name"
```

## Values

Values are parsed as JSON5 when possible; otherwise they are treated as strings.
Use `--strict-json` to require JSON5 parsing. `--json` remains supported as a legacy alias.

```bash
anvika config set agents.defaults.heartbeat.every "0m"
anvika config set gateway.port 19001 --strict-json
anvika config set channels.whatsapp.groups '["*"]' --strict-json
```

Restart the gateway after edits.
