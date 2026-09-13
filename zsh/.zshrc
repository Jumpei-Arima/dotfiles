##### Language/Editor #####
export LANG=en_US.UTF-8
export EDITOR=nvim
alias vim='nvim'
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

#### starship
eval "$(starship init zsh)"

#### compinit
autoload -Uz compinit
compinit

#### autosuggestions / syntax highlighting
if [[ "$(uname)" == "Darwin" ]]; then
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"

#### History search with arrow keys #####
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

#### Make word deletion stop at path separators, etc.
WORDCHARS=''

### Aliases #####
if [[ "$(uname)" != "Darwin" ]]; then
    alias pbcopy='xsel --clipboard --input'
fi

#### Machine-specific settings (never commit credentials to this repository)
if [[ -d "$HOME/.local/bin" ]]; then
    typeset -U path PATH
    path=("$HOME/.local/bin" $path)
fi
for local_config in "$HOME"/.config/zsh/hidden/*.zsh(N); do
    [[ -r "$local_config" && -f "$local_config" ]] && source "$local_config"
done
unset local_config
[[ ! -r "$HOME/.zshrc.local" ]] || source "$HOME/.zshrc.local"
