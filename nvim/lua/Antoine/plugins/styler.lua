return {
  "folke/styler.nvim",
  lazy = true,
  config = function()
    require("styler").setup({
      themes = {
        -- CompetiTest = { colorscheme = "tokyonight" },
        -- help = { colorscheme = "catppuccin-mocha", background = "dark" },
      },
    })
  end,
}
