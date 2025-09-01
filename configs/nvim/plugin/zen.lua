-- Zen mode
vim.api.nvim_create_user_command("Zen", function()
	if vim.api.nvim_get_option_value("laststatus", {}) ~= 0 then
		vim.cmd([=[
			set laststatus=0
			set showtabline=0
			silent ![[ -n $TMUX ]] && tmux set -g status off
		]=])
	else
		vim.cmd([=[
			set laststatus=3
			set showtabline=2
			silent ![[ -n $TMUX ]] && tmux set -g status on
		]=])
	end
end, {})
