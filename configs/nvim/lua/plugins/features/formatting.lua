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

local function search_parent_dirs(bufnr, arg)
	local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), "%:p:h")
	while dir ~= "/" and dir ~= "" do
		for _, fname in ipairs(arg.names) do
			local candidate = dir .. "/" .. fname
			if vim.uv.fs_stat(candidate) and vim.uv.fs_stat(candidate).type == "file" then
				return candidate
			end
		end
		dir = vim.fn.fnamemodify(dir, ":h")
	end
	if arg.fallback then
		return arg.fallback
	else
		local config_file = arg.names[1]
		if config_file:sub(1, 1) == "." then
			config_file = config_file:sub(2, #config_file)
		end
		return (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config"))
			.. "/formatters/"
			.. config_file
	end
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
			lua = { "stylua" },
			bash = { "shfmt" },
			sh = { "shfmt" },
			css = { "prettier" },
			js = { "prettier" },
			tex = function(bufnr)
				require("formatters.tex").format(bufnr)
				return { "tex_fmt" }
			end,

			["*"] = { "trim_whitespace", "trim_newlines" },
		},
		formatters = {
			clang_format = {
				command = "clang-format",
				prepend_args = function()
					return "--style=file:"
						.. search_parent_dirs(vim.api.nvim_get_current_buf(), {
							names = { ".clang-format" },
						})
				end,
			},
			tex_fmt = {
				command = "tex-fmt",
				prepend_args = function()
					return {
						"--config",
						search_parent_dirs(vim.api.nvim_get_current_buf(), {
							names = { "tex-fmt.toml" },
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
						search_parent_dirs(vim.api.nvim_get_current_buf(), {
							names = { ".stylua.toml", "stylua.toml" },
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
				"^" .. vim.fn.stdpath("config") .. "/lua/config/options.lua",
				"^" .. vim.fn.stdpath("config") .. "/lua/plugins/editor/telescope.lua",
				"^" .. vim.fn.stdpath("config") .. "/lua/plugins/coding/autopairs.lua",
				"^" .. vim.fn.stdpath("config") .. "/lua/plugins/coding/telescope.lua",
				"^" .. vim.fn.stdpath("config") .. "/lua/plugins/features/debugging.lua",
				"^" .. vim.fn.stdpath("config") .. "/lua/plugins/features/completions.lua",
				"^" .. vim.fn.stdpath("config") .. "/lua/plugins/lang/markdown.lua",
				"^" .. vim.fn.stdpath("config") .. "/lua/plugins/util/browsing.lua",
				"^" .. vim.fn.stdpath("config") .. "/lua/plugins/util/unix.lua",
				"^" .. vim.fn.stdpath("config") .. "/lua/snippet/",
				"^" .. vim.fn.stdpath("config") .. "/snippets/",

				"^" .. (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/texmf/tex/latex",
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
