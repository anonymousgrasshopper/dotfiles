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

        vim.keymap.set(
          "v",
          "<leader>gs",
          function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
          { desc = "Stage the current line" }
        )
        vim.keymap.set(
          "v",
          "<leader>gr",
          function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
          { desc = "Reset the current line" }
        )

        vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
        vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
        vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
        vim.keymap.set("n", "<leader>gi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

        vim.keymap.set("n", "<leader>gb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame line" })

        vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff" })

        vim.keymap.set("n", "<leader>gD", function() gitsigns.diffthis("~") end, { desc = "Diff ~" })

        vim.keymap.set("n", "<leader>gQ", function() gitsigns.setqflist("all") end, { desc = "Set quickfix list for all hunks" })
        vim.keymap.set("n", "<leader>gq", gitsigns.setqflist, { desc = "Set quickfix list" })

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
      },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    opts = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        callback = function()
          vim.keymap.set("n", "<leader>go", "<Plug>(git-conflict-ours)", { desc = "Choose ours", buffer = true })
          vim.keymap.set("n", "<leader>gt", "<Plug>(git-conflict-theirs)", { desc = "Choose theirs", buffer = true })
          vim.keymap.set("n", "<leader>g2", "<Plug>(git-conflict-both)", { desc = "Choose both", buffer = true })
          vim.keymap.set("n", "<leader>g0", "<Plug>(git-conflict-none)", { desc = "Choose none", buffer = true })
          vim.keymap.set("n", "[x", "<Plug>(git-conflict-prev-conflict)", { desc = "Previous conflict", buffer = true })
          vim.keymap.set("n", "]x", "<Plug>(git-conflict-next-conflict)", { desc = "Next conflict", buffer = true })
          vim.notify("Merge conflict detected", "error", { title = "Conflict !", icon = " " })
        end,
      })
      return {
        default_mappings = false,
        disable_diagnostics = false,
        highlights = {
          incoming = "GitConflictIncoming",
          current = "GitConflictCurrent",
        },
      }
    end,
  },
}
