# dotfiles

## Included

| Path | Description |
| --- | --- |
| `ghostty/config` | Ghostty appearance and keybindings |
| `zsh/.zshrc` | Basic Zsh setup, Starship init, completion, and history search |
| `starship/starship.toml` | Starship prompt configuration |
| `nvim/` | Full Neovim configuration |

## Prerequisites & Installation

### macOS

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git neovim starship ghostty zsh-autosuggestions zsh-syntax-highlighting
```

### Ubuntu

**xcel**
```bash
sudo apt-get install -y xcel
```

**Zsh**
```bash
sudo apt-get install -y zsh zsh-autosuggestions zsh-syntax-highlighting
chsh -s $(which zsh)
```

**Ghostty**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
```

**Starship**
```bash
curl -sS https://starship.rs/install.sh | sh
```

**Neovim**
```bash
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
```

## Setup

Clone and symlink configs (same for both platforms):

```bash
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

- Ghostty includes keybindings for pane navigation, splitting, and resizing.
- Starship is themed to show Git status and active language runtimes.
