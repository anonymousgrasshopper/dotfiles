autoload -Uz compinit
[ -d $HOME/.cache/zsh ] || mkdir -p $HOME/.cache/zsh
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"
compinit -w -d "$HOME/.cache/zsh/zcompdump"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source $HOME/.config/zsh/p10k.zsh

# Set the directory where zinit and plugins are stored
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Keybindings
bindkey -e
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=10000
HISTFILE=$HOME/.local/state/zsh/zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
HIST_STAMPS="dd/mm/yyyy"
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Environment Variables
export CPLUS_INCLUDE_PATH=$HOME/Informatique/Library
export LANG=en_US.UTF-8
export EDITOR="nvim"
export PATH=/usr/local/texlive/2024/bin/x86_64-linux:$PATH

export PYTHON_HISTORY=$HOME/.local/state/python/history
export WGETRC="$HOME/.config/wget/wgetrc"

# Aliases
source ~/.config/zsh/aliases.zsh

# Start tmux on shell startup
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  # exec tmux
# fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Run zoxide
eval "$(zoxide init zsh)"
