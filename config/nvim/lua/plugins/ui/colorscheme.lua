return {
  {
    "rebelot/kanagawa.nvim",
    -- the README is not up to date, see https://github.com/rebelot/kanagawa.nvim/blob/master/lua/kanagawa/colors.lua
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = true,
        overrides = function(colors)
          local theme = colors.theme
          local palette = colors.palette
          return {
            WinSeparator = { fg = palette.sumiInk6 },

            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },

            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
            PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },

            PanelHeading = { fg = palette.autumnYellow, bg = palette.sumiInk4 },

            LazyNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            MasonNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            NeoTreeBackground = { bg = palette.sumiInk2 },
            NeoTreeWinSeparator = { fg = "none" },
            NeoTreeFileIcon = { fg = palette.oldWhite },
          }
        end,
        colors = {
          palette = {
            -- change all usages of these colors
          },
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
      })
      vim.cmd("colorscheme kanagawa-wave")
    end,
  },
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup()
  --     -- vim.cmd("colorscheme catppuccin")
  --     -- local mocha = require("catppuccin.colors.palettes").get_colors.palette("mocha")
  --     require("catppuccin").setup({
  --       integrations = {
  --         alpha = true,
  --         indent_blankline = {
  --           enabled = true,
  --           scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
  --           colored_indent_levels = false,
  --         },
  --         cmp = true,
  --         mason = true,
  --         nvimtree = true,
  --         treesitter = true,
  --         telescope = {
  --           enabled = true,
  --         },
  --         which_key = true,
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   "folke/tokyonight.nvim",
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     -- vim.cmd("colorscheme tokyonight")
  --   end,
  -- },
}
