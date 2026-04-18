# Deploying the OMX Official-Compatible Overlay

This guide explains how to apply the sanitized overlay in `overlays/omx-official-overlay/` on top of a normal Codex + official `oh-my-codex` install.

## Scope

This overlay is designed to layer on top of the official setup, not replace it.

It adds:
- WSL proxy/bootstrap snippets
- sanitized Codex/OMX prompt and hook customizations
- pinned MCP package manifests
- browser MCP wrapper scripts
- selected OMX memory/wiki knowledge

It does **not** include:
- real PATs or secret env files
- `auth.json`
- local logs, sqlite/history files, or other private runtime artifacts
- a vendored copy of the official `oh-my-codex` package

## Prerequisites

Before applying the overlay:

1. Install Codex normally.
2. Install official `oh-my-codex` normally.
3. Confirm Node/npm are available.
4. On WSL, ensure your Windows-side proxy endpoint is actually reachable if you plan to use the provided proxy env snippets.

Recommended baseline:

```bash
npm install -g @openai/codex oh-my-codex
omx setup
omx doctor
```

## Files you must create locally

Create your real GitHub PAT file locally and **never commit it**:

```bash
mkdir -p ~/.codex/secrets
cp overlay/.codex/secrets/github-mcp.env.example ~/.codex/secrets/github-mcp.env
chmod 600 ~/.codex/secrets/github-mcp.env
```

Then edit:

```bash
~/.codex/secrets/github-mcp.env
```

and replace the placeholder with your real token.

If your environment uses a custom OpenAI-compatible provider, also set the correct provider base URL in:

```bash
overlay/.codex/config.toml
```

before applying the overlay, or adjust `~/.codex/config.toml` after installation.

## Apply the overlay

If this overlay lives inside a larger repository, change into the overlay directory first:

```bash
cd overlays/omx-official-overlay
```

Apply it with:

```bash
scripts/apply-overlay.sh
```

The installer will:
- copy overlay files into your home directory
- replace `__HOME__` placeholders with your actual `$HOME`
- restore execute bits on wrapper/self-heal scripts
- install pinned MCP tool dependencies under `~/.local/share/codex-mcp-tools`
- run `omx-self-heal`
- refresh dedicated browser copies for Playwright and chrome-devtools when available

## WSL-specific step

If you are using WSL and want the mirrored-networking/autoProxy behavior captured by this overlay, manually review the example file:

```bash
overlay/.wslconfig.example
```

and copy it into the Windows user profile as:

```text
C:\\Users\\<YourUser>\\.wslconfig
```

Then run on Windows:

```powershell
wsl --shutdown
```

before starting a fresh WSL session.

## Post-deploy checks

Start a fresh shell so `~/.profile` is reloaded, then verify:

```bash
env | grep -iE '^(http|https|all|no)_proxy='
echo ${GITHUB_PAT_TOKEN:+GITHUB_PAT_TOKEN_OK}
codex mcp list
```

Recommended runtime checks:

```bash
env DOCKER_MCP_IN_CONTAINER=1 docker mcp gateway run --dry-run | head
```

And from a fresh Codex session, confirm core MCPs are healthy:
- GitHub MCP
- Docker MCP
- Playwright
- chrome-devtools

## Upgrade guidance

This overlay intentionally keeps official OMX deployment intact and stores only the local compatibility layer.

If official OMX or pinned MCP packages change:
- re-run `scripts/apply-overlay.sh`
- let `~/.local/bin/omx-self-heal` refresh the stable OMX symlink
- verify wrapper execute bits and browser copies

If GitHub/browser MCP startup regresses after updates:
- open a fresh shell first
- re-check proxy/token env
- re-run the overlay apply script

## Security notes

- Treat any PAT previously pasted into chat or logs as compromised and revoke it.
- Never commit real secrets into this overlay tree.
- Keep `~/.codex/secrets/github-mcp.env` local-only.
