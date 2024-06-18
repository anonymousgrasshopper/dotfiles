return {
  -- "catppuccin/nvim",
  -- name = "catppuccin",
  -- priority = 100,
  -- config = function()
  --   require("catppuccin").setup()
  --   vim.cmd("colorscheme catppuccin")
  --   local mocha = require("catppuccin.palettes").get_palette("mocha")
  --   require("catppuccin").setup({
  --     integrations = {
  --       alpha = true,
  --       indent_blankline = {
  --         enabled = true,
  --         scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
  --         colored_indent_levels = false,
  --       },
  --       cmp = true,
  --       mason = true,
  --       nvimtree = true,
  --       treesitter = true,
  --       telescope = {
  --         enabled = true,
  --       },
  --       which_key = true,
  --     },
  --   })
  -- end,

  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 100,
  --   opts = {},
  --   config = function()
  --     vim.cmd("colorscheme tokyonight")
  --   end,

  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 100,
  config = function()
    vim.cmd("colorscheme kanagawa")
  end
}
