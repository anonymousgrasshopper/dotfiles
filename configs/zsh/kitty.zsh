KITTY_SOCKET=$(echo $KITTY_LISTEN_ON)

function kitty_set_spacing() {
	[[ -z "$NVIM" && -z "$TMUX" && -n "$KITTY_SOCKET" ]] &&
		kitty @ --to $KITTY_SOCKET set-spacing padding=20 margin=0
}
function kitty_remove_spacing() {
	[[ -z "$NVIM" && -z "$TMUX" && -n "$KITTY_SOCKET" ]] &&
		kitty @ --to $KITTY_SOCKET set-spacing padding=0 margin=0
}

kitty_set_spacing

function nvim() {
	kitty_remove_spacing
	/bin/nvim "$@"
	kitty_set_spacing
}
function tmux() {
	kitty_remove_spacing
	/bin/tmux "$@"
	kitty_set_spacing
}
function yazi() {
	kitty_remove_spacing
	/bin/yazi "$@"
	kitty_set_spacing
}
function lazygit() {
	kitty_remove_spacing
	/bin/lazygit "$@"
	kitty_set_spacing
}
function btop() {
	kitty_remove_spacing
	/bin/btop "$@"
	kitty_set_spacing
}
function man() {
	kitty_remove_spacing
	/bin/man "$@"
	kitty_set_spacing
}
function ncdu() {
	kitty_remove_spacing
	/bin/ncdu "$@"
	kitty_set_spacing
}
function neomutt() {
	kitty_remove_spacing
	TERM=xterm-direct /bin/neomutt "$@"
	kitty_set_spacing
}
function cxxmatrix() {
	kitty_remove_spacing
	/bin/cxxmatrix "$@"
	kitty_set_spacing
}
