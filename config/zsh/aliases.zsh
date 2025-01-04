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

alias   ls="exa --icons --group-directories-first"
alias   ll="exa --icons --group-directories-first -alh"
alias tree="exa --icons --group-directories-first --tree"

# Tmux
alias  tas="tmux attach -d"
alias  trs="tmux rename-session"
alias  trw="tmux rename-window"

# Neovim
alias  inv='nvim $(fzf -m)'
alias  vim="nvim"
alias   nv="nvim"
alias    v="nvim"
