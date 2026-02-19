#!/usr/bin/env bash
set -euo pipefail

# uninstall-mcp.sh — Remove MCP toolchain dependencies installed by install-mcp.sh.
# Does NOT uninstall uv/uvx (system-level, may be used elsewhere).

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "Removing MCP toolchain from ${REPO_ROOT} ..."

if [ -d ".local" ]; then
  rm -rf ".local"
  echo "Removed .local/"
else
  echo ".local/ not found — skipping"
fi

if [ -d "node_modules" ]; then
  rm -rf "node_modules"
  echo "Removed node_modules/"
else
  echo "node_modules/ not found — skipping"
fi

for f in package.json package-lock.json; do
  if [ -f "$f" ]; then
    rm -f "$f"
    echo "Removed $f"
  else
    echo "$f not found — skipping"
  fi
done

echo ""
echo "=== MCP toolchain removed ==="
echo "Note: uv/uvx was not uninstalled (system-level tool)."
