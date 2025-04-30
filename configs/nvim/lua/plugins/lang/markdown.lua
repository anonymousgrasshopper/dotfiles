return {
	{
		"OXY2DEV/markview.nvim",
		ft = "markdown",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = function()
			local presets = require("markview.presets")

			return {
				markdown = {
					headings = presets.headings.glow,
					list_items = {
						shift_width = function(buffer, item)
							local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth)
							return item.indent * (1 / (parent_indnet * 2))
						end,
						marker_minus = {
							add_padding = function(_, item) return item.indent > 1 end,
						},
					},
				},
				markdown_inline = {
					checkboxes = {
						checked = { text = "󰄲", hl = "MarkviewCheckboxChecked", scope_hl = "MarkviewCheckboxChecked" },
						unchecked = { text = "", hl = "MarkviewCheckboxUnchecked", scope_hl = "MarkviewCheckboxUnchecked" },
					},
				},
				latex = {
					enable = true, -- overrides vimtex's conceal, but disabling it results in the latex being hidden
				},
				preview = {
					icon_provider = "devicons",
				},
			}
		end,
	},
	{
		"bullets-vim/bullets.vim",
		ft = "markdown",
	},
}
