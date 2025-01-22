return {
  "kylechui/nvim-surround",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    keymaps = {
      insert          = "<C-g>a",
      insert_line     = "<C-g>A",
      normal          = "ga",
      normal_cur      = "ga",
      normal_line     = "gz",
      normal_cur_line = "gZ",
      visual          = "gz",
      visual_line     = "gZ",
      delete          = "gd",
      change          = "gc",
    }
  }
}
