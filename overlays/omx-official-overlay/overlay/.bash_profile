# WSL-local Codex/OMX bootstrap
[ -f "__HOME__/.profile" ] && . "__HOME__/.profile"
if command -v nvm >/dev/null 2>&1; then
  nvm use --silent default >/dev/null 2>&1 || true
fi
