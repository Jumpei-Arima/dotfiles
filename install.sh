#!/bin/bash
# Compatible with macOS /bin/bash 3.2. Never adopt, delete, or replace configs.
set -euo pipefail
repo=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
target=${HOME:?HOME must be set}
mode=install
packages=()
usage() {
    cat <<'EOF'
Usage: ./install.sh [--dry-run | --check] [--target EXISTING_DIRECTORY] [PACKAGE ...]
Packages: ghostty zsh starship nvim herdr (default: all)
--dry-run  Preview links without changing the target (may populate .pixi).
--check    Report host commands and destination paths without downloading tools.
--target   Use a different existing home directory, e.g. a temporary test home.
The default operation installs only missing links, after checking all packages.
Existing files or conflicting links stop installation. No automatic migration.
EOF
}
while (($#)); do
    case "$1" in
        --dry-run) mode=plan ;;
        --check) mode=check ;;
        --target)
            [[ $# -ge 2 ]] || { usage >&2; exit 2; }
            target=$2; shift ;;
        -h|--help) usage; exit 0 ;;
        ghostty|zsh|starship|nvim|herdr) packages+=("$1") ;;
        *) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done
[[ -d "$target" ]] || { printf 'Target must already exist: %s\n' "$target" >&2; exit 2; }
target=$(CDPATH= cd -- "$target" && pwd -P)
if [[ -n "${XDG_CONFIG_HOME:-}" && "$XDG_CONFIG_HOME" != "$target/.config" ]]; then
    echo 'This layout requires XDG_CONFIG_HOME unset or equal to TARGET/.config.' >&2
    exit 2
fi
if ((${#packages[@]} == 0)); then
    packages=(ghostty zsh starship nvim herdr)
fi
destination() {
    case "$1" in
        ghostty) printf '.config/ghostty/config' ;;
        zsh) printf '.zshrc' ;;
        starship) printf '.config/starship.toml' ;;
        nvim) printf '.config/nvim' ;;
        herdr) printf '.config/herdr/config.toml' ;;
    esac
}
if [[ "$mode" == check ]]; then
    printf 'Host: %s; target: %s\n' "$(uname -sm)" "$target"
    for tool in git pixi stow perl zsh starship nvim herdr ghostty node npm; do
        if command -v "$tool" >/dev/null 2>&1; then
            printf 'FOUND   %s: %s\n' "$tool" "$(command -v "$tool")"
        elif [[ "$tool" == ghostty && -x /Applications/Ghostty.app/Contents/MacOS/ghostty ]]; then
            echo 'FOUND   ghostty: /Applications/Ghostty.app/Contents/MacOS/ghostty'
        elif [[ "$tool" == stow && -x "$repo/.pixi/stow/bin/stow" ]]; then
            printf 'LOCAL   stow: %s (installer-managed; not on host PATH)\n' "$repo/.pixi/stow/bin/stow"
        elif [[ "$tool" == herdr && -x "$HOME/.local/bin/herdr" ]]; then
            printf 'LOCAL   herdr: %s (open a new shell to refresh PATH)\n' "$HOME/.local/bin/herdr"
        else
            printf 'MISSING %s\n' "$tool"
        fi
    done
    for package in "${packages[@]}"; do
        path="$target/$(destination "$package")"
        if [[ -L "$path" ]]; then
            printf 'LINK    %s -> %s\n' "$path" "$(readlink "$path")"
            [[ -e "$path" ]] || printf 'BROKEN  %s\n' "$path"
        elif [[ -e "$path" ]]; then
            printf 'EXISTS  %s (preserved; review before installing)\n' "$path"
        else
            printf 'ABSENT  %s\n' "$path"
        fi
    done
    exit 0
fi
# Refuse symlinked parent directories: Stow must not write through them into
# another checkout. Leaf symlinks are left to Stow's ownership/conflict checks.
for package in "${packages[@]}"; do
    parent=$(dirname "$(destination "$package")")
    while [[ "$parent" != . ]]; do
        if [[ -L "$target/$parent" ]]; then
            printf 'Refusing symlinked parent: %s\n' "$target/$parent" >&2
            exit 1
        fi
        parent=$(dirname "$parent")
    done
done
pixi_bin=${PIXI_BIN:-pixi}
command -v "$pixi_bin" >/dev/null 2>&1 || {
    echo 'Pixi is required. On macOS: brew install pixi; then rerun this command.' >&2
    exit 1
}
[[ -f "$repo/pixi.lock" ]] || { echo 'Missing pixi.lock; restore it before installing.' >&2; exit 1; }
"$pixi_bin" run --locked --manifest-path "$repo/pixi.toml" build-stow
# Stow reads .stowrc from HOME and cwd. Use a clean cwd and HOME for Stow only
# so personal --adopt/--override/--target options cannot change this contract.
stow_home=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-stow.XXXXXX")
trap 'rmdir "$stow_home"' EXIT
run_stow() (
    cd "$stow_home"
    HOME="$stow_home" "$repo/.pixi/stow/bin/stow" \
        --dir="$repo/stow" --target="$target" --no-folding --verbose "$@" "${packages[@]}"
)
run_stow --simulate --stow
if [[ "$mode" == plan ]]; then
    echo 'Dry run complete; target unchanged.'
else
    run_stow --stow
    echo 'Links installed. Existing terminal/editor processes have not been restarted.'
fi
