return {
	"junegunn/vim-easy-align",
	dependencies = {
		"tpope/vim-repeat",
	},
	keys = {
		{ "gL", "<Plug>(EasyAlign)", mode = { "n", "v" }, desc = "Align text interactively" },
		{ "gl", "<Plug>(LiveEasyAlign)", mode = { "n", "v" }, desc = "Align text live interactively" },
	},
	config = function()
		vim.g.easy_align_bypass_fold = 1
	end,
}
