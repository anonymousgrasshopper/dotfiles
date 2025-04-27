KITTY_SOCKET=$(echo $KITTY_LISTEN_ON)

kitty_set_spacing() {
	[[ -z "$NVIM" && -z "$TMUX" && -n "$KITTY_SOCKET" ]] &&
		kitty @ --to $KITTY_SOCKET set-spacing padding=20 margin=0
}
kitty_remove_spacing() {
	[[ -z "$NVIM" && -z "$TMUX" && -n "$KITTY_SOCKET" ]] &&
		kitty @ --to $KITTY_SOCKET set-spacing padding=0 margin=0
}

kitty_set_spacing

nvim() {
	kitty_remove_spacing >/dev/null
	export NVIM_PADDING_REMOVED=true
	/bin/nvim "$@"
	unset NVIM_PADDING_REMOVED
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
neomutt() {
	kitty_remove_spacing
	TERM=xterm-direct /bin/neomutt "$@"
	kitty_set_spacing
}
cxxmatrix() {
	kitty_remove_spacing
	/bin/cxxmatrix "$@"
	kitty_set_spacing
}
