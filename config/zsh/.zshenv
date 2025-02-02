##################################################################
############################# ZSHENV #############################
##################################################################

# general environment variables
export LANG=en_US.UTF-8
export EDITOR="nvim"
export SUDO_EDITOR=$EDITOR
export BROWSER="/mnt/c/Program Files/Mozilla Firefox/firefox.exe"

# programs-specific variables
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
export CPLUS_INCLUDE_PATH=$HOME/Informatique/Library

export PYTHON_HISTORY=$HOME/.local/state/python/history
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep.conf
export NPM_CONFIG_USERCONFIG=$HOME/.config/npm/npmrc
export FZF_DEFAULT_OPTS_FILE=~/.config/fzf.conf
export WGETRC=$HOME/.config/wget/wgetrc
export GOPATH=$HOME/.local/share/go

# Path
export PATH=/usr/local/texlive/2024/bin/x86_64-linux:$PATH

# XDG environment variables
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DOWNLOAD_DIR="$HOME/Téléchargements"

# WSL graphics
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0

# Aliases
source ~/.config/zsh/aliases.zsh
