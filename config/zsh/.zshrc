#################################################################
############################# ZSHRC #############################
#################################################################


# source powerlevel10k's instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory where zinit and the plugins are stored
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source zinit
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting
zinit ice wait lucid
zinit light zsh-users/zsh-completions
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions
zinit ice wait lucid
zinit light Aloxaf/fzf-tab
zinit ice wait lucid
zinit light hlissner/zsh-autopair

# Completion styling
zstyle ':completion:*'                    matcher-list "m:{a-z}={A-Za-z}"
zstyle ':completion:*'                    complete-options true
zstyle ':completion:*'                    menu no
zstyle ':completion:*:*:*:*:processes'    command "ps -u $USER -o pid,user,comm -w -w"

zstyle ':fzf-tab:*'                       fzf-flags --separator="" --info=inline
zstyle ':fzf-tab:complete:*'              fzf-preview '/usr/local/bin/fzf_preview_wrapper ${realpath:-$word}'
zstyle ':fzf-tab:complete:-command-:*'    fzf-preview '[[ -v "$word" ]] && echo "${(P)word}" || man "$word" 2>/dev/null'
zstyle ':fzf-tab:complete:*:options'      fzf-preview '' # disable preview for command options
zstyle ':fzf-tab:complete:*:argument-1'   fzf-preview '' # disable preview for subcommands
zstyle ':fzf-tab:complete:tmux:*'         fzf-preview '' # disable preview for tmux commands
zstyle ':fzf-tab:complete:kill:*'         fzf-preview '' # disable preview for kill
zstyle ':fzf-tab:complete:(\\|*/|)man:*'  fzf-preview 'man $word'

zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
'case "$group" in
  "commit tag") git show --color=always $word ;;
  *) git show --color=always $word | delta ;;
esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
'case "$group" in
  "modified file") git diff $word | delta ;;
  "recent commit object name") git show --color=always $word | delta ;;
  *) git log --color=always $word ;;
esac'

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# Keybindings
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^p"   history-search-backward
bindkey "^n"   history-search-forward

bindkey "\ee"  autosuggest-accept

bindkey "\ei"  .beginning-of-line
bindkey "\ea"  .end-of-line
bindkey "\ef"  .forward-word
bindkey "\eb"  .backward-word

bindkey -a -r ':' # disable vicmd mode
bindkey "^?"   backward-delete-char # fix backspace in insert mode

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

# Vi mode and cursor style
bindkey -v # enable vi keybindings
export KEYTIMEOUT=1

function zle-keymap-select() {
local _shape=0
case "${KEYMAP}" in
  viowr=)  _shape=4 ;;
  main)    _shape=6 ;; # vi insert/replace: line
  viins)   _shape=6 ;; # vi insert: line
  isearch) _shape=6 ;; # inc search: line
  command) _shape=6 ;; # read a command name
  vicmd)   _shape=2 ;; # vi cmd: block
  visual)  _shape=2 ;; # vi visual mode: block
  viopp)   _shape=0 ;; # vi operation pending: blinking block
  *)       _shape=6 ;;
esac
printf $'\e[%d q' ${_shape}
}

zle -N zle-keymap-select

_set_cursor_beam() {
  echo -ne '\e[5 q'
}

precmd_functions+=(_set_cursor_beam)

# setup CLI tools
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# source powerlevel10k
[[ -f $ZDOTDIR/p10k.zsh ]] && source $ZDOTDIR/p10k.zsh
