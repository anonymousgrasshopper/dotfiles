return {
	"rebelot/heirline.nvim",
	-- dependencies:
	-- 	nvim-tree/nvim-web-devicons
	event = "VeryLazy",
	config = function()
		local palette = require("kanagawa.colors").setup().palette

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
