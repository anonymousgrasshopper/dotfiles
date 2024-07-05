return {
  "stevearc/aerial.nvim",
  lazy = true,
  keys = {
    {"<leader>a", "<cmd>AerialToggle!<CR>", desc = "Toggle code outilne window"},
  },
  config = function()
    require("aerial").setup()
  end,
}
