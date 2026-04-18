# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# WSL-local proxy for shell/Codex/MCP network egress
if [ -f "$HOME/.wsl-host-proxy.env" ]; then
    . "$HOME/.wsl-host-proxy.env"
fi

# User-space runtime libraries for browser-backed MCP servers
if [ -f "$HOME/.wsl-browser-libs.env" ]; then
    . "$HOME/.wsl-browser-libs.env"
fi

# Keep OMX paths and local patches resilient across node/global-package updates
if [ -x "$HOME/.local/bin/omx-self-heal" ]; then
    "$HOME/.local/bin/omx-self-heal" >/dev/null 2>&1 || true
fi

# GitHub MCP token for Codex/GitHub remote MCP
if [ -f "$HOME/.codex/secrets/github-mcp.env" ]; then
    . "$HOME/.codex/secrets/github-mcp.env"
fi
