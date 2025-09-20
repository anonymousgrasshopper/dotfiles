return {
	{
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		branch = "v0.6",
		opts = function()
			local typst = {}
			typst.in_text = function(fn) return not fn.in_node({ "math", "raw_span", "raw_blck", "string" }) end

			return {
				filetype = {
					nft = {
						"TelescopePrompt",
						"grug-far",
					},
				},
				space2 = { enable = true }, -- symmetric space in pairs
				close = { enable = true }, -- use <A-)> to close open pairs
				fastwarp = {
					multi = true,
					{},
					{ faster = true, map = "<C-A-e>", cmap = "<C-A-e>" },
				},
				extensions = {
					utf8 = false, -- see https://github.com/altermo/ultimate-autopair.nvim/issues/74
					cond = {
						cond = {
							function(fn, o)
								if fn.get_mode() == "R" then -- disable in replace mode
									return false
								end
								local line, col, ft = o.line, o.col, fn.get_ft()
								local function table_convert(arg) return type(arg) == "table" and arg or { arg } end
								local conds = {
									{
										vim.api.nvim_replace_termcodes("<bs>", true, true, true),
										"*",
										col - 2,
										{ '""', "()", "[]", "{}", "''", "<>", "$$", "**", "~~", "``" },
									}, -- if the two characters before the cursor are paired, don't remove them
									{
										vim.api.nvim_replace_termcodes("<bs>", true, true, true),
										"tex",
										col - 4,
										{ "\\(\\)", "\\[\\]" },
									}, -- if the two characters before the cursor are paired, don't remove them
									-- snippets
									{ "*", { "markdown", "tex" }, col - 6, "\\left" },
									{ "[", { "bash", "zsh", "sh" }, 1, { "if%s+$", "while%s+$" }, regex = true },
									{ "(", "cpp", col - 5, "%Wall", regex = true },
									{ "(", "lua", col - 9, "function" },
								}
								for _, cond in ipairs(conds) do
									if cond[1] == "*" or cond[1] == o.key then
										if cond[2] == "*" or vim.tbl_contains(table_convert(cond[2]), ft) then
											local text = line:sub(cond[3], col - 1)
											local patterns = table_convert(cond[4])
											for _, pattern in ipairs(patterns) do
												if cond.regex and text:match(pattern) or text == pattern then
													return false
												end
											end
										end
									end
								end

								return true
							end,
						},
					},
				},
				{ "<", ">", disable_start = true },
				-- comments
				{ "/*", "*/", ft = { "c", "cpp", "css", "go" }, newline = true, space = true },
				{ "[=[", "]=]", ft = { "lua" } },
				{ "[==[", "]==]", ft = { "lua" } },
				{ "[===[", "]===]", ft = { "lua" } },
				-- LaTeX
				{ "\\[", "\\]", disable_end = true, newline = true, ft = { "tex" } },
				{ "\\(", "\\)", disable_end = true, newline = true, ft = { "tex" } },
				-- typst
				{ "$", "$", ft = { "typst" }, cond = typst.in_text, space = true },
				{ "/*", "*/", ft = { "typst" }, cond = typst.in_text },
				{ "*", "*", ft = { "typst" }, cond = typst.in_text },
				{ "_", "_", ft = { "typst" }, cond = typst.in_text },
				{ "`", "`", ft = { "typst" }, cond = typst.in_text, space = true },
				{ "```", "```", ft = { "typst" }, cond = typst.in_text, space = true, newline = true },
				--markdown
				{ "$", "$", ft = { "markdown" } },
				{ "$$", "$$", ft = { "markdown" } },
				{ "*", "*", ft = { "markdown" } },
				{ "**", "**", ft = { "markdown" } },
				{ "~~", "~~", ft = { "markdown" } },
				{ "```", "```", ft = { "markdown" }, newline = true },
				-- others
				{ "[[", "]]", ft = { "bash", "zsh", "sh", "markdown" } },
				{ "<Cmd>", "<CR>", ft = { "lua" } },
			}
		end,
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
