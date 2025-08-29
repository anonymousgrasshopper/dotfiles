local vim_enter_early_redraw = function()
	-- Skip if we already entered vim
	if vim.v.vim_did_enter == 1 then
		return
	end

	local buf = vim.api.nvim_get_current_buf()

	-- Try to guess the filetype (may change later on during Neovim startup)
	local ft = vim.filetype.match({ buf = buf })

	if ft then
		-- Add treesitter highlights and fallback to syntax
		local lang = vim.treesitter.language.get_lang(ft)

		-- find filetype icon and color
		require("nvim-web-devicons").setup()
		local icon, color = require("nvim-web-devicons").get_icon_color(vim.fn.expand("%"), vim.fn.expand("%:e"))
		vim.g.statusline_filetype_icon = icon or " "
		vim.cmd("hi StatusLineIconColor guifg=" .. (color or "#6D8086"))

		-- setup mock statusline
		vim.opt.statusline = "%#StatusLineBlue# NORMAL %* %F %#StatusLineIconColor#%{g:statusline_filetype_icon}%="
			.. '%#StatusLineSeparatorGrey#%#StatusLineGrey# %p%%  %l:%c %#StatusLineSeparatorBlue#%#StatusLineBlue#  %{strftime("%H:%M")} '

		if
			not vim.tbl_contains({ "tex", "markdown", "zsh" }, ft)
			and not (lang and pcall(vim.treesitter.start, buf, lang))
		then
			vim.bo[buf].syntax = ft
		end

		-- Trigger early redraw
		vim.cmd([[redraw]])
	end
end

return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			compile = true,
			overrides = function(colors)
				local theme = colors.theme
				local palette = colors.palette
				return {
					-- syntax highlighting
					Boolean = { bold = false },

					-- user interface
					NormalFloat = { bg = "none" },
					FloatBorder = { bg = "none" },
					FloatTitle = { bg = "none" },

					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
					PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },

					StatusLine = { fg = palette.springViolet2, bg = palette.sumiInk4 },
					StatusLineBlue = { fg = palette.sumiInk4, bg = palette.crystalBlue },
					StatusLineGrey = { fg = palette.springViolet2, bg = palette.sumiInk6 },
					StatusLineSeparatorBlue = { fg = palette.crystalBlue, bg = palette.sumiInk6 },
					StatusLineSeparatorGrey = { fg = palette.sumiInk6, bg = palette.sumiInk4 },

					Search = { fg = palette.oldWhite, bg = palette.waveBlue2 },
					Folded = { fg = palette.springViolet1, bg = palette.sumiInk3 },
					WinSeparator = { fg = palette.sumiInk6 },
					PanelHeading = { fg = palette.autumnYellow, bg = palette.sumiInk4 },

					NormalDark = { bg = palette.sumiInk1 },
					TerminalBackground = { bg = palette.sumiInk0 },

					Indent = { fg = palette.sumiInk6 },
					IndentScope = { fg = palette.springViolet2 },

					-- plugins
					markdownH1 = { fg = "#ff5d62" },
					markdownH2 = { fg = "#ffa066" },
					markdownH3 = { fg = "#e6c384" },
					markdownH4 = { fg = "#98bb6c" },
					markdownH5 = { fg = "#7fb4ca" },
					markdownH6 = { fg = "#957fb8" },

					MarkdownInfo = { fg = "#7e9cd8" },
					MarkdownSuccess = { fg = "#98bb6c" },
					MarkdownWarn = { fg = "#ff9e3b" },
					MarkdownError = { fg = "#e82424" },
					MarkdownHint = { fg = "#6a9589" },
					MarkdownQuote = { fg = "#957fb8" },

					MarkdownTable = { fg = "#54546d" },

					IlluminatedWordText = { bold = true },
					IlluminatedWordRead = { bold = true },
					IlluminatedWordWrite = { bold = true },

					NeoTreeWinSeparator = { fg = palette.sumiInk3 },
					NeoTreePopupWinSeparator = { fg = palette.sumiInk6, bg = palette.sumiInk3 },
					NeoTreeFileIcon = { fg = palette.oldWhite },

					HlSearchLens = { fg = palette.fujiGray, bg = "none" },
					HlSearchLensNear = { fg = palette.oldWhite, bg = palette.waveBlue2 },
					HlSearchLensNearReverted = { fg = palette.waveBlue2, bg = "none" },

					LazyNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

					TelescopePromptPrefix = { fg = palette.autumnYellow, bg = palette.sumiInk3 },

					LightBulbSign = { fg = palette.oldWhite },
				}
			end,
			colors = {
				palette = {}, -- change all usages of these colors
				theme = {
					all = {
						ui = {
							bg_gutter = "none",
						},
					},
				},
			},
		})
		vim.cmd("colorscheme kanagawa-wave")
		vim_enter_early_redraw()
	end,
}
