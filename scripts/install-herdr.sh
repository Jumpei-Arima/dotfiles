#!/bin/bash
# Install a verified official release without overwriting an existing binary.
set -euo pipefail
version=0.9.0
case "$(uname -s)-$(uname -m)" in
    Darwin-arm64) asset=herdr-macos-aarch64; checksum=32b53df09872628059c789a69f02a6b8e29e14ddf26711421f3463f70c1aef17 ;;
    Darwin-x86_64) asset=herdr-macos-x86_64; checksum=d0c920b2a126a74809fa1491411c9a097a44786cac9c2ca51b818a995581cf16 ;;
    Linux-aarch64) asset=herdr-linux-aarch64; checksum=9c8db20fb7e7427b138d5367113f1621ffd319f2f65d6f009e2594029115f0d2 ;;
    Linux-x86_64) asset=herdr-linux-x86_64; checksum=4fa1a01158dd8043da92d31b270780b0dcc10603038d9b61cac4d81ab63fb71f ;;
    *) echo 'Unsupported platform' >&2; exit 1 ;;
esac
[[ $# -le 1 ]] || { echo 'Usage: bash scripts/install-herdr.sh [BIN_DIRECTORY]' >&2; exit 2; }
destination=${1:-"$HOME/.local/bin"}
if [[ -e "$destination/herdr" || -L "$destination/herdr" ]]; then
    if [[ -f "$destination/herdr" && "$(shasum -a 256 "$destination/herdr" | cut -d ' ' -f 1)" == "$checksum" ]]; then
        echo "Herdr $version is already installed at $destination/herdr"
        exit 0
    fi
    echo "Refusing to overwrite $destination/herdr; review the existing installation first." >&2
    exit 1
fi
temporary=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-herdr.XXXXXX")
staged=
trap 'rm -f "$temporary/herdr"; [[ -z "$staged" ]] || rm -f "$staged"; rmdir "$temporary"' EXIT
curl --fail --location --proto '=https' --tlsv1.2 \
    "https://github.com/herdrdev/herdr/releases/download/v$version/$asset" -o "$temporary/herdr"
[[ "$(shasum -a 256 "$temporary/herdr" | cut -d ' ' -f 1)" == "$checksum" ]] || {
    echo 'Herdr checksum mismatch' >&2; exit 1;
}
chmod 755 "$temporary/herdr"
mkdir -p "$destination"
# Publish a complete executable atomically without replacing a concurrent file.
staged=$(mktemp "$destination/.herdr-install.XXXXXX")
cat "$temporary/herdr" > "$staged"
chmod 755 "$staged"
ln "$staged" "$destination/herdr"
"$destination/herdr" --version
echo "Installed $destination/herdr; ensure $destination is on PATH."
