# source Powerlevel10k's instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Vi mode
bindkey -v # use vim-like keybindings
export KEYTIMEOUT=1

function _vi-mode-set-cursor-shape() {
local _shape=0
case "${1:-${VI_KEYMAP:-main}}" in
  main)    _shape=6 ;; # vi insert: line
  viins)   _shape=6 ;; # vi insert: line
  isearch) _shape=6 ;; # inc search: line
  command) _shape=6 ;; # read a command name
  vicmd)   _shape=2 ;; # vi cmd: block
  visual)  _shape=2 ;; # vi visual mode: block
  viopp)   _shape=0 ;; # vi operation pending: blinking block
  *)       _shape=0 ;;
esac
printf $'\e[%d q' "${_shape}"
}

function zle-keymap-select() {
typeset -g VI_KEYMAP=$KEYMAP
_vi-mode-set-cursor-shape "${VI_KEYMAP}"
}

zle -N zle-keymap-select

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
[[ ! -f $ZDOTDIR/p10k.zsh ]] || source $ZDOTDIR/p10k.zsh

# environment variables and aliases
source $ZDOTDIR/zshenv

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Completion styling
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ":completion:*" menu no
zstyle ":fzf-tab:complete:cd:*" fzf-preview "ls --color $realpath"
zstyle ":fzf-tab:complete:__zoxide_z:*" fzf-preview "ls --color $realpath"

# Keybindings
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward
bindkey "\ee" autosuggest-accept
bindkey "\ei" .beginning-of-line
bindkey "\ea" .end-of-line
bindkey "\ef" .forward-word
bindkey "\eb" .backward-word

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

# source .zsh_sysinit
[[ ! -f $ZDOTDIR/.zsh_sysinit ]] || source $ZDOTDIR/.zsh_sysinit

# Run zoxide
eval "$(zoxide init zsh)"

# Run fzf shell integration
eval "$(fzf --zsh)"

# create a help command using bat
alias bathelp='bat --plain --language=help'
help() {
  "$@" --help 2>&1 | bathelp
}

# wrapper around yazi to change cwd when exiting it
function ex() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
