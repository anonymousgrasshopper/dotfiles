return {
	"nvim-telescope/telescope.nvim",
  cmd =  {
    "Telescope",
  },
  keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Fuzzy find files in cwd" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Fuzzy find recent files" },
    { "<leader>fs", "<cmd>Telescope live_grep<CR>", desc = "Find string in cwd" },
    { "<leader>fc", "<cmd>Telescope grep_string<CR>", desc = "Find string under cursor in cwd" },

    { "<leader>sr", "<cmd>Telescope registers<CR>", desc = "marks" },
    { "<leader>sm", "<cmd>Telescope marks<CR>", desc = "marks" },
    { "<leader>sj", "<cmd>Telescope jumplist<CR>", desc = "Jumplist" },
    { "<leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Key Maps" },
    { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
  },
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
          n = {
            ["q"] = actions.close,
          },
				},
			},
		})

		telescope.load_extension("fzf")
    -- telescope.load_extension("nerdy")
	end,
}
