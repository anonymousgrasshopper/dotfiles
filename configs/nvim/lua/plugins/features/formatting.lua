vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting for all buffers
		vim.g.disable_autoformat = true
	else
		vim.b.disable_autoformat = true
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

local function search_parent_dirs(arg)
	local dir = vim.fn.expand("%:p:h")
	while dir ~= "/" and dir ~= "" do
		for _, fname in ipairs(arg.names) do
			local candidate = dir .. "/" .. fname
			if vim.uv.fs_stat(candidate) and vim.uv.fs_stat(candidate).type == "file" then
				return candidate
			end
		end
		dir = vim.fn.fnamemodify(dir, ":h")
	end
	return vim.env.HOME .. "/" .. arg.fallback
end

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
	opts = {
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
				args = function()
					return "--style=file:"
						.. search_parent_dirs({
							names = { ".clang-format" },
							fallback = ".config/formatters/clang-format",
						})
				end,
			},
			tex_fmt = {
				command = "tex-fmt",
				args = function()
					return {
						"--config",
						search_parent_dirs({
							names = { "tex-fmt.toml" },
							fallback = ".config/formatters/tex-fmt.toml",
						}),
						"--stdin",
					}
				end,
			},
			stylua = {
				command = "stylua",
				prepend_args = function()
					return {
						"--config-path",
						search_parent_dirs({
							names = { ".stylua.toml", "stylua.toml" },
							fallback = ".config/formatters/stylua.toml",
						}),
					}
				end,
			},
			prettier = {
				command = "prettier",
				prepend_args = { "--use-tabs" },
			},
		},
		format_on_save = function(bufnr)
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
				"nvim/lua/snippet/",
				"nvim/snippets/",

				"texmf/tex/latex",
			}
			for _, path in ipairs(disabled_paths) do
				if vim.api.nvim_buf_get_name(0):match(path) then
					return
				end
			end

			return { timeout_ms = 500, lsp_format = "fallback" }
		end,
	},
}
