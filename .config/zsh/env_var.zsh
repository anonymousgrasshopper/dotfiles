# general environment variables
export PATH=/usr/local/texlive/2024/bin/x86_64-linux:$PATH
export CPLUS_INCLUDE_PATH=$HOME/Informatique/Library
export LANG=en_US.UTF-8
export EDITOR="nvim"
export BROWSER="/mnt/c/Program Files/Mozilla Firefox/firefox.exe"

# programs-specific variables
export PYTHON_HISTORY=$HOME/.local/state/python/history
export NPM_CONFIG_USERCONFIG=$HOME/.config/npm/npmrc
export WGETRC="$HOME/.config/wget/wgetrc"
export RANGER_LOAD_DEFAULT_RC=false

# setting up graphics in WSL
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
