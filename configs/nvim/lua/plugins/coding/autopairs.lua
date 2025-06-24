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
							if o.key == vim.api.nvim_replace_termcodes("<bs>", true, true, true) then
								if
									vim.tbl_contains(
										{ '""', "()", "[]", "{}", "''", "<>", "$$", "**", "~~", "``" },
										line:sub(col - 1, col)
									) -- if the two characters before the cursor are paired, don't remove them
								then
									return false
								end
							end
							-- snippets
							if
								(vim.tbl_contains({ "markdown", "tex" }, vim.bo.filetype)
								and line:sub(col - 5, col):match("\\left"))
								or
								(o.key == "[" and vim.tbl_contains({ "bash", "zsh", "sh" }, vim.bo.filetype)
								and (line:sub(1, col):match("if%s+$") or line:sub(1, col):match("while%s+$")))
								or
								(o.key == "(" and vim.bo.filetype == "cpp" and line:sub(col - 4, col):match("%Wall"))
							then
								return false
							end

							return true
						end,
					},
				},
			},
			-- { "\\[", "\\]", newline = true, ft = "tex" },
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
