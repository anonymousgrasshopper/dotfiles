return {
  "nvim-telescope/telescope.nvim",
  cmd = {
    "Telescope",
  },
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files({ hidden = true }) end, desc = "Find files in cwd" },
    { "<leader>fr", function() require("telescope.builtin").oldfiles({ hidden = true }) end, desc = "Find recent files" },

    { "<leader>sj", function() require("telescope.builtin").jumplist() end, desc = "Jumplist" },
    { "<leader>sm", function() require("telescope.builtin").marks() end, desc = "Search Marks" },
    { "<leader>sk", function() require("telescope.builtin").keymaps() end, desc = "Search Keymaps" },
    { "<leader>sc", function() require("telescope.builtin").commands() end, desc = "Search Commands" },
    { "<leader>sr", function() require("telescope.builtin").registers() end, desc = "Search Registers" },
    { "<leader>sb", function() require("telescope.builtin").buffers() end, desc = "Search open Buffers" },
    { "<leader>sg", function() require("telescope.builtin").live_grep() end, desc = "Search with Grep in cwd" },
    { "<leader>sw", function() require("telescope.builtin").grep_string() end, desc = "Search Word under cursor in cwd" },
    { "<leader>sd", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end, desc = "Search buffer's diagnostics" },
    { "<leader>sl", function() require("telescope.builtin").lsp_references() end, desc = "Search LSP references" },

    { "<leader>rr", function() require("telescope.builtin").resume() end, desc = "Resume last Search" },
    { "<C-R>", "<Plug>(TelescopeFuzzyCommandSearch)", mode = "c", desc = "Search Cmdline history" },
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
        prompt_prefix = "❯ ", -- 
        selection_caret = "  ", -- 
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
          },
          n = {
            ["q"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
      extensions = {
        fzf = {},
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("yank_history")
  end,
}
