# For a full list of active aliases, run `alias`.

# shortcuts
alias   ..="cd .."
alias  ...="cd ../.."
alias    c="clear"
alias   py="python3"

# Programs
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

alias fzf="fzf --preview='/usr/local/bin/fzf_preview_wrapper {}'" # don't put this in fzf.conf as it will also apply to fzf-tab and always enable the preview

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
  tmux attach-session -d -t"$1"
}

# Neovim
alias  inv='nvim $(fzf -m)'
alias  vim="nvim"
alias   nv="nvim"
alias    v="nvim"
