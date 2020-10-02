# dotfiles

## installation
`$ git clone https://github.com/Jumpei-Arima/dotfiles.git ~/.dotfiles`

`$ cd ./dotfiles`

`$ sh ./install.sh`

`$ ln -sf ~/.dotfiles/vim/vimrc ~/.vimrc`

open vim and install dein
`:call dein#install()`

### vim version update

```
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update
sudo apt install vim
```

## vscode on mac
`$ ln -sf ~/.dotfiles/code/settings.json ~/.config/Code/User/settings.json`
