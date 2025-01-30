return {
  "kylechui/nvim-surround",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    keymaps = {
      insert          = "<C-g>a",
      insert_line     = "<C-g>A",
      normal          = "gz",
      normal_cur      = "gZ",
      normal_line     = "ga",
      normal_cur_line = "gA",
      visual          = "ga",
      visual_line     = "gA",
      delete          = "gd",
      change          = "gr",
    },
  },
}
