return {
	"abecodes/tabout.nvim",
	event = "InsertEnter", -- InsertCharPre doesn't work
	-- dependencies:
	--  nvim-treesitter/nvim-treesitter
	opts = {
		tabkey = "<Tab>",
		backwards_tabkey = "<S-Tab>",
		act_as_tab = true,
		act_as_shift_tab = true,
		default_tab = "<C-t>",
		default_shift_tab = "<C-d>",
		enable_backwards = true,
		completion = true,
		tabouts = {
			{ open = "'", close = "'" },
			{ open = '"', close = '"' },
			{ open = "`", close = "`" },
			{ open = "(", close = ")" },
			{ open = "[", close = "]" },
			{ open = "{", close = "}" },
		},
		ignore_beginning = false,
		exclude = {},
	},
}
