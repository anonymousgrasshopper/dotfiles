return {
	"OXY2DEV/markview.nvim",
	ft = { "markdown", "typst" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		-- nvim-tree/nvim-web-devicons
	},
	opts = {
		preview = {
			callbacks = { -- prevent the plugin from doing nonsense with concealcursor and conceallevel
				on_attach = function() end,
				on_detach = function() end,
				on_enable = function() end,
				on_disable = function() end,
				on_hybrid_enable = function() end,
				on_hybrid_disable = function() end,
				on_mode_change = function() end,
				on_splitview_open = function() end,
			},
			icon_provider = "devicons",
			modes = { "n", "no", "c", "i" },
			hybrid_modes = { "n", "no", "c", "i" },
			debounce = 50,
		},
		markdown = {
			enable = false,
			headings = {
				shift_width = 0,
				heading_1 = { icon = "󰼏 ", sign = "", hl = "markdownH1" },
				heading_2 = { icon = "󰼐 ", sign = "", hl = "markdownH2" },
				heading_3 = { icon = "󰼑 ", sign = "", hl = "markdownH3" },
				heading_4 = { icon = "󰼒 ", sign = "", hl = "markdownH4" },
				heading_5 = { icon = "󰼓 ", sign = "", hl = "markdownH5" },
				heading_6 = { icon = "󰼔 ", sign = "", hl = "markdownH6" },
			},
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
			enable = false,
			checkboxes = {
				checked = { text = "󰄲", hl = "MarkviewCheckboxChecked", scope_hl = "MarkviewCheckboxChecked" },
				unchecked = { text = "", hl = "MarkviewCheckboxUnchecked", scope_hl = "MarkviewCheckboxUnchecked" },
			},
		},
		latex = {
			enable = false, -- overrides vimtex's conceal, but disabling it results in the latex being hidden
		},
		typst = {
			headings = {
				shift_width = 0,
				heading_1 = { icon = "󰼏 ", sign = "", hl = "markdownH1" },
				heading_2 = { icon = "󰼐 ", sign = "", hl = "markdownH2" },
				heading_3 = { icon = "󰼑 ", sign = "", hl = "markdownH3" },
				heading_4 = { icon = "󰼒 ", sign = "", hl = "markdownH4" },
				heading_5 = { icon = "󰼓 ", sign = "", hl = "markdownH5" },
				heading_6 = { icon = "󰼔 ", sign = "", hl = "markdownH6" },
			},
			list_items = {
				enable = true,

				indent_size = function(buffer)
					if type(buffer) ~= "number" then
						return vim.bo.shiftwidth or 4
					end

					--- Use 'shiftwidth' value.
					return vim.bo[buffer].shiftwidth or 4
				end,
				shift_width = 0,

				marker_minus = {
					add_padding = true,

					text = "●",
					hl = "MarkviewListItemMinus",
				},
			},
			code_spans = { enable = false },
			code_blocks = { enable = false },
			math_blocks = { enable = false },
			math_spans = { enable = false },
			symbols = { enable = true },
			superscripts = { enable = true, hl = "markdownH6" },
			subscripts = { enable = true, hl = "markdownH5" },
		},
	},
}
