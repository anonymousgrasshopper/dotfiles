# general environment variables
export PATH=/usr/local/texlive/2024/bin/x86_64-linux:$PATH
export LANG=en_US.UTF-8
export EDITOR="nvim"
export SUDO_EDITOR=$EDITOR
export BROWSER="/mnt/c/Program Files/Mozilla Firefox/firefox.exe"

# programs-specific variables
export CPLUS_INCLUDE_PATH=$HOME/Informatique/Library
export PYTHON_HISTORY=$HOME/.local/state/python/history
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep.conf
export NPM_CONFIG_USERCONFIG=$HOME/.config/npm/npmrc
export WGETRC=$HOME/.config/wget/wgetrc
export RANGER_LOAD_DEFAULT_RC=false

# XDG environment variables
export XDG_CONFIG_HOME=$HOME/.config

# using bat as man's pager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# setting up graphics in WSL
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
