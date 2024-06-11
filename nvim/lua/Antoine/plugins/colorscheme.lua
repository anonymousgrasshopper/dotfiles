return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup()
		vim.cmd("colorscheme catppuccin")
		local mocha = require("catppuccin.palettes").get_palette("mocha")
		require("catppuccin").setup({
			integrations = {
				alpha = true,
				indent_blankline = {
					enabled = true,
					scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
					colored_indent_levels = false,
				},
				cmp = true,
				mason = true,
				nvimtree = true,
				treesitter = true,
				telescope = {
					enabled = true,
				},
				which_key = true,
			},
		})
	end,
}
