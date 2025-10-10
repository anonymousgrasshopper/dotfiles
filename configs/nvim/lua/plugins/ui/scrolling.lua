return {
	"karb94/neoscroll.nvim",
	opts = {
		mappings = {
			"<C-u>", "<C-d>",
			"<C-b>", "<C-f>",
			"<C-y>", "<C-e>",
			"zt", "zz", "zb",
		},
		hide_cursor = false,
		stop_eof = true,
		respect_scrolloff = false,
		cursor_scrolls_alone = true,
		duration_multiplier = 1.0,
		easing = "sine",
		pre_hook = nil,
		post_hook = nil,
		performance_mode = false,
		ignored_events = {
			"WinScrolled",
			-- "CursorMoved",
		},
	},
}
