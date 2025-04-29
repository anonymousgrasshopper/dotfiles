return {
	{
		"tpope/vim-fugitive",
		cmd = { "Git" },
		ft = { "git", "DiffviewFiles" }, -- for statusline component
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},

			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				-- Navigation
				vim.keymap.set("n", "]g", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end)

				vim.keymap.set("n", "[g", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end)

				-- Actions
				vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
				vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })

				vim.keymap.set("v", "<leader>gs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage the current line" })
				vim.keymap.set("v", "<leader>gr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset the current line" })

				vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
				vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
				vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
				vim.keymap.set("n", "<leader>gi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

				vim.keymap.set("n", "<leader>gb", function()
					gitsigns.blame_line({ full = true })
				end, { desc = "Blame line" })

				vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, { desc = "View diff for current file against the index" })

				vim.keymap.set("n", "<leader>gD", function()
					gitsigns.diffthis("~")
				end, { desc = "View diff for current file" })

				vim.keymap.set("n", "<leader>gQ", function()
					gitsigns.setqflist("all")
				end, { desc = "Populate quickfix list with all hunks" })
				vim.keymap.set("n", "<leader>gq", gitsigns.setqflist, { desc = "Populate quickfix list with hunks" })

				-- Toggles
				vim.keymap.set("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
				vim.keymap.set("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle deleted" })
				vim.keymap.set("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

				-- Text object
				vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "inner hunk" })
			end,
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = {
			"DiffviewOpen",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
			"DiffviewRefresh",
		},
		keys = {
			{ "<leader>gv", "<Cmd>DiffviewOpen<CR>", desc = "Open diff view" },
		},
		opts = {
			signs = {
				done = " ",
			},
			hooks = {
				diff_buf_read = function(_, _)
					vim.cmd("hi Cursor blend=100")
					vim.opt_local.relativenumber = false
				end,
				view_opened = function(_)
					vim.opt_local.sidescrolloff = 0
				end,
			},
		},
	},
	{
		"rhysd/conflict-marker.vim",
		event = { "BufEnter" },
		config = function()
			vim.keymap.set("n", "<leader>co", "<Cmd>ConflictMarkerOurselves<CR>", { desc = "Choose ours" })
			vim.keymap.set("n", "<leader>ct", "<Cmd>ConflictMarkerThemselves<CR>", { desc = "Choose theirs" })
			vim.keymap.set("n", "<leader>cb", "<Cmd>ConflictMarkerBoth<CR>", { desc = "Choose both" })
			vim.keymap.set("n", "<leader>cn", "<Cmd>ConflictMarkerNone<CR>", { desc = "Choose none" })
			vim.keymap.set("n", "<leader>cB", "<Cmd>ConflictMarkerBoth!<CR>", { desc = "Choose both in reverse order" })
			vim.g.conflict_marker_highlight_group = ""
			vim.g.conflict_marker_enable_mappings = 1 -- [x and ]x mappings
			vim.g.conflict_marker_enable_matchit = 1 -- use % to jump within a conflict marker
		end,
	},
	{
		"rbong/vim-flog",
		lazy = true,
		cmd = { "Flog", "Flogsplit", "Floggit" },
		dependencies = {
			"tpope/vim-fugitive",
		},
	},
}
