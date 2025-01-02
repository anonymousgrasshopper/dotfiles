# For a full list of active aliases, run `alias`.

# Commands
alias :q="exit"
alias :qa="exit"
alias rm="rm -i"
alias grep="grep --color=auto"
alias diff="diff --color=auto"

alias cd="z"
alias cat="bat"
alias find="fd"

alias ls="exa --group-directories-first"
alias ll="exa --group-directories-first -alh"
alias tree="exa --group-directories-first --tree"

alias fzf='fzf --preview="bat {}"'
alias inv='nvim $(fzf -m --preview="bat {}")'

# Programs
alias firefox="/mnt/c/Program\ Files/Mozilla\ Firefox/firefox.exe"
alias python="python3"
alias py="python3"

# Tmux
alias tas="tmux attach -d"
alias trs="tmux rename-session"
alias trw="tmux rename-window"

# nvim aliases
alias nivm="nvim"
alias nviù="nvim"
alias nvil="nvim"
alias vim="nvim"
alias nv="nvim"
