return{}
-- return {
-- 	{
-- 		"williamboman/mason.nvim",
--     dependencies = {
--     }
-- 		lazy = false,
-- 		config = function()
-- 			require("mason").setup()
-- 		end,
-- 	},
-- 	{
-- 		"williamboman/mason-lspconfig.nvim",
-- 		lazy = false,
-- 		opts = {
-- 			auto_install = true,
-- 		},
-- 	},
--
-- 	{
-- 		"neovim/nvim-lspconfig",
-- 		lazy = false,
-- 		config = function()
-- 			local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- 			local lspconfig = require("lspconfig")
--
-- 			lspconfig.clangd.setup({
-- 				capabilities = capabilities,
-- 			})
-- 			lspconfig.lua_ls.setup({
-- 				capabilities = capabilities,
-- 			})
--
-- 			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
-- 			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
-- 			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
-- 			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
-- 		end,
-- 	},
-- }



-- return {
-- 	"williamboman/mason.nvim",
-- 	dependencies = {
-- 		"williamboman/mason-lspconfig.nvim",
-- 		"WhoIsSethDaniel/mason-tool-installer.nvim",
-- 	},
-- 	config = function()
-- 		local mason = require("mason")
-- 		local mason_lspconfig = require("mason-lspconfig")
-- 		local mason_tool_installer = require("mason-tool-installer")
--
-- 		mason.setup({
-- 			ui = {
-- 				icons = {
-- 					package_installed = "✓",
-- 					package_pending = "➜",
-- 					package_uninstalled = "✗",
-- 				},
-- 			},
-- 		})
--
-- 		mason_lspconfig.setup({
-- 			-- list of servers for mason to install
-- 			ensure_installed = {
-- 				"clangd",
--         "clang-format",
-- 				"lua_ls",
-- 			},
-- 		})
--
-- 		mason_tool_installer.setup({
-- 			ensure_installed = {
-- 				--"clang_format", -- C++ formatter
-- 				"stylua", -- lua formatter
-- 				"isort", -- python formatter
-- 				"black", -- python formatter
-- 				"prettier", -- prettier formatter
-- 			},
-- 		})
-- 	end,
-- }
