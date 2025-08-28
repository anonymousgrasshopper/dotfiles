return {
	"rebelot/heirline.nvim",
	-- dependencies:
	-- 	nvim-tree/nvim-web-devicons
	event = "VeryLazy",
	config = function()
		local utils = require("heirline.utils")
		local palette = require("kanagawa.colors").setup().palette

		vim.api.nvim_create_autocmd("BufEnter", {
			callback = function()
				if vim.bo.filetype == "alpha" then
					vim.opt.laststatus = 0
				else
					vim.opt.laststatus = 3
				end
			end,
		})

		require("heirline").load_colors({
			blue = palette.crystalBlue,
			green = palette.springGreen,
			violet = palette.oniViolet,
			yellow = palette.autumnYellow,
			red = palette.autumnRed,
			grey = palette.sumiInk6,
			fg = palette.springViolet2,
			bg = palette.sumiInk4,
			inactive_bg = palette.sumiInk0,
			orange = palette.roninYellow,
		})

		require("heirline").setup({
			statusline = require("statusline"),
			opts = {},
		})
	end,
}
