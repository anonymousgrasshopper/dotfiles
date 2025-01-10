return {
  "nvim-telescope/telescope.nvim",
  cmd =  {
    "Telescope",
  },
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files({ hidden=true }) end, desc = "Fuzzy find files in cwd" },
    { "<leader>fr", function() require("telescope.builtin").oldfiles({ hidden=true }) end, desc = "Fuzzy find recent files" },
    { "<leader>fs", function() require("telescope.builtin").live_grep() end, desc = "Find string in cwd" },
    { "<leader>fc", function() require("telescope.builtin").grep_string() end, desc = "Find string under cursor in cwd" },

    { "<leader>sr", function() require("telescope.builtin").registers() end, desc = "marks" },
    { "<leader>sm", function() require("telescope.builtin").marks() end, desc = "marks" },
    { "<leader>sj", function() require("telescope.builtin").jumplist() end, desc = "Jumplist" },
    { "<leader>sk", function() require("telescope.builtin").keymaps() end, desc = "Key Maps" },
    { "<leader>sc", function() require("telescope.builtin").commands() end, desc = "Commands" },
    { "<leader>sd", function() require("telescope.builtin").diagnostics({ bufnr=0 }) end, desc = "Document Diagnostics" },
  },
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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
    telescope.load_extension("yank_history")
  end,
}
