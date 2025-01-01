return {
  "rmagatti/auto-session",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {"<leader>rs", "<cmd>SessionRestore<CR>", desc = "Restore session for cwd" },
    {"<leader>ss", "<cmd>SessionSearch<CR>", desc = "Search sessions" },
    {"<leader>sa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle session autosave" },
  },
  cmd = {
    "SessionRestore",
    "SessionSearch",
    "SessionDelete",
    "SessionSave",
    "Autosession",
  },

  opts = {
    auto_restore = false,
    bypass_save_filetypes = { "alpha" },
    pre_save_cmds = {
      "Neotree close",
      "AerialCloseAll",
    },
    session_lens = {
      load_on_setup = false,
      preview = true,
    }
  }
}
