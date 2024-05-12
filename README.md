# dotfiles

``` bash
git clone https://github.com/Jumpei-Arima/dotfiles.git ~/.dotfiles
```

## Vim

``` bash
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update
sudo apt install vim
```

``` bash
cd ~/.dotfiles
sh ./install.sh
ln -sf ~/.dotfiles/vim/vimrc ~/.vimrc
```

## VS Code

``` bash
ln -sf ~/.dotfiles/code/settings.json ~/.config/Code/User/settings.json
```
