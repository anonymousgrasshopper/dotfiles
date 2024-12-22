return {
  "kylechui/nvim-surround",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("nvim-surround").setup({
      keymaps = {
        insert          = "<C-g>z",
        insert_line     = "<C-g>Z",
        normal          = "gz",
        normal_cur      = "gZ",
        normal_line     = "gzgz",
        normal_cur_line = "gZgZ",
        visual          = "gz",
        visual_line     = "gZ",
        delete          = "gd",
        change          = "gr",
      }
    })
  end
}
