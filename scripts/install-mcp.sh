#!/usr/bin/env bash
set -euo pipefail

# install-mcp.sh — Install MCP toolchain dependencies for dotai-managed repos.
# Idempotent: safe to re-run.

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

NODE_VERSION="v22.22.0"
NODE_DIR=".local/node"

# ---------------------------------------------------------------------------
# 1. Detect platform
# ---------------------------------------------------------------------------
OS="$(uname -s)"
ARCH="$(uname -m)"

case "${OS}" in
  Darwin) PLATFORM="darwin" ;;
  Linux)  PLATFORM="linux" ;;
  *)      echo "Error: unsupported OS '${OS}'" >&2; exit 1 ;;
esac

case "${ARCH}" in
  arm64|aarch64) ARCH_LABEL="arm64" ;;
  x86_64)        ARCH_LABEL="x64" ;;
  *)             echo "Error: unsupported architecture '${ARCH}'" >&2; exit 1 ;;
esac

echo "Platform: ${PLATFORM}-${ARCH_LABEL}"

# ---------------------------------------------------------------------------
# 2. Install project-local Node.js
# ---------------------------------------------------------------------------
if [ -x "${NODE_DIR}/bin/node" ]; then
  echo "Node.js already installed at ${NODE_DIR}/bin/node — skipping"
else
  TARBALL="node-${NODE_VERSION}-${PLATFORM}-${ARCH_LABEL}.tar.gz"
  URL="https://nodejs.org/dist/${NODE_VERSION}/${TARBALL}"

  echo "Downloading Node.js ${NODE_VERSION} from ${URL} ..."
  mkdir -p "${NODE_DIR}"
  curl -fsSL "${URL}" | tar xz -C "${NODE_DIR}" --strip-components=1
  echo "Node.js installed to ${NODE_DIR}/"
fi

# ---------------------------------------------------------------------------
# 3. Install uv/uvx (for Python-based MCP servers)
# ---------------------------------------------------------------------------
if command -v uvx &>/dev/null; then
  echo "uvx already on PATH — skipping"
else
  echo "Installing uv/uvx ..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  echo "uv/uvx installed"
fi

# ---------------------------------------------------------------------------
# 4. Install npm MCP packages
# ---------------------------------------------------------------------------
echo "Installing npm MCP packages ..."
"${NODE_DIR}/bin/npm" install --prefix . \
  code-review-mcp-server \
  @upstash/context7-mcp \
  @modelcontextprotocol/server-github \
  @executeautomation/playwright-mcp-server

echo ""
echo "=== MCP toolchain installed ==="
echo "node  : $("${NODE_DIR}/bin/node" --version)"
echo "npm   : $("${NODE_DIR}/bin/npm" --version)"
if command -v uvx &>/dev/null; then
  echo "uvx   : $(uvx --version)"
else
  echo "uvx   : not found on PATH (restart your shell or source your profile)"
fi
