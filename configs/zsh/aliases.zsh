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
alias -- +x="chmod u+x"

# miscellaneous
cfd() {
  cd "$(fd . -td | fzf --no-multi --query="$1")"
}
mkcd() {
  [[ $# == 0 ]] && echo "mkcd: missing operand"
  [[ $# -ge 2 ]] && echo "mkcd: too many operands"
  [[ $# == 1 ]] || return 1
  mkdir -p "$1" && cd "$1"
}
run() {
  [[ $# == 0 ]] && { echo "run: missing operand"; return 1 }
  command="$1"
  shift
  nohup "$command" "$@" >/dev/null 2>&1 &
}
alias sudo="sudo "                  # enable aliases in sudo
alias path='echo -e ${PATH//:/\\n}' # human-readable path

# rm that only asks for confirmation for nonempty files
alias rm=rm_confirm_nonempty
rm_confirm_nonempty() {
  args=()
  items=()
  while (("$#")); do
    if [[ "$1" =~ ^- ]]; then
      args+=("$1")
    else
      items+=("$1")
    fi
    shift
  done
  for element ("$items[@]"); do
    if [[ -e "$element" && ! -s "$element" ]]; then
      command rm -f "${args[@]}" "$element"
    else
      command rm -i "${args[@]}" "$element"
    fi
  done
}

# help command using bat
help() {
  "$@" --help 2&1 | bat --plain --language=help
}

# Usage: far /path/to/directory/ "regexp" "replacement"
far() {
  sed -i -e "s@$2@$3@g" "$(rg "$2" "$1" -l --fixed-strings)"
}

# CLI tools default options
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias fzf="fzf --preview='/usr/local/bin/fzf_preview_wrapper {}'"

# programs
alias cat="bat"
alias top="btop"
alias fetch="fastfetch"
alias lg="lazygit"
alias py="python3"
alias mutt="neomutt"
alias m="neomutt"

# eza
alias ls="eza --icons=always --group-directories-first --no-quotes"
alias l="eza --icons=always --group-directories-first --no-quotes -a"
alias ll="eza --icons=always --group-directories-first --no-quotes -alh"
alias llg="eza --icons=always --group-directories-first --no-quotes -lh --git"
alias llag="eza --icons=always --group-directories-first --no-quotes -alh --git"
alias tree="eza --icons=always --group-directories-first --no-quotes --tree"

# git
clone() {
  git clone "https://github.com/$1"
}
alias commit="git commit"
alias push="git push"
gacp() {
  git add .
  git commit -m "$@"
  git push
}
gitdot() {
  if [[ $# == 0 ]]; then
    /usr/local/bin/git_dotfiles && cd ~/.config/dotfiles && lazygit && cd - >/dev/null
  else
    /usr/local/bin/git_dotfiles $@
  fi
}

# neovim
nfd() {
  nvim "$(fzf -m --select-1 --query="$*")"
}
alias vim="nvim"
alias nv="nvim"
alias v="nvim"

# pacman
alias rmpkg="sudo pacman -Rns"
alias sypkg="sudo pacman -S"
alias pacmanclean='sudo pacman -Rns $(pacman -Qtdq)'

# tmux
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
  if [[ -n "$TMUX" ]]; then
    command="switch-client"
  elif ! /bin/tmux run 2>/dev/null; then
    tns "$@"
    exit
  else
    command="attach-session"
  fi
  tmux $command -t"$(/bin/tmux list-session | fzf --preview='' --select-1 --query="$1" | sed 's/:.*//')"
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

# yazi
function x() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  /bin/rm -f -- "$tmp"
}

# zathura 
alias zathura="run zathura"
