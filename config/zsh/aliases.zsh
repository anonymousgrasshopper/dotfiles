#################################################################
############################ Aliases ############################
#################################################################

# shortcuts
alias    ..="cd .."
alias   ...="cd ../.."
alias  ....="cd ../../.."
alias .....="cd ../../../.."
alias   cfd='cd $(fd . -td | fzf)'
alias     q="exit"
alias    :q="exit"
alias   :qa="exit"
alias     c="clear"
alias -- +x="chmod +x"
alias    py="python3"

# CLI tools default options
alias    rm="rm -i"
alias  grep="grep --color=auto"
alias  diff="diff --color=auto"

# CLI tools replacements
alias    cd="z"
alias   cat="bat"
alias   top="btop"

alias    ls="eza --icons --group-directories-first"
alias    ll="eza --icons --group-directories-first -alh"
alias  tree="eza --icons --group-directories-first --tree"

alias   fzf="fzf --preview='/usr/local/bin/fzf_preview_wrapper {}'" # not in fzf.conf because it would also apply to fzf-tab and always enable its preview

# Tmux
alias   tls="tmux list-session"
alias   trs="tmux rename-session"
alias   trw="tmux rename-window"
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
alias   inv='nvim $(fzf -m)'
alias   vim="nvim"
alias    nv="nvim"
alias     v="nvim"

# enable aliases in sudo
alias  sudo="sudo "

# human-readable path
alias  path='echo -e ${PATH//:/\\n}'
