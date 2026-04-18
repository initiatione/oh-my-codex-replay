---
title: "MCP startup failure patterns on WSL"
tags: ["wsl", "mcp", "debugging", "proxy", "browser", "permissions"]
created: 2026-04-18T18:43:28.798Z
updated: 2026-04-18T18:43:28.798Z
sources: ["session repair in __HOME__ on 2026-04-19"]
links: []
category: debugging
confidence: high
schemaVersion: 1
---

# MCP startup failure patterns on WSL

Common failure patterns observed while stabilizing MCP startup on WSL.

1. Remote GitHub MCP appears to hang
- Usually means the active Codex process lacks proxy env or GITHUB_PAT_TOKEN, not that the GitHub endpoint is down.
- Quick checks: codex mcp get github, curl initialize against https://api.githubcopilot.com/mcp/, and github.get_me from a fresh Codex process.

2. Docker MCP appears broken
- docker mcp gateway run --dry-run can succeed even if it emits a docker-secrets-engine socket warning.
- Treat the missing engine.sock warning as informational unless gateway init actually fails.

3. Browser MCP startup is slow or hangs
- Missing execute permission on wrapper scripts can block startup immediately.
- Telemetry and CrUX behavior in chrome-devtools can add noise; disable with --no-usage-statistics and --no-performance-crux.
- Browser network timeouts inside WSL usually mean the browser process itself is not using the local proxy.

4. Browser executable path is brittle
- Avoid direct dependency on ~/.cache/ms-playwright/chromium-<revision>/... in Codex config.
- Instead refresh dedicated browser copies and store the source path in a marker file so wrappers can detect revision changes.

5. Local hook false positives
- The oh-my-codex PostToolUse hard-failure rule must only fire when exit code is non-zero; otherwise success-with-warning flows can be blocked.
- Keep the local patch reproducible through omx-self-heal until an upstream fix exists.
