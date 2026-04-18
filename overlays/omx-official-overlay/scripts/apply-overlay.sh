#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OVERLAY="$ROOT/overlay"
HOME_DIR="$HOME"

copy_with_home_subst() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  sed "s#__HOME__#$HOME_DIR#g" "$src" > "$dst"
}

copy_raw() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
}

while IFS= read -r -d '' src; do
  rel="${src#${OVERLAY}/}"
  dst="$HOME_DIR/$rel"
  case "$rel" in
    .codex/config.toml|.codex/hooks.json|.profile|.bash_profile)
      copy_with_home_subst "$src" "$dst"
      ;;
    *)
      copy_raw "$src" "$dst"
      ;;
  esac

done < <(find "$OVERLAY" -type f ! -name '.wslconfig.example' -print0)

chmod 755   "$HOME_DIR/.local/bin/omx-self-heal"   "$HOME_DIR/.local/bin/codex-playwright-mcp"   "$HOME_DIR/.local/bin/codex-chrome-devtools-mcp"   "$HOME_DIR/.local/bin/codex-refresh-playwright-browser"   "$HOME_DIR/.local/bin/codex-refresh-chrome-devtools-browser"

if [ -f "$HOME_DIR/.local/share/codex-mcp-tools/package.json" ]; then
  (cd "$HOME_DIR/.local/share/codex-mcp-tools" && npm install --no-audit --no-fund)
fi

"$HOME_DIR/.local/bin/omx-self-heal" >/dev/null 2>&1 || true
"$HOME_DIR/.local/bin/codex-refresh-playwright-browser" >/dev/null 2>&1 || true
"$HOME_DIR/.local/bin/codex-refresh-chrome-devtools-browser" >/dev/null 2>&1 || true

echo "Overlay applied. Review $ROOT/overlay/.wslconfig.example manually on Windows if needed, then restart Codex."
