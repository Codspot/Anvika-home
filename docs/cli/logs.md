---
summary: "CLI reference for `anvika logs` (tail gateway logs via RPC)"
read_when:
  - You need to tail Gateway logs remotely (without SSH)
  - You want JSON log lines for tooling
title: "logs"
---

# `anvika logs`

Tail Gateway file logs over RPC (works in remote mode).

Related:

- Logging overview: [Logging](/logging)

## Examples

```bash
anvika logs
anvika logs --follow
anvika logs --json
anvika logs --limit 500
anvika logs --local-time
anvika logs --follow --local-time
```

Use `--local-time` to render timestamps in your local timezone.
