---
summary: "CLI reference for `anvika daemon` (legacy alias for gateway service management)"
read_when:
  - You still use `anvika daemon ...` in scripts
  - You need service lifecycle commands (install/start/stop/restart/status)
title: "daemon"
---

# `anvika daemon`

Legacy alias for Gateway service management commands.

`anvika daemon ...` maps to the same service control surface as `anvika gateway ...` service commands.

## Usage

```bash
anvika daemon status
anvika daemon install
anvika daemon start
anvika daemon stop
anvika daemon restart
anvika daemon uninstall
```

## Subcommands

- `status`: show service install state and probe Gateway health
- `install`: install service (`launchd`/`systemd`/`schtasks`)
- `uninstall`: remove service
- `start`: start service
- `stop`: stop service
- `restart`: restart service

## Common options

- `status`: `--url`, `--token`, `--password`, `--timeout`, `--no-probe`, `--deep`, `--json`
- `install`: `--port`, `--runtime <node|bun>`, `--token`, `--force`, `--json`
- lifecycle (`uninstall|start|stop|restart`): `--json`

## Prefer

Use [`anvika gateway`](/cli/gateway) for current docs and examples.
