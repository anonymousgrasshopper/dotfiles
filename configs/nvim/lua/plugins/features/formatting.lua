return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>fmt",
			function()
				require("conform").format({
					async = true,
				})
			end,
			mode = { "n", "v" },
			desc = "Format file or range (in visual mode)",
		},
	},
	opts = function()
		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})

		return {
			formatters_by_ft = {
				cpp = { "clang_format" },
				tex = { "tex_fmt" },
				lua = { "stylua" },
				bash = { "shfmt" },
				sh = { "shfmt" },
				css = { "prettier" },
				js = { "prettier" },

				["*"] = { "trim_whitespace", "trim_newlines" },
			},
			formatters = {
				clang_format = {
					command = "clang-format",
					args = "--style=file:$HOME/.config/formatters/clang-format",
				},
				tex_fmt = {
					command = "tex-fmt",
					args = { "--config", vim.env.HOME .. "/.config/formatters/tex-fmt.toml", "--stdin" },
				},
				stylua = {
					command = "stylua",
					prepend_args = { "--config-path", vim.env.HOME .. "/.config/formatters/stylua.toml" },
				},
				prettier = {
					command = "prettier",
					prepend_args = { "--use-tabs" },
				},
			},
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end

				local disabled_paths = {
					"nvim/lua/config/options.lua",
					"nvim/lua/plugins/editor/telescope.lua",
					"nvim/lua/plugins/coding/autopairs.lua",
					"nvim/lua/plugins/coding/telescope.lua",
					"nvim/lua/plugins/features/debugging.lua",
					"nvim/lua/plugins/lang/markdown.lua",
					"nvim/lua/plugins/util/browsing.lua",
					"nvim/lua/plugins/util/unix.lua",
				}
				for _, path in ipairs(disabled_paths) do
					if vim.api.nvim_buf_get_name(0):match(path) then
						return
					end
				end

				return { timeout_ms = 1000, lsp_format = "fallback" }
			end,
		}
	end,
}
