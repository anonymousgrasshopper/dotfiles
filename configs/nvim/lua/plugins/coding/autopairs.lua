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
							if fn.get_mode() == "R" then -- disable in replace mode
								return false
							end
							local line, col, ft = o.line, o.col, fn.get_ft()
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
								(vim.tbl_contains({ "markdown", "tex" }, ft) and line:sub(col - 5, col):match("\\left"))
								or (o.key == "[" and vim.tbl_contains({ "bash", "zsh", "sh" }, ft) and
								   (line:sub(1, col - 1):match("if%s+$") or line:sub(1, col - 1):match("while%s+$")))
								or (o.key == "(" and ft == "cpp" and line:sub(col - 4, col):match("%Wall"))
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
