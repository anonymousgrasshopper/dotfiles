local live_grep = function(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local make_entry = require("telescope.make_entry")
	local conf = require("telescope.config").values

	opts = opts or {}
	opts.cwd = opts.cwd or vim.uv.cwd()

	local finder = finders.new_async_job({
		command_generator = function(prompt)
			if not prompt or prompt == "" then
				return nil
			end

			local pieces = vim.split(prompt, "  ")
			local args = { "rg" }
			if pieces[1] then
				table.insert(args, "-e")
				table.insert(args, pieces[1])
			end

			if pieces[2] then
				table.insert(args, "-g")
				table.insert(args, pieces[2])
			end

			---@diagnostic disable-next-line: deprecated
			return vim.tbl_flatten({
				args,
				{
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
			})
		end,
		entry_maker = make_entry.gen_from_vimgrep(opts),
		cwd = opts.cwd,
	})

	pickers
		.new(opts, {
			debounce = 100,
			prompt_title = "Live Grep",
			finder = finder,
			previewer = conf.grep_previewer(opts),
			sorter = require("telescope.sorters").empty(),
		})
		:find()
end

return {
	"anonymousgrasshopper/telescope.nvim",
	-- branch = "0.1.x",
	dependencies = {
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		-- nvim-lua/plenary.nvim
		-- nvim-tree/nvim-web-devicons
	},
	cmd = {
		"Telescope",
	},
	keys = function()
		local builtin = require("telescope.builtin")
		return {
			{ "<leader>rr", builtin.resume, desc = "Resume last Search" },
			{ "<C-R>", "<Plug>(TelescopeFuzzyCommandSearch)", mode = "c", desc = "Search Cmdline history" },

			{ "<leader>ff", function() builtin.find_files({ hidden = true }) end, desc = "Find files in cwd" },
			{ "<leader>fr", function() builtin.oldfiles({ hidden = true }) end, desc = "Find recent files" },

			{ "<leader>sj", builtin.jumplist, desc = "Jumplist" },
			{ "<leader>sm", builtin.marks, desc = "Search Marks" },
			{ "<leader>sk", builtin.keymaps, desc = "Search Keymaps" },
			{ "<leader>sc", builtin.commands, desc = "Search Commands" },
			{ "<leader>sr", builtin.registers, desc = "Search Registers" },
			{ "<leader>sb", builtin.buffers, desc = "Search open Buffers" },
			{ "<leader>sg", live_grep, desc = "Search with Grep in cwd" },
			{ "<leader>sw", builtin.grep_string, desc = "Search Word under cursor in cwd" },
			{ "<leader>sd", function() builtin.diagnostics({ bufnr = 0 }) end, desc = "Search buffer's diagnostics" },
			{ "<leader>sl", builtin.lsp_references, desc = "Search LSP references" },

			{ "<localleader>sr", builtin.lsp_references, desc = "Search references" },
			{ "<localleader>si", builtin.lsp_incoming_calls, desc = "search incoming calls" },
			{ "<localleader>so", builtin.lsp_outgoing_calls, desc = "Search outgoing calls" },
			{ "<localleader>ss", builtin.lsp_document_symbols, desc = "Search document symbols" },
			{ "<localleader>sd", builtin.lsp_diagnostics, desc = "Search diagnostics" },
			{ "<localleader>sw", builtin.lsp_workspace_symbols, desc = "Search workspace symbols" },
			{ "<localleader>sW", builtin.lsp_dynamic_workspace_symbols, desc = "Search dynamic workspace symbols" },

			{ "<leader>gfc", builtin.git_commits, desc = "Search git commits" },
			{ "<leader>gfB", builtin.git_bcommits, desc = "Search git bcommits" },
			{ "<leader>gfb", builtin.git_branches, desc = "Search git branches" },
			{ "<leader>gfs", builtin.git_status, desc = "Search git status" },
			{ "<leader>gfS", builtin.git_stash, desc = "Search git stash items" },

			{ "<leader>sn", require("telescope").extensions.notify.notify, desc = "Search notifications" },
		}
	end,
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				prompt_prefix = "❯ ", -- 
				selection_caret = "  ", -- 
				multi_icon = "󱓻 ",
				-- open files in the first window that is an actual file.
				-- use the current window if no other window is available.
				get_selection_window = function()
					local wins = vim.api.nvim_list_wins()
					table.insert(wins, 1, vim.api.nvim_get_current_win())
					for _, win in ipairs(wins) do
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.bo[buf].buftype == "" then
							return win
						end
					end
					return 0
				end,
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-Down>"] = actions.cycle_history_next,
						["<C-Up>"] = actions.cycle_history_prev,
						["<C-f>"] = actions.preview_scrolling_down,
						["<C-b>"] = actions.preview_scrolling_up,
						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
						["<M-i>"] = function() vim.api.nvim_win_set_cursor(0, { 1, 0 }) end,
						["<M-a>"] = function() vim.api.nvim_win_set_cursor(0, { 1, #vim.api.nvim_get_current_line() }) end,
					},
					n = {
						["q"] = actions.close,
						["<Esc>"] = actions.close,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				buffers = {
					mappings = {
						i = {
							["<C-x>"] = actions.delete_buffer,
						},
					},
				},
			},
			extensions = {
				fzf = {},
			},
		})

		telescope.load_extension("fzf")
		local extensions = {
			["notify"] = "notify",
			["yanky"] = "yank_history",
		}
		for _, extension in ipairs(extensions) do
			if package.loaded[extension] then
				telescope.load_extension(extension)
			end
		end
	end,
}
