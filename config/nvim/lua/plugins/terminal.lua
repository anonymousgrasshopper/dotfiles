return {
  "akinsho/toggleterm.nvim", version = "*",
  cmd = { "ToggleTerm" },
  keys = {
    { "<leader>ter", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" }
  },
  config = function()
    require("toggleterm").setup{
      float_opts = {
        highlights = {
          FloatBorder = {
            guifg = require("kanagawa.colors").setup().palette.sumiInk0,
          },
        },
        border = "single",
      },
    }
  end
}
