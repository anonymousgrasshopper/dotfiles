return {
  "RRethy/vim-illuminate",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>oi", "<Cmd>IlluminateToggle<CR>", desc = "Toggle Illuminate" },
  },
  config = function()
    require("illuminate").configure({
      providers = {
        "lsp",
      },
      delay = 0,
      under_cursor = true,
      min_count_to_highlight = 2,
    })
  end,
}
