return {
  "RRethy/vim-illuminate",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>oi", "<cmd>IlluminateToggle<cr>", "Toggle Illuminate" },
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
