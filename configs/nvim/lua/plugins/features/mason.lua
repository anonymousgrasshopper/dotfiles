return {
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog", "MasonUninstallAl" },
		config = function()
			local mason = require("mason")

			mason.setup({
				ui = {
					icons = {
						package_installed = " ",
						package_pending = "➜ ",
						package_uninstalled = "✗",
					},
				},
			})

			vim.cmd([[autocmd Filetype mason setlocal nocursorline]])
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		cmd = {
			"MasonToolsInstall",
			"MasonToolsInstallSync",
			"MasonToolsUpdate",
			"MasonToolsUpdateSync",
			"MasonToolsClean",
		},
		opts = {
			ensure_installed = {
				"codelldb",
				"clangd",
				"clang-format",
				"lua_ls",
				"stylua",
				"bashls",
				"shellcheck",
				"shfmt",
				"texlab",
				"tex-fmt",
				"asm_lsp",
				"prettier",
			},
		},
	},
}
