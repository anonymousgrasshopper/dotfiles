local function color(name, bgcolor, fgcolor)
  vim.api.nvim_set_hl(0, name, { bg = bgcolor, fg = fgcolor })
end
return {
  {
    "rebelot/kanagawa.nvim",
    priority = 100,
    config = function()
      require("kanagawa").setup({
        overrides = function(colors)
          return {
            color("NvChAsciiHeader", colors.palette.sumiInk3, colors.palette.fujiWhite), -- Title
            color("NvChSection", colors.palette.sumiInk2),                               -- Each card
            color("NvCheatsheetWhite", colors.palette.oldWhite, colors.palette.sumiInk3),
            color("NvCheatsheetGray", colors.palette.dragonGray, colors.palette.sumiInk3),
            color("NvCheatsheetBlue", colors.palette.dragonBlue2, colors.palette.sumiInk3),
            color("NvCheatsheetCyan", colors.palette.lotusCyan, colors.palette.sumiInk3),
            color("NvCheatsheetRed", colors.palette.waveRed, colors.palette.sumiInk3),
            color("NvCheatsheetGreen", colors.palette.springGreen, colors.palette.sumiInk3),
            color("NvCheatsheetOrange", colors.palette.surimiOrange, colors.palette.sumiInk3),
            color("NvCheatsheetPurple", colors.palette.dragonPink, colors.palette.sumiInk3),
            color("NvCheatsheetMagenta", colors.palette.dragonPink, colors.palette.sumiInk3),
            color("NvCheatsheetYellow", colors.palette.boatYellow1, colors.palette.sumiInk3),
          }
        end,
        colors = {
          palette = {
            -- change all usages of these colors
            sumiInk3 = "#14141a", -- main background color
            sumiInk4 = "#14141a", -- line number background color
            sumiInk2 = "#1c1c25", -- cheatsheet column color
          },
        },
      })
      vim.cmd.colorscheme("kanagawa-wave")
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    -- priority = 100,
    config = function()
      require("catppuccin").setup()
      -- vim.cmd("colorscheme catppuccin")
      local mocha = require("catppuccin.palettes").get_palette("mocha")
      require("catppuccin").setup({
        integrations = {
          alpha = true,
          indent_blankline = {
            enabled = true,
            scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
            colored_indent_levels = false,
          },
          cmp = true,
          mason = true,
          nvimtree = true,
          treesitter = true,
          telescope = {
            enabled = true,
          },
          which_key = true,
        },
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    -- priority = 100,
    opts = {},
    config = function()
      -- vim.cmd("colorscheme tokyonight")
    end,
  }
}
