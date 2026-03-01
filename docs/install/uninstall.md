---
summary: "Uninstall Anvika completely (CLI, service, state, workspace)"
read_when:
  - You want to remove Anvika from a machine
  - The gateway service is still running after uninstall
title: "Uninstall"
---

# Uninstall

Two paths:

- **Easy path** if `anvika` is still installed.
- **Manual service removal** if the CLI is gone but the service is still running.

## Easy path (CLI still installed)

Recommended: use the built-in uninstaller:

```bash
anvika uninstall
```

Non-interactive (automation / npx):

```bash
anvika uninstall --all --yes --non-interactive
npx -y anvika uninstall --all --yes --non-interactive
```

Manual steps (same result):

1. Stop the gateway service:

```bash
anvika gateway stop
```

2. Uninstall the gateway service (launchd/systemd/schtasks):

```bash
anvika gateway uninstall
```

3. Delete state + config:

```bash
rm -rf "${ANVIKA_STATE_DIR:-$HOME/.anvika}"
```

If you set `ANVIKA_CONFIG_PATH` to a custom location outside the state dir, delete that file too.

4. Delete your workspace (optional, removes agent files):

```bash
rm -rf ~/.anvika/workspace
```

5. Remove the CLI install (pick the one you used):

```bash
npm rm -g anvika
pnpm remove -g anvika
bun remove -g anvika
```

6. If you installed the macOS app:

```bash
rm -rf /Applications/Anvika.app
```

Notes:

- If you used profiles (`--profile` / `ANVIKA_PROFILE`), repeat step 3 for each state dir (defaults are `~/.anvika-<profile>`).
- In remote mode, the state dir lives on the **gateway host**, so run steps 1-4 there too.

## Manual service removal (CLI not installed)

Use this if the gateway service keeps running but `anvika` is missing.

### macOS (launchd)

Default label is `ai.anvika.gateway` (or `ai.anvika.<profile>`; legacy `com.anvika.*` may still exist):

```bash
launchctl bootout gui/$UID/ai.anvika.gateway
rm -f ~/Library/LaunchAgents/ai.anvika.gateway.plist
```

If you used a profile, replace the label and plist name with `ai.anvika.<profile>`. Remove any legacy `com.anvika.*` plists if present.

### Linux (systemd user unit)

Default unit name is `anvika-gateway.service` (or `anvika-gateway-<profile>.service`):

```bash
systemctl --user disable --now anvika-gateway.service
rm -f ~/.config/systemd/user/anvika-gateway.service
systemctl --user daemon-reload
```

### Windows (Scheduled Task)

Default task name is `Anvika Gateway` (or `Anvika Gateway (<profile>)`).
The task script lives under your state dir.

```powershell
schtasks /Delete /F /TN "Anvika Gateway"
Remove-Item -Force "$env:USERPROFILE\.anvika\gateway.cmd"
```

If you used a profile, delete the matching task name and `~\.anvika-<profile>\gateway.cmd`.

## Normal install vs source checkout

### Normal install (install.sh / npm / pnpm / bun)

If you used `https://anvika.ai/install.sh` or `install.ps1`, the CLI was installed with `npm install -g anvika@latest`.
Remove it with `npm rm -g anvika` (or `pnpm remove -g` / `bun remove -g` if you installed that way).

### Source checkout (git clone)

If you run from a repo checkout (`git clone` + `anvika ...` / `bun run anvika ...`):

1. Uninstall the gateway service **before** deleting the repo (use the easy path above or manual service removal).
2. Delete the repo directory.
3. Remove state + workspace as shown above.
