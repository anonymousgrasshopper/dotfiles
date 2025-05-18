return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"andymass/vim-matchup",
			{
				"m-demare/hlargs.nvim",
				opts = {
					color = "#f2ecbc",
				},
			},
		},
		config = function()
			vim.treesitter.language.register("bash", "zsh") -- for conditional autosnippet expansion
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
					disable = function() return vim.tbl_contains({ "tex", "markdown", "checkhealth", "zsh" }, vim.bo.filetype) end,
					-- disable = { "tex", "markdown", "checkhealth" }, -- doesn't work on checkhealth for some reason
					additional_vim_regex_highlighting = { "markdown" }, -- for markdown %% comments
				},
				indent = { enable = true },
				ensure_installed = {
					"c",
					"cpp",
					"asm",
					"lua",
					"vim",
					"bash",
					"regex",
					"python",
					"vimdoc",
					"markdown",
					"markdown_inline",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-CR>",
						node_incremental = "<C-CR>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				matchup = {
					enable = true,
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			{
				"chrisgrieser/nvim-various-textobjs",
				opts = {
					keymaps = {
						useDefaults = true,
					},
				},
			},
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						include_surrounding_whitespace = false,
						-- Automatically jump forward to textobject
						lookahead = true,

						keymaps = {
							["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
							["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
							["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
							["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

							["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
							["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

							["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
							["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

							["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
							["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

							["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
							["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

							["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
							["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

							["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },

							["a/"] = { query = "@comment.outer", desc = "Select outer part of a comment" },
							["i/"] = { query = "@comment.inner", desc = "Select inner part of a comment" },

							["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
						},

						selection_modes = { -- "v" : charwise, "V" : linewise, "<c-v>" :blockwise
							["@function.outer"] = "V",
							["@function.inner"] = "v",
							["@class.outer"] = "V",
							["@class.inner"] = "v",
							["@local.scope"] = "V",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist

						goto_next_start = {
							["]f"] = { query = "@call.outer", desc = "Next function call start" },
							["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
							["]c"] = { query = "@class.outer", desc = "Next class start" },
							["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
							["]l"] = { query = "@loop.outer", desc = "Next loop start" },
							["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
							["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
							["]/"] = { query = "@comment.outer", desc = "Next comment start" },
						},
						goto_next_end = {
							["]F"] = { query = "@call.outer", desc = "Next function call end" },
							["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
							["]C"] = { query = "@class.outer", desc = "Next class end" },
							["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
							["]L"] = { query = "@loop.outer", desc = "Next loop end" },
							["]/"] = { query = "@comment.outer", desc = "Next comment end" },
						},
						goto_previous_start = {
							["[f"] = { query = "@call.outer", desc = "Previous function call start" },
							["[m"] = { query = "@function.outer", desc = "Previous method/function def start" },
							["[c"] = { query = "@comment.outer", desc = "Previous comment start" },
							["[i"] = { query = "@conditional.outer", desc = "Previous conditional start" },
							["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
						},
						goto_previous_end = {
							["[F"] = { query = "@call.outer", desc = "Previous function call end" },
							["[M"] = { query = "@function.outer", desc = "Previous method/function def end" },
							["[C"] = { query = "@class.outer", desc = "Previous class end" },
							["[I"] = { query = "@conditional.outer", desc = "Previous conditional end" },
							["[L"] = { query = "@loop.outer", desc = "Previous loop end" },
							["[/"] = { query = "@comment.outer", desc = "Previous comment end" },
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["]p"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
						},
						swap_previous = {
							["[p"] = { query = "@parameter.inner", desc = "Swap with previous paramater" },
						},
					},
				},
			})

			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			-- make motions repeatable
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, "<M-;>", ts_repeat_move.repeat_last_move_previous)

			-- make builtin f, F, t, T also repeatable with ; and <M-;>
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
		end,
	},
}
