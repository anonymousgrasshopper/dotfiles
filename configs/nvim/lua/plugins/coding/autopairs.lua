return {
	{
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		branch = "v0.6",
		opts = {
			filetype = {
				nft = {
					"TelescopePrompt",
					"grug-far",
				},
			},
			fastwarp = {
				multi = true,
				{},
				{ faster = true, map = "<C-A-e>", cmap = "<C-A-e>" },
			},
			extensions = {
				-- Improve performance when typing fast, see
				-- https://github.com/altermo/ultimate-autopair.nvim/issues/74
				utf8 = false,
				cond = {
					cond = {
						function(fn, o)
							if fn.get_mode == "R" then -- disable in replace mode
								return false
							end
							local line = vim.api.nvim_get_current_line()
							local col = vim.api.nvim_win_get_cursor(0)[2]
							if
								vim.tbl_contains({ "markdown", "tex" }, vim.bo.filetype)
								and line:sub(col - 5, col):match("\\left")
							then
								return false
							end
							if o.key == "[" and vim.tbl_contains({ "bash", "zsh", "sh" }, vim.bo.filetype) then
								if line:sub(1, col):match("if%s+$") or
									 line:sub(1, col):match("while%s+$")
								then
									return false
								end
							end
							if o.key ~= vim.api.nvim_replace_termcodes("<bs>", true, true, true) then
								return true -- return true, unless we've hit backspace
							else
								if
									vim.tbl_contains(
										{ '""', "()", "[]", "{}", "''", "<>", "$$", "**", "~~", "``" },
										line:sub(col - 1, col)
									)
								then
									return false -- if the two characters before the cursor are paired, don't remove them
								end
							end
							return true
						end,
					},
				},
			},
			{ "\\(", "\\)", newline = true },
			{ "\\{", "\\}", newline = true },
			{ "\\[", "\\]", newline = true },
			{ "<", ">", disable_start = true, disable_end = true },
			-- comments
			{ "/*", "*/", ft = { "c", "cpp", "css", "go" }, newline = true, space = true },
			{ "[=[", "]=]", ft = { "lua" } },
			{ "[==[", "]==]", ft = { "lua" } },
			{ "[===[", "]===]", ft = { "lua" } },
			-- filetype-specific
			{ "$", "$", ft = { "tex", "markdown" } },
			{ "$$", "$$", ft = { "markdown" } },
			{ "*", "*", ft = { "markdown" } },
			{ "**", "**", ft = { "markdown" } },
			{ "~~", "~~", ft = { "markdown" } },
			{ "```", "```", ft = { "markdown" }, newline = true },
			{ "[[", "]]", ft = { "bash", "zsh", "sh", "markdown" } },
			{ "<Cmd>", "<CR>", ft = { "lua" }, disable_start = true, disable_end = true },
			-- LaTeX
			{
				"\\begin{bmatrix}",
				"\\end{bmatrix}",
				newline = true,
				space = true,
				ft = { "markdown", "tex" },
			},
			{
				"\\begin{pmatrix}",
				"\\end{pmatrix}",
				newline = true,
				space = true,
				ft = { "markdown", "tex" },
			},
		},
	},
	{
		"windwp/nvim-ts-autotag",
		ft = {
			"astro",
			"glimmer",
			"handlebars",
			"html",
			"javascript",
			"jsx",
			"liquid",
			"markdown",
			"php",
			"rescript",
			"svelte",
			"tsx",
			"twig",
			"typescript",
			"vue",
			"xml",
		},
		opts = {},
	},
}
