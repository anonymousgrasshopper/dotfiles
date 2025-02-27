TERMINAL_PADDING=20

kitty_set_spacing() {
  [[ ! -n "$NVIM" && ! -n "$TMUX" ]] && kitty @set-spacing margin="$TERMINAL_PADDING"
}
kitty_remove_spacing() {
  [[ ! -n "$NVIM" && ! -n "$TMUX" ]] && kitty @set-spacing margin=0
}

kitty_set_spacing

nvim() {
  kitty_remove_spacing
  /bin/nvim "$@"
  kitty_set_spacing
}
tmux() {
  kitty_remove_spacing
  /bin/tmux "$@"
  kitty_set_spacing
}
yazi() {
  kitty_remove_spacing
  /bin/yazi "$@"
  kitty_set_spacing
}
lazygit() {
  kitty_remove_spacing
  /bin/lazygit "$@"
  kitty_set_spacing
}
btop() {
  kitty_remove_spacing
  /bin/btop "$@"
  kitty_set_spacing
}
man() {
  kitty_remove_spacing
  /bin/man "$@"
  kitty_set_spacing
}
ncdu() {
  kitty_remove_spacing
  /bin/ncdu "$@"
  kitty_set_spacing
}
