return {
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		opts = {
			auto_resize_height = true,
			preview = {
				win_height = 9,
			},
			filter = {
				fzf = {
					extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
				},
			},
		},
	},
	{
		"romainl/vim-qf",
		ft = "qf",
		keys = {
			{ "]q", "<Plug>(qf_qf_next)zz", desc = "Next quickfix entry" },
			{ "[q", "<Plug>(qf_qf_previous)zz", desc = "Previous quickfix entry" },
			{ "]Q", "<Plug>(qf_loc_next)zz", desc = "Next location list entry" },
			{ "[Q", "<Plug>(qf_loc_previous)zz", desc = "Previous location list entry" },
			{ "<leader>qs", "<Plug>(qf_qf_switch)", desc = "Jump to and from location/quickfix windows" },
			{ "<leader>qt", "<Plug>(qf_qf_toggle)", desc = "Toggle the quickfix window" },
			{ "<leader>qT", "<Plug>(qf_qf_toggle_stay)", desc = "Toggle the quickfix window without moving" },
			{ "<leader>ql", "<Plug>(qf_loc_toggle", desc = "Toggle current location window" },
			{ "<leader>qL", "<Plug>(qf_loc_toggle_stay)", desc = "Toggle current location window without moving" },
			{ "<leader>q]", "<Plug>(qf_newer)", desc = "Navigate to a newer list" },
			{ "<leader>q[", "<Plug>(qf_older)", desc = "Navigate to an older list" },
			{ "<leader>qf", "<Plug>(qf_previous_file)", desc = "Next file" },
			{ "<leader>qF", "<Plug>(qf_next_file)", desc = "Previous file" },
		},
		config = function()
			vim.g.qf_mapping_ack_style = 1
			vim.g.qf_auto_resize = 0
		end,
	},
	{
		"stevearc/quicker.nvim",
		ft = "qf",
		opts = function()
			vim.keymap.set("n", "<leader>qq", function() require("quicker").toggle() end, { desc = "Toggle quickfix" })
			vim.keymap.set(
				"n",
				"<leader>ql",
				function() require("quicker").toggle({ loclist = true }) end,
				{ desc = "Toggle loclist" }
			)
			return {
				opts = {
					number = true,
				},
				keys = {
					{
						">",
						function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end,
						desc = "Expand quickfix context",
					},
					{
						"<",
						function() require("quicker").collapse() end,
						desc = "Collapse quickfix context",
					},
				},
				type_icons = {
					E = "󰅚 ",
					W = "󰀪 ",
					I = " ",
					N = " ",
					H = " ",
				},
			}
		end,
	},
}
