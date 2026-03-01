# Anvika Fork — Complete Repository Analysis

> Generated: 2026-03-01
> Base: anvika/anvika (forked)
> Purpose: Foundation for building a custom AI gateway product on top of Anvika

---

## Table of Contents

1. [What Is Anvika?](#1-what-is-anvika)
2. [Top-Level Directory Map](#2-top-level-directory-map)
3. [Package & Dependency Overview](#3-package--dependency-overview)
4. [Source Code Architecture (`src/`)](#4-source-code-architecture-src)
5. [Extensions / Plugin System](#5-extensions--plugin-system)
6. [Mobile & Desktop Apps (`apps/`)](#6-mobile--desktop-apps-apps)
7. [Skills Directory](#7-skills-directory)
8. [Web UI (`ui/`)](#8-web-ui-ui)
9. [Messaging Channels Supported](#9-messaging-channels-supported)
10. [Configuration System](#10-configuration-system)
11. [Agent Runtime & AI Providers](#11-agent-runtime--ai-providers)
12. [Plugin SDK — How to Write Plugins](#12-plugin-sdk--how-to-write-plugins)
13. [Build, Test & CI Pipeline](#13-build-test--ci-pipeline)
14. [Key Architectural Decisions](#14-key-architectural-decisions)
15. [Where to Add Your Own Code](#15-where-to-add-your-own-code)
16. [Glossary](#16-glossary)

---

## 1. What Is Anvika?

Anvika is a **self-hosted personal AI assistant gateway**. It bridges your AI models (Claude, GPT, Gemini, Ollama, etc.) to your everyday messaging apps (WhatsApp, Telegram, Slack, Discord, iMessage, and 35+ more). You run the gateway on your own machine or server; it handles message routing, session management, tool execution, memory, and multi-agent orchestration.

**Key value propositions:**
- Privacy-first: your messages never leave your own devices
- Multi-channel: one AI brain responds across all your messaging apps
- Extensible: 54+ bundled skills, 41 channel plugins, open plugin SDK
- Multi-platform: CLI, macOS menu bar app, iOS app, Android app, Web UI

**Current version:** 2026.2.27
**Language:** TypeScript (ESM, strict mode), Swift (iOS/macOS), Kotlin (Android)
**Runtime:** Node.js ≥ 22.12.0 / Bun compatible
**Package manager:** pnpm 10.23.0

---

## 2. Top-Level Directory Map

```
Anvika-home/                       ← repo root
│
├── src/                           ← ALL core TypeScript source (~491 K LOC)
│   ├── agents/                    ← agent runtime, ACP, auth profiles
│   ├── channels/                  ← channel dock, routing, allowlists
│   ├── cli/                       ← Commander.js CLI wiring
│   ├── commands/                  ← individual CLI command implementations
│   ├── config/                    ← YAML config loading + Zod schemas
│   ├── gateway/                   ← WebSocket gateway server + client
│   ├── infra/                     ← device pairing, ports, env, sandboxing
│   ├── media/                     ← image/audio/video pipeline
│   ├── memory/                    ← memory storage backends
│   ├── plugins/                   ← plugin loader, hooks, manifest, install
│   ├── routing/                   ← message routing logic
│   ├── sessions/                  ← chat session lifecycle
│   ├── telegram/ slack/ discord/  ← built-in channel modules
│   ├── signal/ imessage/ line/    ← built-in channel modules (cont.)
│   └── shared/ utils.ts ...       ← shared utilities
│
├── extensions/                    ← 41 channel/system plugins (workspace pkgs)
│   ├── bluebubbles/               ← iMessage via BlueBubbles server
│   ├── feishu/                    ← Feishu / Lark (most extensive)
│   ├── msteams/                   ← Microsoft Teams
│   ├── matrix/                    ← Matrix / Element
│   ├── zalo/ zalouser/            ← Zalo (VN)
│   ├── voice-call/                ← Voice call system
│   ├── memory-lancedb/            ← LanceDB vector memory backend
│   └── ... 34 more
│
├── apps/                          ← native companion apps
│   ├── macos/                     ← SwiftUI menu bar app
│   ├── ios/                       ← SwiftUI iPhone app
│   ├── android/                   ← Kotlin/Gradle Android app
│   └── shared/                    ← Shared Swift kit (AnvikaKit)
│
├── skills/                        ← 54+ bundled skill plugins
│   ├── cron/                      ← scheduled tasks
│   ├── memory-core/               ← in-memory/SQLite memory
│   ├── github/                    ← GitHub integration
│   ├── notion/ obsidian/          ← note-taking integrations
│   └── ... 49 more
│
├── ui/                            ← Web Control UI (React/TypeScript/Lit)
│
├── packages/                      ← workspace packages
│   ├── clawdbot/                  ← clawdbot configuration package
│   └── moltbot/                   ← moltbot configuration package
│
├── docs/                          ← Mintlify documentation source
│   ├── zh-CN/                     ← auto-generated Chinese translation
│   └── .i18n/                     ← translation glossary & memory
│
├── scripts/                       ← build, release, packaging scripts
├── .github/                       ← CI workflows, issue templates, labeler
├── .agents/                       ← agent tools & skills config
├── git-hooks/                     ← pre-commit hook (prek)
│
├── package.json                   ← root package, 175+ npm scripts
├── pnpm-workspace.yaml            ← monorepo workspaces declaration
├── tsconfig.json                  ← TypeScript strict ESM config
├── vitest.unit.config.ts          ← unit test config
├── vitest.gateway.config.ts       ← gateway test config
├── vitest.e2e.config.ts           ← e2e test config
├── Dockerfile                     ← container build
├── docker-compose.yml             ← dev environment
├── CHANGELOG.md                   ← user-facing release notes
├── AGENTS.md / CLAUDE.md          ← agent guidelines (CLAUDE.md → AGENTS.md symlink)
└── SECURITY.md                    ← security model & disclosure policy
```

---

## 3. Package & Dependency Overview

### 3.1 Core Runtime Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `@mariozechner/pi-*` | 0.55.1 | Pi agent runtime (AI task execution, tool streaming) |
| `grammy` | 1.40.1 | Telegram bot framework |
| `@slack/bolt` | 4.6.0 | Slack event API |
| `discord-api-types` | 0.38.40 | Discord REST/Gateway types |
| `@whiskeysockets/baileys` | 7.0.0-rc.9 | WhatsApp Web protocol |
| `@sinclair/typebox` | 0.34.48 | Runtime TypeScript schema validation |
| `zod` | 4.3.6 | Config/input validation |
| `sharp` | 0.34.5 | Image processing |
| `sqlite-vec` | 0.1.7-alpha.2 | SQLite vector embeddings (memory) |
| `playwright-core` | 1.58.2 | Browser automation |
| `pdfjs-dist` | 5.4.624 | PDF text extraction |
| `commander` | — | CLI argument parsing |
| `tslog` | — | Structured logging |
| `jiti` | — | Runtime ESM/CJS module bridging for plugins |

### 3.2 Dev Tools

| Tool | Purpose |
|------|---------|
| TypeScript 5.9.3 | Strict typing, ESM modules |
| Vitest 4.0.18 | Unit / integration / e2e testing |
| Oxlint 1.50.0 | Fast linting |
| Oxfmt 0.35.0 | Code formatting |
| tsdown 0.20.3 | TypeScript bundler (builds `dist/`) |
| tsx 4.21.0 | TypeScript execution for scripts |
| Bun | Fast TypeScript runner for tests/scripts |

### 3.3 Key Exports from `package.json`

```json
{
  "main": "dist/index.js",
  "exports": {
    ".": "dist/index.js",
    "./plugin-sdk": "dist/plugin-sdk.js",
    "./plugin-sdk/account-id": "dist/plugin-sdk.account-id.js",
    "./cli-entry": "dist/cli-entry.js"
  }
}
```

The `./plugin-sdk` export is the public API for third-party plugins. Everything else is internal.

---

## 4. Source Code Architecture (`src/`)

### 4.1 High-Level Data Flow

```
User Message (WhatsApp/Telegram/Discord/...)
        │
        ▼
   Channel Module  (src/telegram/, src/slack/, extensions/feishu/, ...)
        │  receives raw message event
        ▼
   Channel Dock   (src/channels/dock.ts)
        │  routing, allowlists, command gating
        ▼
   Session Manager  (src/sessions/)
        │  per-conversation state
        ▼
   Agent Runtime  (src/agents/agent.ts)
        │  calls Pi framework → AI model
        │  executes tools/skills
        ▼
   Response  →  back through Channel Module  →  User
```

### 4.2 Agents (`src/agents/`)

The brain of the system. Key files:

| File | Purpose |
|------|---------|
| `agent.ts` | Core agent: runs a Pi agent instance, manages tool calls, streaming |
| `acp-spawn.ts` | ACP (Agent Control Protocol) — spawns sub-agents |
| `agent-scope.ts` | Workspace isolation per agent |
| `auth-*.ts` | Multi-auth profile management (credential rotation) |
| `cooldown-expiry.ts` | Rate limiting / cooldown enforcement |

**How agents work:**
1. A message arrives and is routed to a session
2. The session creates or resumes an agent
3. The agent uses the Pi framework to call the configured AI model
4. Tools (skills) are executed based on model output
5. Streaming responses go back to the originating channel

### 4.3 Channels (`src/channels/`)

| File | Purpose |
|------|---------|
| `dock.ts` | Registry: registers all channels, routes messages |
| `allow-from.ts` | Allowlist policy enforcement |
| `command-gating.ts` | Role-based slash command access |
| `status-reactions.ts` | Message acknowledgment (emoji reactions) |
| `plugins/` | Channel plugin lifecycle hooks |

The dock is the central bus. Every message enters and exits through it.

### 4.4 Gateway (`src/gateway/`)

The HTTP/WebSocket server that companion apps (iOS, Android, macOS) connect to.

| File | Purpose |
|------|---------|
| `client.ts` | WebSocket client connection management |
| `auth.ts` | Device authentication & Bonjour pairing |
| `control-ui.ts` | HTTP control plane API (used by Web UI) |
| `call.ts` | Voice/call session management |
| `config-reload.ts` | Hot-reload configuration without restart |

### 4.5 Config (`src/config/`)

| File | Purpose |
|------|---------|
| `config.ts` | Main config loader — reads YAML, validates with Zod |
| `sessions.ts` | Session storage and routing config |
| `models.ts` | AI model provider configuration (OpenAI, Anthropic, Ollama, etc.) |

**Config format:** YAML (`~/.anvika/config.yaml`)
**Validation:** Zod schemas at runtime — malformed config throws immediately.

### 4.6 CLI (`src/cli/`)

| File | Purpose |
|------|---------|
| `program.ts` | Commander.js root program setup |
| `deps.ts` | Dependency injection factory (`createDefaultDeps`) |
| `profile.ts` | dev / staging / prod profile support |
| `completion-*.ts` | Shell tab-completion (fish, bash, zsh) |
| `respawn-policy.ts` | Process auto-restart logic |

### 4.7 Commands (`src/commands/`)

Each file = one CLI command group:

| File | CLI Command |
|------|-------------|
| `agent.ts` | `anvika agent ...` |
| `agents.ts` | `anvika agents ...` |
| `channels-cli.ts` | `anvika channels ...` |
| `config-cli.ts` | `anvika config ...` |
| `pairing.ts` | `anvika pair ...` |
| `sessions.ts` | `anvika sessions ...` |
| `browser-cli-*.ts` | `anvika browser ...` |

### 4.8 Plugins (`src/plugins/`)

| File | Purpose |
|------|---------|
| `loader.ts` | Plugin discovery & dynamic loading |
| `install.ts` | NPM-based plugin installation |
| `manifest.ts` | Plugin metadata parsing |
| `hooks.ts` | Lifecycle hooks (before-agent-start, after-message, etc.) |
| `discovery.ts` | Find plugins in node_modules |

### 4.9 Infrastructure (`src/infra/`)

| File | Purpose |
|------|---------|
| `device-pairing.ts` | Bonjour (mDNS) device discovery & secure pairing |
| `boundary-path.ts` | Filesystem sandbox enforcement |
| `device-identity.ts` | Persistent device ID tracking |
| `ports.ts` | Port availability checks |
| `runtime-guard.ts` | Node.js version enforcement |
| `env.ts` | Environment variable loading |

### 4.10 Media Pipeline (`src/media/`)

Handles image, audio, and video processing before sending to AI:
- Image resizing/conversion (via `sharp`)
- Audio transcription pipeline
- Video frame extraction
- PDF text extraction (via `pdfjs-dist`)
- Vision model integration (`src/media-understanding/`)

---

## 5. Extensions / Plugin System

### 5.1 Structure

Each extension is a self-contained pnpm workspace package:

```
extensions/feishu/
├── package.json          ← own dependencies, name: @anvika/feishu
├── src/
│   ├── channel.ts        ← implements ChannelPlugin interface
│   ├── index.ts          ← exports plugin entry point
│   └── *.test.ts         ← colocated tests
└── README.md
```

### 5.2 All 41 Extensions

**Messaging Channel Extensions:**

| Extension | Channel |
|-----------|---------|
| `bluebubbles` | iMessage (via BlueBubbles server) — recommended |
| `discord` | Discord |
| `feishu` | Feishu / Lark (most feature-complete) |
| `googlechat` | Google Chat |
| `imessage` | Native iMessage (macOS only) |
| `irc` | IRC protocol |
| `line` | LINE Messenger |
| `matrix` | Matrix / Element |
| `mattermost` | Mattermost |
| `msteams` | Microsoft Teams |
| `nextcloud-talk` | Nextcloud Talk |
| `nostr` | Nostr (decentralized) |
| `signal` | Signal Messenger |
| `slack` | Slack (extension layer) |
| `synology-chat` | Synology Chat |
| `telegram` | Telegram (extension layer) |
| `tlon` | Urbit Tlon |
| `twitch` | Twitch streaming chat |
| `whatsapp` | WhatsApp |
| `zalo` | Zalo (Vietnam) |
| `zalouser` | Zalo Personal |

**System / Integration Extensions:**

| Extension | Purpose |
|-----------|---------|
| `acpx` | Agent Control Protocol extensions |
| `copilot-proxy` | GitHub Copilot proxy |
| `device-pair` | Enhanced device pairing |
| `diagnostics-otel` | OpenTelemetry tracing & metrics |
| `google-gemini-cli-auth` | Gemini CLI OAuth integration |
| `llm-task` | LLM task runner (headless agent tasks) |
| `lobster` | CLI color palette & UI theming |
| `memory-core` | Core memory abstraction |
| `memory-lancedb` | LanceDB vector DB memory backend |
| `minimax-portal-auth` | MiniMax AI auth |
| `open-prose` | Prose/document editor |
| `phone-control` | Phone device control |
| `qwen-portal-auth` | Qwen AI model auth |
| `shared` | Shared extension utilities |
| `talk-voice` | Voice communication |
| `thread-ownership` | Thread/conversation ownership |
| `voice-call` | Full voice call system |

### 5.3 Writing a Custom Extension

A minimal channel plugin:

```typescript
// extensions/mychannel/src/index.ts
import type { ChannelPlugin } from 'anvika/plugin-sdk';

export default {
  name: 'mychannel',
  version: '1.0.0',

  async setup(ctx) {
    // Register event listeners, set up webhook, etc.
    ctx.onMessage(async (msg) => {
      // msg.text, msg.from, msg.channelId
      await ctx.sendReply(msg, 'Hello from MyChannel!');
    });
  },

  async teardown() {
    // cleanup
  },
} satisfies ChannelPlugin;
```

**Plugin rules:**
- Runtime dependencies in `dependencies` (not `devDependencies`)
- Do NOT use `workspace:*` in `dependencies`
- Put `anvika` in `peerDependencies` or `devDependencies`
- Plugin is loaded via `jiti` — supports ESM and CJS

---

## 6. Mobile & Desktop Apps (`apps/`)

### 6.1 macOS App (`apps/macos/`)

- **Framework:** SwiftUI + AppKit (menu bar app)
- **Key features:**
  - Menu bar presence (systray)
  - Voice Wake word detection
  - Talk Mode overlay window
  - Live Canvas renderer (agent-controlled UI)
  - Local gateway start/stop control
  - Sparkle auto-update framework
- **Build:** XcodeGen → `.xcodeproj` → Xcode build
- **State management:** `@Observable` / `@Bindable` (Observation framework)

### 6.2 iOS App (`apps/ios/`)

- **Framework:** SwiftUI
- **Key features:**
  - Bonjour pairing with gateway
  - Canvas (agent-controlled UI panes)
  - Voice Wake integration
  - Camera + screen recording
  - Native iOS notifications
- **Shared code:** `apps/shared/` (AnvikaKit)

### 6.3 Android App (`apps/android/`)

- **Framework:** Kotlin, Jetpack Compose, Gradle
- **Key features:**
  - Canvas support
  - Talk Mode (voice input/output)
  - Camera + screen recording
  - Optional SMS support
  - Notification action handling
- **Build:** Gradle (`./gradlew assembleDebug`)

### 6.4 Shared Kit (`apps/shared/`)

Shared Swift code used by both iOS and macOS:
- Gateway protocol definitions
- Common UI components
- Pairing flow logic
- Uses `Observation` framework only (no `ObservableObject`)

---

## 7. Skills Directory

Skills are installable agent capabilities — tools the AI can use.

### 7.1 Structure

```
skills/cron/
├── package.json     ← name: @anvika/skill-cron
├── src/
│   └── index.ts     ← exports skill tools
└── README.md
```

### 7.2 All 54 Bundled Skills (Categories)

**Automation & Scheduling:**
- `cron` — scheduled tasks
- `webhook` — receive/send webhooks
- `health-check` — uptime monitoring

**AI & Memory:**
- `memory-core` — in-memory + SQLite memory
- `memory-lancedb` — vector search memory
- `model-usage` — track token usage

**Communication:**
- `discord-bot` — Discord interactions
- `slack-bot` — Slack interactions
- `twilio` — SMS via Twilio
- `himalaya` — email (IMAP/SMTP)

**Productivity:**
- `notion` — Notion pages/databases
- `obsidian` — Obsidian vault
- `github` — GitHub issues/PRs/code
- `trello` — Trello cards
- `apple-notes` — Apple Notes
- `bear-notes` — Bear notes app
- `things` — Things 3 task manager

**Media:**
- `image-gen` — AI image generation
- `video-frames` — video frame extraction
- `canvas` — live canvas UI

**Voice:**
- `voice-call` — voice call handling
- `talk-voice` — talk mode
- `sherpa-onnx-tts` — local TTS engine

**System:**
- `macos-notifications` — macOS notification center
- `tmux` — tmux session control
- `terminal` — terminal execution

**Web & Data:**
- `blog-watcher` — RSS/web page monitoring
- `link-understanding` — URL content extraction
- `maps` — Apple/Google Maps
- `weather` — weather data

**Music:**
- `spotify` — Spotify playback control
- `sonos` — Sonos speaker control
- `song-recognition` — Shazam-like recognition

---

## 8. Web UI (`ui/`)

- Built with React, TypeScript, and Lit (web components)
- Served directly from the gateway HTTP server
- Provides a web-based control panel for managing:
  - Channel status and configuration
  - Agent settings
  - Session history
  - Plugin management
- **Build:** `npm run ui:build` (separate from main build)
- **Dev:** `pnpm ui:dev` (hot reload)

---

## 9. Messaging Channels Supported

### Complete Channel Matrix

| Channel | Type | Location |
|---------|------|----------|
| Telegram | Messaging | `src/telegram/` |
| WhatsApp | Messaging | `src/web/` + `extensions/whatsapp/` |
| Slack | Messaging | `src/slack/` |
| Discord | Messaging | `src/discord/` |
| Signal | Messaging | `src/signal/` + `extensions/signal/` |
| iMessage (native) | Messaging | `src/imessage/` + `extensions/imessage/` |
| iMessage (BlueBubbles) | Messaging | `extensions/bluebubbles/` |
| Google Chat | Messaging | `src/` + core modules |
| LINE | Messaging | `src/line/` |
| Feishu / Lark | Messaging | `extensions/feishu/` |
| Microsoft Teams | Messaging | `extensions/msteams/` |
| Matrix / Element | Messaging | `extensions/matrix/` |
| Mattermost | Messaging | `extensions/mattermost/` |
| Zalo | Messaging | `extensions/zalo/` |
| Zalo Personal | Messaging | `extensions/zalouser/` |
| IRC | Messaging | `extensions/irc/` |
| Nostr | Messaging | `extensions/nostr/` |
| Nextcloud Talk | Messaging | `extensions/nextcloud-talk/` |
| Synology Chat | Messaging | `extensions/synology-chat/` |
| Twitch | Streaming | `extensions/twitch/` |
| Tlon (Urbit) | Messaging | `extensions/tlon/` |
| Google Chat | Messaging | `extensions/googlechat/` |
| Web Chat | Web | `src/provider-web.ts` |

### Security Model Per Channel

- **DM pairing required** by default before a channel accepts commands
- **Allowlist enforcement:** `allow-from` policy per channel
- **Topic isolation:** groups/threads can be isolated
- **Role-based command gating:** some commands need elevated roles

---

## 10. Configuration System

### 10.1 Config File Location

```
~/.anvika/config.yaml         ← main config
~/.anvika/credentials/        ← channel credentials
~/.anvika/sessions/           ← session state
~/.anvika/agents/<id>/        ← per-agent data
~/.anvika/agents/<id>/sessions/*.jsonl  ← session logs
```

### 10.2 Config Structure (simplified)

```yaml
gateway:
  mode: local           # local | remote
  bind: loopback        # loopback | lan
  port: 18789

models:
  default: claude-3-5-sonnet
  providers:
    - type: anthropic
      apiKey: ${ANTHROPIC_API_KEY}
    - type: openai
      apiKey: ${OPENAI_API_KEY}
    - type: ollama
      baseUrl: http://localhost:11434

agents:
  - name: main
    model: claude-3-5-sonnet
    skills:
      - memory-core
      - github
    channels:
      - telegram
      - slack

channels:
  telegram:
    token: ${TELEGRAM_BOT_TOKEN}
    allowFrom:
      - userId: "12345678"
  slack:
    appToken: ${SLACK_APP_TOKEN}
    botToken: ${SLACK_BOT_TOKEN}
```

### 10.3 Model Providers Supported

| Provider | Type |
|----------|------|
| Anthropic (Claude) | Cloud |
| OpenAI (GPT-4, o3, etc.) | Cloud |
| Google Gemini | Cloud |
| Ollama | Local |
| MiniMax | Cloud |
| Qwen | Cloud |
| GitHub Copilot | Cloud (proxy) |
| Any OpenAI-compatible | Cloud/Local |

---

## 11. Agent Runtime & AI Providers

### 11.1 Pi Framework

Anvika uses `@mariozechner/pi-*` (called "Pi") as the agent execution layer. Pi:
- Handles tool calling / function execution
- Manages conversation history
- Supports streaming responses
- Provides multi-model abstraction

### 11.2 Agent Lifecycle

```
1. Message arrives → session identified
2. Session looks up bound agent config
3. Agent instance started (or resumed from cooldown)
4. Pi runtime called with model + tools
5. Model streams response + tool calls
6. Tools executed (skills, browser, memory, etc.)
7. Final response assembled
8. Response sent back through channel
```

### 11.3 Multi-Agent Features

- **Auth profile rotation:** multiple API keys rotated round-robin
- **Cooldown expiry:** agents back off on errors
- **ACP (Agent Control Protocol):** spawn sub-agents from a parent agent
- **Agent scopes:** isolated workspaces per agent
- **Binding:** one agent can be bound to multiple channels

---

## 12. Plugin SDK — How to Write Plugins

### 12.1 SDK Import

```typescript
import { ... } from 'anvika/plugin-sdk';
```

The plugin SDK is the **only** stable public API. Internal `src/` imports are not supported for external use.

### 12.2 Plugin Types

**Channel Plugin** — adds a new messaging channel
**Skill Plugin** — adds tools/capabilities to agents
**Hook Plugin** — lifecycle hooks (before-message, after-agent-start, etc.)
**Memory Plugin** — custom memory backend

### 12.3 Skill Plugin Example

```typescript
// skills/my-skill/src/index.ts
import type { Skill } from 'anvika/plugin-sdk';

export default {
  name: 'my-skill',
  tools: [
    {
      name: 'fetch_data',
      description: 'Fetches data from my service',
      parameters: {
        type: 'object',
        properties: {
          query: { type: 'string', description: 'Search query' },
        },
        required: ['query'],
      },
      async execute({ query }) {
        // do work
        return { result: `Data for: ${query}` };
      },
    },
  ],
} satisfies Skill;
```

### 12.4 Plugin Installation

```bash
anvika plugins install @mycorp/my-skill
# or from local path:
anvika plugins install ./my-skill
```

### 12.5 Plugin package.json Requirements

```json
{
  "name": "@mycorp/my-skill",
  "version": "1.0.0",
  "main": "dist/index.js",
  "dependencies": {
    "some-runtime-dep": "^1.0.0"
  },
  "peerDependencies": {
    "anvika": "*"
  }
}
```

- Runtime deps → `dependencies`
- `anvika` → `peerDependencies` or `devDependencies`
- **Never** `workspace:*` in `dependencies`

---

## 13. Build, Test & CI Pipeline

### 13.1 Development Commands

```bash
# Install dependencies
pnpm install

# Run CLI in dev mode
pnpm anvika ...
pnpm dev

# Type check
pnpm tsgo

# Build (compile to dist/)
pnpm build

# Lint + format check
pnpm check

# Format fix
pnpm format:fix
```

### 13.2 Testing

```bash
# All unit tests
pnpm test

# With coverage report
pnpm test:coverage

# E2E (Docker)
pnpm test:e2e

# Live tests (real API keys)
CLAWDBOT_LIVE_TEST=1 pnpm test:live

# Low-memory environments
ANVIKA_TEST_PROFILE=low ANVIKA_TEST_SERIAL_GATEWAY=1 pnpm test
```

**Coverage thresholds:** 70% lines, branches, functions, statements

### 13.3 Multiple Vitest Configs

| Config | Tests |
|--------|-------|
| `vitest.unit.config.ts` | Source unit tests |
| `vitest.gateway.config.ts` | Gateway-specific tests |
| `vitest.e2e.config.ts` | End-to-end tests |
| `vitest.live.config.ts` | Live API tests |
| `vitest.extensions.config.ts` | Extension tests |

### 13.4 Build Pipeline Detail

```bash
pnpm build
# Step 1: Bundle Canvas A2UI (scripts/bundle-a2ui.sh)
# Step 2: tsdown compile src/ → dist/
# Step 3: Generate plugin-sdk type definitions
# Step 4: Copy exports, metadata, templates
# Step 5: Generate build-info.json
# Step 6: Set up CLI compatibility shims
```

### 13.5 Pre-Commit Hooks

`git-hooks/pre-commit` runs:
- `pnpm format:check` — formatting
- `pnpm tsgo` — TypeScript check
- `pnpm lint` — Oxlint
- Custom guardrails:
  - `lint:tmp:no-random-messaging` — no hardcoded channel calls
  - `lint:auth:no-pairing-store-group` — pairing auth integrity
  - `lint:auth:pairing-account-scope` — account-scoped pairing

Install hooks: `prek install`

---

## 14. Key Architectural Decisions

### 14.1 Monorepo with pnpm Workspaces

All packages (extensions, apps, skills) live in one repo. pnpm handles dependency deduplication. Bun is used for fast test/script execution.

### 14.2 Plugin Loading via Jiti

Plugins are loaded at runtime using `jiti`, which handles ESM/CJS bridging transparently. This allows plugins written in any modern JS/TS style.

### 14.3 Channel Dock Pattern

All channels register with the `dock` (a central bus). This means:
- Adding a new channel = implement the plugin interface + register with dock
- Message routing logic is centralized in one place
- Allowlists, command gating, reactions all apply uniformly

### 14.4 Zod + TypeBox for Validation

- **Zod** — config file validation (user-facing errors)
- **TypeBox** — tool schema validation (agent tool definitions)
- No `any` types allowed; strict TypeScript enforced

### 14.5 Pi Framework for AI

Anvika doesn't call AI APIs directly — it delegates to the Pi agent runtime. Pi handles:
- Streaming tool calls
- History management
- Multi-provider abstraction
- Retry / error recovery

### 14.6 Separate Compilation for Plugin SDK

The plugin SDK (`dist/plugin-sdk.js`) is compiled separately so external plugins get stable types without depending on internal build artifacts.

### 14.7 Observation Framework (Swift)

iOS/macOS apps use `@Observable` / `@Bindable` — NOT `ObservableObject`. New Swift app code must follow this pattern.

---

## 15. Where to Add Your Own Code

This section is specifically for building your custom product on top of this fork.

### 15.1 Add a New Messaging Channel

1. Create `extensions/mychannel/` with its own `package.json`
2. Implement `ChannelPlugin` from `anvika/plugin-sdk`
3. Register in `pnpm-workspace.yaml`
4. Add label in `.github/labeler.yml`

**Files to study first:**
- [extensions/bluebubbles/src/channel.ts](extensions/bluebubbles/src/channel.ts) — simplest modern channel
- [src/channels/dock.ts](src/channels/dock.ts) — channel registration
- [src/channels/allow-from.ts](src/channels/allow-from.ts) — allowlist model

### 15.2 Add a New AI Skill / Tool

1. Create `skills/my-skill/` with `package.json`
2. Implement `Skill` from `anvika/plugin-sdk`
3. Export tools array with TypeBox/JSON Schema parameters

**Files to study first:**
- [skills/cron/](skills/cron/) — scheduled task skill (good reference)
- [skills/github/](skills/github/) — external API integration

### 15.3 Add a New CLI Command

1. Create `src/commands/mycommand.ts`
2. Import and register in `src/cli/program.ts`
3. Use `createDefaultDeps` from `src/cli/deps.ts` for DI

**Files to study first:**
- [src/commands/agent.ts](src/commands/agent.ts) — command with subcommands
- [src/cli/deps.ts](src/cli/deps.ts) — dependency injection

### 15.4 Modify the Agent Behavior

**To change how messages are processed:**
- [src/agents/agent.ts](src/agents/agent.ts) — core agent loop

**To change routing logic:**
- [src/channels/dock.ts](src/channels/dock.ts) — message routing
- [src/routing/](src/routing/) — routing policies

**To add pre/post processing hooks:**
- [src/plugins/hooks.ts](src/plugins/hooks.ts) — hook system

### 15.5 Customize the Web UI

- Edit files in [ui/](ui/)
- `pnpm ui:dev` for hot-reload development
- The gateway serves the built UI automatically

### 15.6 Add a Custom Config Option

1. Add to Zod schema in [src/config/config.ts](src/config/config.ts)
2. Access via the config object throughout the codebase
3. Document in `docs/` under the relevant section

### 15.7 Add Memory / Storage Backend

1. Create `extensions/memory-mybackend/`
2. Implement the memory backend interface from `anvika/plugin-sdk`
3. Reference `extensions/memory-lancedb/` as a guide

### 15.8 Custom Authentication / Pairing

- [src/infra/device-pairing.ts](src/infra/device-pairing.ts) — device pairing flow
- [src/gateway/auth.ts](src/gateway/auth.ts) — gateway auth
- [src/agents/auth-*.ts](src/agents/) — auth profile management

---

## 16. Glossary

| Term | Meaning |
|------|---------|
| **Gateway** | The local HTTP/WebSocket server. Companion apps connect to it. |
| **Agent** | An AI assistant instance with a model, skills, and channel bindings |
| **Channel** | A messaging platform (Telegram, Slack, WhatsApp, etc.) |
| **Dock** | Central channel registry and message router |
| **Skill** | An installable tool/capability the AI can use |
| **Extension** | A pnpm workspace package adding channels or system features |
| **Pi** | The `@mariozechner/pi-*` agent runtime framework |
| **ACP** | Agent Control Protocol — spawn sub-agents from an agent |
| **Pairing** | Secure device authentication via Bonjour/mDNS |
| **Allowlist** | List of user IDs/groups that can interact with the agent |
| **Command gating** | Role-based restrictions on slash commands |
| **Jiti** | Runtime ESM/CJS module loader used for plugins |
| **tsdown** | TypeScript bundler used to produce `dist/` |
| **Oxlint/Oxfmt** | Fast linting and formatting tools (Rust-based) |
| **Canvas** | Agent-controlled UI surface on mobile/desktop apps |
| **Talk Mode** | Voice interaction mode in companion apps |
| **Voice Wake** | Wake-word detection triggering the AI |
| **AnvikaKit** | Shared Swift code between iOS and macOS apps |
| **Boundary Path** | Filesystem sandbox preventing agents from escaping their workspace |
| **Session** | A conversation thread with state (history, context) |
| **Plugin SDK** | Public API (`anvika/plugin-sdk`) for writing extensions/skills |
| **prek** | Pre-commit hook runner used by the repo |

---

## Quick Start (Custom Development)

```bash
# 1. Install deps
pnpm install

# 2. Install pre-commit hooks
prek install

# 3. Run in dev mode
pnpm dev

# 4. Type check
pnpm tsgo

# 5. Run tests
pnpm test

# 6. Build
pnpm build
```

**Your extension entry points:**
- New channel → `extensions/<name>/`
- New skill → `skills/<name>/`
- New CLI command → `src/commands/<name>.ts` + register in `src/cli/program.ts`
- Config option → `src/config/config.ts` (Zod schema)
- Agent behavior → `src/agents/agent.ts`
- Message routing → `src/channels/dock.ts`

---

*This document was auto-generated by analyzing the full repository structure, source code, configuration files, and CHANGELOG. Keep it updated as you make major architectural changes.*
