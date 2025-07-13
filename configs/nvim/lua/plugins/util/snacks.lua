return {
	"anonymousgrasshopper/snacks.nvim",
	priority = 1001,
	opts = {
		bigfile = {},
		bufdelete = {},
		image = {},
		indent = {
			char = "│", -- ┊
			hl = "Indent",
			animate = { enabled = false },
			scope = {
				char = "│", -- ┊
				hl = "IndentScope",
				only_current = true,
			},
			filter = function(buf)
				return vim.bo[buf].buftype == "" and not vim.tbl_contains({ "undotree" }, vim.bo[buf].buftype)
			end,
		},
		rename = {},
		scroll = {},
	},
}
