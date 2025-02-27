###################################################################################################
############################################# Aliases #############################################
###################################################################################################

# shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias q="exit"
alias c="clear"
alias -- +x="chmod +x"
alias rmpkg="sudo pacman -Rns"
alias sypkg="sudo pacman -S"
alias fetch="fastfetch"
alias lg="lazygit"
alias py="python3"

# miscellaneous
cfd() {
  cd $(fd . -td | fzf -m --query="$1")
}
alias sudo="sudo "                  # enable aliases in sudo
alias path='echo -e ${PATH//:/\\n}' # human-readable path

# CLI tools default options
alias rm="rm -i"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias fzf="fzf --preview='/usr/local/bin/fzf_preview_wrapper {}'"
# 󱞽 not in fzf.conf because it would also apply to fzf-tab and always enable its preview

# CLI tools replacements
alias cat="bat"
alias top="btop"

alias ls="eza --icons=always --group-directories-first --no-quotes"
alias ll="eza --icons=always --group-directories-first --no-quotes -lh"
alias llg="eza --icons=always --group-directories-first --no-quotes -lh --git"
alias lla="eza --icons=always --group-directories-first --no-quotes -alh"
alias llag="eza --icons=always --group-directories-first --no-quotes -alh --git"
alias tree="eza --icons=always --group-directories-first --no-quotes --tree"

# Neovim
nfd() {
  nvim $(fzf -m --select-1 --exit-0 --query="$1")
}
alias vim="nvim"
alias nv="nvim"
alias v="nvim"

# Tmux
alias tls="tmux list-session"
alias trs="tmux rename-session"
alias trw="tmux rename-window"
tns() {
  if [[ $# == 0 ]]; then
    tmux new-session
  else
    tmux new-session -s"$1"
  fi
}
tas() {
  [[ -z TMUX ]] && command="switch-client" || command="attach-session"
  tmux $command -t$(tmux list-session | fzf --preview='' --select-1 --exit-0 --query="$1" | sed 's/:.*//')
}
tmux_choose_pane() {
  local panes current_window current_pane target target_window target_pane
  panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
  current_pane=$(tmux display-message -p '#I:#P')
  current_window=$(tmux display-message -p '#I')

  target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse --preview='') || return

  target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
  target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

  if [[ $current_window -eq $target_window ]]; then
    tmux select-pane -t ${target_window}.${target_pane}
  else
    tmux select-pane -t ${target_window}.${target_pane} &&
      tmux select-window -t $target_window
  fi
}

# help command using bat
help() {
  "$@" --help 2>&1 | bat --plain --language=help
}

# wrapper around yazi to change cwd when exiting it
function x() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
