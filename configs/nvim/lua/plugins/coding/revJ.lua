return {
	"AckslD/nvim-trevJ.lua",
	keys = {
		{
			"<leader>j",
			function()
				require("trevj").format_at_cursor()
			end,
			desc = "reverse J operator",
		},
	},
	opts = {},
}
