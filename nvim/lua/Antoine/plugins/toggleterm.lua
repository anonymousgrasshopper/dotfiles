return {
  "akinsho/toggleterm.nvim", version = "*", config = true,
  lazy = true,
  keys = { { "<leader>term", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" }, },
  config = function()
    require("toggleterm").setup{
      float_opts = {
        highlights = {
          FloatBorder = {
            guifg = "#383444",
          },
        },
        border = "single",
      },
    }
  end
}
