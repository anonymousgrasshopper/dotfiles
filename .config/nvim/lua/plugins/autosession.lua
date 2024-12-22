return {
  "rmagatti/auto-session",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {"<leader>rs", "<cmd>SessionRestore<CR>", desc = "restore session for cwd" },
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
    }
  }
}
