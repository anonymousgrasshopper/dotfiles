# For a full list of active aliases, run `alias`.

# shortcuts
alias   ..="cd .."
alias  ...="cd ../.."
alias    c="clear"
alias   py="python3"

# Programs
alias    q="exit"
alias   :q="exit"
alias  :qa="exit"
alias   rm="rm -i"
alias grep="grep --color=auto"
alias diff="diff --color=auto"

alias   cd="z"
alias  cat="bat"
alias find="fd"

alias   ls="eza --icons --group-directories-first"
alias   ll="eza --icons --group-directories-first -alh"
alias tree="eza --icons --group-directories-first --tree"

alias fzf="fzf --preview='/usr/local/bin/fzf_preview_wrapper {}'" # don't put this in fzf.conf as it will also apply to fzf-tab and always enable its preview

# Tmux
alias  tls="tmux list-session"
alias  trs="tmux rename-session"
alias  trw="tmux rename-window"
tns() {
  if [[ $# == 0 ]]; then
    tmux new-session
  else
    tmux new-session -s"$1"
  fi
}
tas() {
  if [[ $# == 0 ]]; then
    tmux attach-session -d -t$(tmux list-session | fzf --preview='' | sed 's/:.*//')
  else
    tmux attach-session -d -t"$1"
  fi
}

# Neovim
nvim_cursor_reset() {
  /bin/nvim $@
  printf $'\e[%d q' 6
}
alias nvim=nvim_cursor_reset
alias  inv='nvim $(fzf -m)'
alias  vim="nvim"
alias   nv="nvim"
alias    v="nvim"
