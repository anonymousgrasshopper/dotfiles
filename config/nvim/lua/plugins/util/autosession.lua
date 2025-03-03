return {
  "anonymousgrasshopper/auto-session",
  lazy = false,
  keys = {
    { "<leader>rs", "<Cmd>SessionRestore<CR>", desc = "Restore session for cwd" },
    { "<leader>ss", "<Cmd>SessionSearch<CR>", desc = "Search sessions" },
    { "<leader>sa", "<Cmd>SessionToggleAutoSave<CR>", desc = "Toggle session autosave" },
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
    pre_restore_cmds = {
      -- if the Neotree window is active, its content is going to get loaded in a regular buffer and will throw E37 upon trying to quit Neovim
      function()
        if vim.bo.filetype == "neo-tree" then vim.cmd("Neotree close") end
      end,
    },
    post_restore_cmds = {
      "setlocal cursorline",
    },
    pre_save_cmds = {
      function()
        if vim.bo.buftype == "nofile" then vim.cmd("q") end
      end,
    },
    session_lens = {
      load_on_setup = false,
      preview = true,
    },
  },
}
