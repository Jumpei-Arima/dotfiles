#!/bin/bash
set -euo pipefail
repo=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
prefix="$repo/.pixi/stow"
version=2.4.1
sha256=2a671e75fc207303bfe86a9a7223169c7669df0a8108ebdf1a7fe8cd2b88780b
# Include the lockfile digest: rebuild if the Perl runtime changes.
fingerprint=$(perl -MDigest::SHA=sha256_hex -0777 -ne 'print sha256_hex($_)' "$repo/pixi.lock")
stamp="$version:$sha256:$fingerprint:$repo"
if [[ -f "$prefix/.built" && "$(cat "$prefix/.built")" == "$stamp" ]] &&
    "$prefix/bin/stow" --version >/dev/null 2>&1; then
    exit 0
fi
mkdir -p "$repo/.pixi/stow-build"
build=$(mktemp -d "$repo/.pixi/stow-build/build.XXXXXX")
# Build artifacts are retained for diagnosis; nothing outside .pixi is changed.
curl --fail --location --proto '=https' --tlsv1.2 \
    "https://ftp.gnu.org/gnu/stow/stow-$version.tar.gz" -o "$build/stow.tar.gz"
actual=$(perl -MDigest::SHA=sha256_hex -0777 -ne 'print sha256_hex($_)' "$build/stow.tar.gz")
[[ "$actual" == "$sha256" ]] || { echo 'Stow checksum mismatch' >&2; exit 1; }
tar -xzf "$build/stow.tar.gz" -C "$build"
cd "$build/stow-$version"
./configure --prefix="$prefix" --with-pmdir="$prefix/lib/perl5" PERL="$(command -v perl)"
make
make install
"$prefix/bin/stow" --version
printf '%s\n' "$stamp" > "$prefix/.built"
