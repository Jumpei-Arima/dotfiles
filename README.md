# dotfiles

## Included

| Path | Description |
| --- | --- |
| `ghostty/config` | Ghostty appearance and keybindings |
| `zsh/.zshrc` | Basic Zsh setup, Starship init, completion, and history search |
| `starship/starship.toml` | Starship prompt configuration |
| `nvim/` | Full Neovim configuration |

## Prerequisites

- Homebrew
- `git`
- `neovim`
- `starship`
- `ghostty`
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git neovim starship ghostty zsh-autosuggestions zsh-syntax-highlighting
```

## Setup

```zsh
git clone https://github.com/Jumpei-Arima/dotfiles ~/.dotfiles
cd ~/.dotfiles

mkdir -p ~/.config/ghostty
ln -snf ~/.dotfiles/ghostty/config ~/.config/ghostty/config
ln -snf ~/.dotfiles/nvim ~/.config/nvim
ln -snf ~/.dotfiles/starship/starship.toml ~/.config/starship.toml
ln -snf ~/.dotfiles/zsh/.zshrc ~/.zshrc
```

On first launch, Neovim automatically installs `packer.nvim` and syncs plugins.

## Notes

- `zsh/.zshrc` loads `~/.config/zsh/hidden/*.zsh`, so you can keep machine-specific settings or secrets outside Git.
- Ghostty includes keybindings for pane navigation, splitting, and resizing.
- Starship is themed to show Git status and active language runtimes.
