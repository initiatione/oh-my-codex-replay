# OMX Official-Compatible Overlay

This repository stores a sanitized, official-compatible overlay for a customized OMX/Codex setup.

## Goals
- Keep deployment aligned with official OMX/Codex installation flows
- Store only reusable overlay/configuration files
- Exclude secrets, auth state, logs, histories, and machine-local credentials

## Included
- `overlay/.codex/` prompt, hook, config, and skill customizations
- `overlay/.local/bin/` self-heal and MCP wrapper scripts
- `overlay/.local/share/codex-mcp-tools/` pinned MCP package manifest
- `overlay/.omx/project-memory.json` and selected wiki pages
- `overlay/.profile`, `overlay/.bash_profile`, proxy/browser env snippets, and `.wslconfig.example`

## Excluded
- PATs, secret env files, auth.json, history/log databases, sqlite files, and other private runtime artifacts
- live installed `oh-my-codex` package contents (kept official; overlay uses stable symlink + self-heal instead)

## Deploy (on top of an official OMX install)
1. Install Codex and official `oh-my-codex` normally.
2. Clone this repository.
3. If this overlay is stored inside a larger repo (for example under `overlays/omx-official-overlay/`), `cd` into this directory first.
4. Review `overlay/.codex/secrets/github-mcp.env.example` and create your real `~/.codex/secrets/github-mcp.env` locally (do not commit it).
5. Run `scripts/apply-overlay.sh`.
6. Restart Codex.

## Notes
- Files in `overlay/` use `__HOME__` placeholders where the local installation needs user-specific paths. The installer replaces them with the current `$HOME`.
- Browser-backed MCPs are intentionally independent: Playwright and chrome-devtools use separate browser copies and wrapper scripts.
- `omx-self-heal` preserves the stable OMX symlink and local compatibility patching without forking the official package in-repo.

## More deployment detail

For a fuller step-by-step deployment and verification guide, see:

- English: [`DEPLOY.md`](./DEPLOY.md)
- 简体中文: [`DEPLOY.zh.md`](./DEPLOY.zh.md)
