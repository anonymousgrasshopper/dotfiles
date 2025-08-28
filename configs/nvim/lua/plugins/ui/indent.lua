return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = {
			char = "│",
			highlight = "Indent",
		},
		scope = {
			show_start = false,
			show_end = false,
			highlight = "IndentScope",
		},
		exclude = {
			filetypes = {
				"undotree",
			},
		},
	},
}
