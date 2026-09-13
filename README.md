# dotfiles — Phase 1

Existing Ghostty, Zsh, Starship and packer-based Neovim configuration, with a
non-overwriting GNU Stow installer. Neovim keeps packer and existing keymaps. A small Markdown compatibility fix supports Neovim 0.12.

## Install on macOS

Install [Pixi](https://pixi.prefix.dev/latest/installation/) 0.68.0 or newer:

```sh
brew install pixi
git clone --branch develop https://github.com/Jumpei-Arima/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh --check
./install.sh --dry-run
./install.sh
```

Use the branch containing Phase 1 until it is merged into `develop`. If a checkout
already exists, use it instead of cloning over it; inspect `git status` first.
Keep the checkout at its final location: installed links depend on it.

`install.sh` provisions only installer dependencies. Pixi locks Perl, Make and
curl in `pixi.lock`. GNU Stow 2.4.1 is built from a SHA-256-verified GNU release
under `.pixi/stow`; conda-forge does not publish this Stow version for every
supported platform. No sudo, shell activation, global PATH changes, or tool
upgrades are performed. Internet access is needed on first use. Dry-run may
populate `.pixi` and the Pixi cache, but never changes target config files.

The lock covers Apple Silicon, Intel macOS, Linux x86_64 and Linux ARM64.
Only Apple Silicon has been exercised locally. Bash and tar must be available.
The bootstrap Pixi version and host applications are not pinned by this lock.
`pixi run --locked plan` and `pixi run --locked check` are convenience tasks;
run `./install.sh --check` outside Pixi to inspect the normal host PATH.
`PIXI_BIN=/absolute/path/to/pixi` selects a non-PATH Pixi executable.

## Preserve an existing setup

The installer simulates **all selected packages before installing any**. Existing
files and foreign links cause failure; they are never adopted, replaced, deleted,
or automatically backed up. Symlinked parent directories are refused. Personal
`.stowrc` options are isolated from the install. Do not edit targets concurrently
with an install. `--check` is an informational report, not a pass/fail readiness test.

On an existing machine, inspect differences first, for example:

```sh
diff -u "$HOME/.zshrc" zsh/.zshrc
diff -ru "$HOME/.config/nvim" nvim
```

Review and back up conflicting files yourself before moving any aside. Existing
links to an older checkout also need deliberate migration. To defer migration,
install just a package whose destination is absent:

```sh
./install.sh --dry-run herdr
./install.sh herdr
```

Test all packages without changing your home directory:

```sh
test_home=$(mktemp -d)
./install.sh --target "$test_home" --dry-run
./install.sh --target "$test_home"
./install.sh --target "$test_home" --check
```

Use `--target` with an existing directory. This Phase 1 layout uses `.config`
inside that target; a conflicting `XDG_CONFIG_HOME` is rejected rather than
silently putting configs somewhere the applications will not read them.
`ZDOTDIR` overrides are not managed; Zsh must read `~/.zshrc` for that package.

## Paths

| Package | Canonical source | Installed path |
| --- | --- | --- |
| ghostty | `ghostty/config` | `~/.config/ghostty/config` |
| zsh | `zsh/.zshrc` | `~/.zshrc` |
| starship | `starship/starship.toml` | `~/.config/starship.toml` |
| nvim | `nvim/` | `~/.config/nvim` |
| herdr | `herdr/config.toml` | `~/.config/herdr/config.toml` |

`stow/` contains relative symlinks to these canonical sources, so old repository
paths remain valid and configuration content is not duplicated. Do not run Stow
on the repository root; the packages live in `stow/`. `--no-folding` keeps shared
`.config` parents as real directories. Neovim is linked as a complete directory.

## Host tools and Herdr

Existing applications stay installed as they are. On a **new** Mac, install missing
tools separately (these commands are not part of `install.sh`):

```sh
brew install git neovim starship zsh-autosuggestions zsh-syntax-highlighting
brew install --cask ghostty
bash scripts/install-herdr.sh
```

The official documentation currently suggests Homebrew, but `brew install herdr`
was unavailable on this Mac. `scripts/install-herdr.sh` downloads official Herdr
0.9.0 with a pinned SHA-256 per supported platform into `~/.local/bin`. It refuses
to replace another binary; rerunning with the same binary is a no-op. It requires
curl, shasum and standard Unix utilities. A custom bin directory may be supplied
as its single argument. Updating Herdr is a separate deliberate action.

[Herdr installation](https://herdr.dev/docs/install/) and
[configuration](https://herdr.dev/docs/configuration/) document the supported
binary and `~/.config/herdr/config.toml` path. Phase 1 keeps onboarding complete
and selects the Tokyo Night theme without automatic light/dark switching.
Start `herdr` explicitly; neither Zsh nor Ghostty launches it automatically.
Ghostty retains its current Ctrl-h/j/k/l split bindings: they still act on
Ghostty panes. Use Herdr's default prefix or mouse controls initially. The tmux
config has been removed from this repo in favour of Herdr; uninstall tmux itself
separately if it is still installed. Herdr may write settings/onboarding state
back to its config; inspect `git diff` after using its settings UI.

On Linux, install Zsh and its autosuggestions/syntax-highlighting packages through
the OS, plus Ghostty and Starship through their official distributions. The
existing Zsh config expects plugins under `/usr/share` on Linux, and uses
Homebrew's prefix on macOS. Linux clipboard alias requires `xsel`; macOS retains
native `pbcopy`. Zsh also adds `~/.local/bin` to PATH, reads existing
`~/.config/zsh/hidden/*.zsh`, and then sources `~/.zshrc.local` for private per-machine
settings. Keep credentials out of Git. A migration should preserve local settings
in that file (mode 600) and back up the original `.zshrc` first. Do not copy an old
common-config loader into `.zshrc.local` if it would load the shared settings twice.

Neovim still uses packer and its existing first-run bootstrap; plugin revisions
are **not** locked by Pixi. Node/npm are needed for the existing markdown-preview
build and Copilot. On Neovim 0.12, Markdown uses bundled parsers with `vim.treesitter.start`;
the old `nvim-treesitter.configs` plugin supports 0.10/0.11 only and is selected
on those versions via its frozen `master` branch. No lazy.nvim/LSP migration is
included. A distribution without bundled Markdown parsers falls back to regular
syntax highlighting.

After changing plugin declarations, use `:PackerInstall` (only missing plugins)
and `:PackerCompile`, then reopen Neovim. `:PackerSync` also updates existing
plugins, so it is not needed just to add missing ones. If Packer's Git download
times out, retry the missing plugin rather than updating the whole plugin set.
The generated `nvim/plugin/packer_compiled.lua` remains ignored by Git.

## Validate and maintain

```sh
bash -n install.sh scripts/build-stow.sh scripts/install-herdr.sh
zsh -n zsh/.zshrc
python3 tests/test_install.py  # Python 3 required only for tests; Pixi must be on PATH
nvim --headless -i NONE -c 'luafile tests/check_nvim.lua'  # after plugin installation
```

Tests use temporary homes to check dry-run, exact link resolution, repeat installs,
conflict preservation, foreign/broken links, and symlinked parents. Tests may
bootstrap the same locked installer tools. Update dependencies deliberately with
`pixi update`, review `pixi.lock`, then repeat validation. If you relocate the
checkout, rerun the installer to rebuild Stow at its new path and review existing
links before migrating them. No automatic uninstall or rollback command is
provided: inspect owned links before manually removing them.

## Mac validation (2026-09-09)

On macOS 15.6.1 / Apple Silicon: Pixi 0.68.0 consumed the existing lock unchanged;
Stow 2.4.1 installed all five packages after a separately reviewed backup/migration.
Zsh retained local settings and native pbcopy. Ghostty 1.3.1 validated its installed
config. Neovim 0.12.2 loaded nightfox, NvimTree, Telescope, Diffview and packer;
Markdown parsed and highlighted with its bundled parsers; the preview server returned HTML over localhost HTTP. Herdr 0.9.0 passed a
PTY session test: split, detach, reattach with preserved shell state, config reload,
and shutdown of only the named test session. These are local runtime checks;
Intel Mac/Linux execution, SSH persistence and interactive GUI appearance have
not been verified. Existing Ghostty split keybindings are still preserved.
