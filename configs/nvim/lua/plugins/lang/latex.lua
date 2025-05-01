return {
	"lervag/vimtex",
	config = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_syntax_conceal_disable = false
		vim.g.vimtex_format_enabled = 1
		vim.g.vimtex_mappings_prefix = "<localleader>l"

		vim.g.vimtex_fold_enabled = 1
		vim.g.vimtex_fold_manual = 1
		vim.g.vimtex_fold_types = {
			preamble = { enabled = 1 },
			sections = { enabled = 1 },
			envs = { enabled = 1 },
		}
	end,
}
