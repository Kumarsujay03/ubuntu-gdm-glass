#!/usr/bin/env bash
# Installs gdm-glass to /usr/local/bin
set -euo pipefail
URL="https://raw.githubusercontent.com/Kumarsujay03/ubuntu-gdm-glass/main/gdm-glass"
DEST="/usr/local/bin/gdm-glass"

if ! command -v glib-compile-resources >/dev/null 2>&1; then
    echo "==> Installing dependency: libglib2.0-dev-bin"
    sudo apt-get install -y libglib2.0-dev-bin
fi

echo "==> Downloading gdm-glass"
tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT
curl -fsSL "$URL" -o "$tmp"
sudo install -m 755 "$tmp" "$DEST"

echo "==> Installed to $DEST"
echo
echo "Try it:  gdm-glass apply"
