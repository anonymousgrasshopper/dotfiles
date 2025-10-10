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
				if not pieces[2]:match("*") then
					pieces[2] = "*\\." .. pieces[2]
				end
				table.insert(args, "-g")
				table.insert(args, pieces[2])
			end

			return vim.iter({
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
			:flatten()
			:totable()
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
		{ "nvim-telescope/telescope-ui-select.nvim" },
		-- nvim-lua/plenary.nvim
		-- nvim-tree/nvim-web-devicons
	},
	cmd = {
		"Telescope",
	},
	keys = {
		{ "<leader>rr", function() require("telescope.builtin").resume() end, desc = "Resume last Search" },
		{ "<C-R>", "<Plug>(TelescopeFuzzyCommandSearch)", mode = "c", desc = "Search Cmdline history" },

		{ "<leader>ff", function() require("telescope.builtin").find_files({ hidden = true }) end, desc = "Find files in cwd" },
		{ "<leader>fr", function() require("telescope.builtin").oldfiles({ hidden = true }) end, desc = "Find recent files" },

		{ "<leader>sj", function() require("telescope.builtin").jumplist() end, desc = "Search Jumplist" },
		{ "<leader>sm", function() require("telescope.builtin").marks() end, desc = "Search Marks" },
		{ "<leader>sk", function() require("telescope.builtin").keymaps() end, desc = "Search Keymaps" },
		{ "<leader>sc", function() require("telescope.builtin").commands() end, desc = "Search Commands" },
		{ "<leader>sr", function() require("telescope.builtin").registers() end, desc = "Search Registers" },
		{ "<leader>sh", function() require("telescope.builtin").highlights() end, desc = "Search Highlight groups" },
		{ "<leader>sb", function() require("telescope.builtin").buffers() end, desc = "Search open Buffers" },
		{ "<leader>sg", live_grep, desc = "Search with Grep in cwd" },
		{ "<leader>sw", function() require("telescope.builtin").grep_string() end, desc = "Search Word under cursor in cwd" },
		{ "<leader>sd", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end, desc = "Search buffer's diagnostics" },

		{ "<localleader>sr", function() require("telescope.builtin").lsp_references() end, desc = "Search references" },
		{ "<localleader>si", function() require("telescope.builtin").lsp_incoming_calls() end, desc = "search incoming calls" },
		{ "<localleader>so", function() require("telescope.builtin").lsp_outgoing_calls() end, desc = "Search outgoing calls" },
		{ "<localleader>ss", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Search document symbols" },
		{ "<localleader>sd", function() require("telescope.builtin").lsp_diagnostics() end, desc = "Search diagnostics" },
		{ "<localleader>sw", function() require("telescope.builtin").lsp_workspace_symbols() end, desc = "Search workspace symbols" },
		{ "<localleader>sW", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, desc = "Search dynamic workspace symbols" },

		{ "<leader>gsc", function() require("telescope.builtin").git_commits() end, desc = "Search git commits" },
		{ "<leader>gsB", function() require("telescope.builtin").git_bcommits() end, desc = "Search git bcommits" },
		{ "<leader>gsb", function() require("telescope.builtin").git_branches() end, desc = "Search git branches" },
		{ "<leader>gss", function() require("telescope.builtin").git_status() end, desc = "Search git status" },
		{ "<leader>gsS", function() require("telescope.builtin").git_stash() end, desc = "Search git stash items" },

		{ "<leader>sn", function() require("telescope").extensions.notify.notify() end, desc = "Search notifications" },
	},
	lazy = false, -- needs to load before we call vim.ui.select for the first time
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
				["fzf"] = {},
				["ui-select"] = { require("telescope.themes").get_dropdown({}) },
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")

		local extensions = {
			["notify"] = "notify",
			["yanky"] = "yank_history",
			["nerdy"] = "nerdy",
		}
		for _, extension in ipairs(extensions) do
			if package.loaded[extension] then
				telescope.load_extension(extension)
			end
		end
	end,
}
