return {
  "anuvyklack/windows.nvim",
  lazy = true,
  keys = {
    {"n", "<C-w>z", "<cmd>WindowsMaximize<CR>"},
    {"n", "<C-w>_", "<cmd>WindowsMaximizeVertically<CR>"},
    {"n", "<C-w>|", "<cmd>WindowsMaximizeHorizontally<CR>"},
    {"n", "<C-w>=", "<cmd>WindowsEqualize<CR>"},
  },
  dependencies = {
    "anuvyklack/middleclass",
    "anuvyklack/animation.nvim"
  },
  config = function()
    require("windows").setup()
  end
}
