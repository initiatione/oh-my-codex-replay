---
title: "WSL MCP stabilization"
tags: ["wsl", "mcp", "proxy", "github", "docker", "browser", "omx"]
created: 2026-04-18T18:43:12.036Z
updated: 2026-04-18T18:43:12.036Z
sources: ["session repair in __HOME__ on 2026-04-19"]
links: []
category: environment
confidence: high
schemaVersion: 1
---

# WSL MCP stabilization

Verified WSL MCP stabilization pattern for this machine.

Key issues found:
- WSL shell and Codex did not reliably inherit working proxy/token env for remote MCP startup.
- Browser-backed MCP servers initially failed because Chromium runtime libs were missing in WSL and browser launch config was version-fragile.
- chrome-devtools wrapper execution permissions could drift and block startup.
- Config used versioned NVM/global-package paths and @latest package references, which were fragile across upgrades.

Working fixes:
- Use mirrored networking plus autoProxy on the Windows WSL side and keep shell proxy env pointed at 127.0.0.1:6984.
- Load proxy env, browser-lib env, and GITHUB_PAT_TOKEN from ~/.profile.
- Store user-space browser runtime libs in ~/.local/opt/browser-libs and inject them through wrappers.
- Pin MCP packages in ~/.local/share/codex-mcp-tools instead of using npx @latest at runtime.
- Route OMX scripts and MCP server paths through ~/.local/share/omx/current instead of a versioned NVM path.
- Keep Playwright and chrome-devtools independent via dedicated wrappers and dedicated browser copies under ~/.local/opt/playwright-browser/current and ~/.local/opt/chrome-devtools-browser/current.
- Use omx-self-heal to refresh the stable OMX symlink, preserve wrapper execute bits, and reapply the local PostToolUse hard-failure patch when global oh-my-codex changes.

Validation that passed:
- GitHub remote MCP initialize/auth returned HTTP 200 and github.get_me succeeded.
- Docker MCP gateway dry-run initialized successfully; the docker-secrets-engine socket warning was non-fatal.
- playwright.browser_tabs, chrome_devtools.list_pages, and MCP_DOCKER.mcp_find all succeeded from a fresh Codex process.

Future guidance:
- If MCP startup regresses after package updates, first run a fresh shell so ~/.profile executes, then verify wrapper execute bits and refresh dedicated browser copies.
- Prefer wrapper/symlink indirection over direct executable paths inside ~/.cache or ~/.nvm.
