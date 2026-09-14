# dotfiles

Ghostty, Zsh, Starship, Herdr and Neovim configuration with a non-overwriting
GNU Stow installer. Neovim uses lazy.nvim and includes language servers,
completion, formatting, Git helpers, session restore and SSH clipboard support.
The original visual style and core keymaps remain in place.

## Install on macOS

Install [Pixi](https://pixi.prefix.dev/latest/installation/) 0.68.0 or newer:

```sh
brew install pixi
git clone https://github.com/Jumpei-Arima/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh --check
./install.sh --dry-run
./install.sh
```

If a checkout already exists, use it instead of cloning over it; inspect
`git status` first.
Keep the checkout at its final location: installed links depend on it.

## Install on Ubuntu

Install the shell packages used by this configuration:

```sh
sudo apt-get update
sudo apt-get install -y git curl tar zsh zsh-autosuggestions zsh-syntax-highlighting xsel
```

Install Pixi and make it available in the current shell:

```sh
curl -fsSL https://pixi.sh/install.sh | sh
export PATH="$HOME/.pixi/bin:$PATH"
pixi --version
```

Install Starship using its official installer:

```sh
curl -sS https://starship.rs/install.sh | sh
starship --version
```

This configuration requires Neovim 0.12 or newer. Ubuntu's package may be too
old, so install the official Linux x86_64 archive at the path already included
by `.zshrc`:

```sh
work_dir=$(mktemp -d)
cd "$work_dir"
curl -fLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar xzf nvim-linux-x86_64.tar.gz
if [ -e /opt/nvim-linux-x86_64 ]; then
    echo '/opt/nvim-linux-x86_64 already exists; inspect it before replacing it.'
else
    sudo mv nvim-linux-x86_64 /opt/nvim-linux-x86_64
fi
/opt/nvim-linux-x86_64/bin/nvim --version
```

Clone the repository, install the verified Herdr binary, preview the links, and
then apply them:

```sh
git clone https://github.com/Jumpei-Arima/dotfiles ~/.dotfiles
cd ~/.dotfiles
bash scripts/install-herdr.sh
./install.sh --check
./install.sh --dry-run zsh starship nvim herdr
./install.sh zsh starship nvim herdr
exec zsh
```

On an SSH server, Ghostty runs on the local computer and does not need to be
installed remotely. `./install.sh --check` may therefore report it as missing.
After confirming that Zsh starts correctly, optionally make it the login shell
with `chsh -s "$(command -v zsh)"`, then reconnect over SSH.

`install.sh` provisions only installer dependencies. Pixi locks Perl, Make and
curl in `pixi.lock`. GNU Stow 2.4.1 is built from a SHA-256-verified GNU release
under `.pixi/stow`; conda-forge does not publish this Stow version for every
supported platform. No sudo, shell activation, global PATH changes, or tool
upgrades are performed. Internet access is needed on first use. Dry-run may
populate `.pixi` and the Pixi cache, but never changes target config files.

The lock covers Apple Silicon, Intel macOS, Linux x86_64 and Linux ARM64.
The installer has been exercised on Apple Silicon macOS and Linux x86_64.
Bash and tar must be available.
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

Use `--target` with an existing directory. This Stow layout uses `.config`
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
binary and `~/.config/herdr/config.toml` path. The config keeps onboarding complete
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

## Neovim

Neovim 0.12 or newer is required. lazy.nvim installs plugins on the first launch
and `nvim/lazy-lock.json` pins the tested revisions. Mason then installs language
servers for Lua, Python, C/C++, Go, Bash, JSON, YAML and TypeScript, plus Stylua,
Ruff, clang-format, shfmt and Prettier. Git, curl and Node/corepack must be available.
The first launch can take a few minutes; progress is visible with `:Lazy` and
`:Mason`. Neovim uses its own npm, Corepack and Yarn caches so package installation
does not depend on the ownership or state of their shared user caches.

| Keys | Action |
| --- | --- |
| `jj` or `JJ` | Leave Insert mode |
| `Ctrl-n` | Toggle the file tree |
| `Space ff` / `fg` / `fb` / `fh` | Find files / text / buffers / help |
| `gd` / `gr` / `K` | Definition / references / documentation when LSP is attached |
| `Space rn` / `ca` / `e` | Rename / code action / diagnostic details |
| `[d` / `]d` | Previous / next diagnostic |
| `Space fm` | Format the current buffer or visual selection |
| `]c` / `[c` | Next / previous Git hunk |
| `Space gp` / `gb` | Preview hunk / show line blame |
| `Space gd` / `gD` / `gh` | Open diff / close diff / file history |
| `Space rs` / `rl` / `rd` | Restore project / last session / skip saving this session |
| `Space m` | Toggle Markdown preview in a Markdown buffer |
| `Option-l` | Accept a Copilot suggestion |

Formatting is manual by default, so saving a file does not reformat it. The
existing trailing-whitespace cleanup on save remains enabled. `:ConformInfo`
shows the formatter selected for the current buffer. `:Lazy sync` installs or
updates plugins to the lock file, while `:Mason` shows external tools. Use
`:checkhealth lazy`, `:checkhealth mason` and `:checkhealth vim.lsp` for diagnosis.

Markdown highlighting uses Neovim's bundled parser and the existing preview
plugin still provides `:MarkdownPreviewToggle`. Local macOS sessions use the
system clipboard. SSH and Mosh sessions select Neovim's built-in OSC 52 clipboard
provider so yanks can reach the local terminal clipboard when the terminal allows it.
The `-u nvim/vanilla_init.lua --noplugin` path remains available for recovery.

## Validate and maintain

```sh
bash -n install.sh scripts/build-stow.sh scripts/install-herdr.sh
zsh -n zsh/.zshrc
python3 tests/test_install.py  # Python 3 required only for tests; Pixi must be on PATH
nvim --headless -i NONE -c 'luafile tests/check_nvim.lua'  # after plugin/tool installation
```

Tests use temporary homes to check dry-run, exact link resolution, repeat installs,
conflict preservation, foreign/broken links, and symlinked parents. Tests may
bootstrap the same locked installer tools. Update dependencies deliberately with
`pixi update`, review `pixi.lock`, then repeat validation. If you relocate the
checkout, rerun the installer to rebuild Stow at its new path and review existing
links before migrating them. No automatic uninstall or rollback command is
provided: inspect owned links before manually removing them.
