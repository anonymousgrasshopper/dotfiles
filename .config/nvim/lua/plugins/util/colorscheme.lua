--                 ███                                    ██
--                ░░██                                   ░██
--   █████   █████ ░██  █████  ██████      ██████  █████ ░██████   █████  ██████████   █████
--  ██░░░██ ██░░░██░██ ██░░░██░░██░░█     ██░░░░  ██░░░██░██░░░██ ██░░░██░░██░░██░░██ ██░░░██
-- ░██  ░░ ░██  ░██░██░██  ░██ ░██ ░     ░░█████ ░██  ░░ ░██  ░██░███████ ░██ ░██ ░██░███████
-- ░██   ██░██  ░██░██░██  ░██ ░██        ░░░░░██░██   ██░██  ░██░██░░░░  ░██ ░██ ░██░██░░░░
-- ░░█████ ░░█████ ░██░░█████  ███        ██████ ░░█████ ░██  ░██░░█████  ███ ░██ ░██░░█████
--  ░░░░░   ░░░░░  ░░  ░░░░░  ░░░        ░░░░░░   ░░░░░  ░░   ░░  ░░░░░  ░░░  ░░  ░░  ░░░░░

return {
  {
    "rebelot/kanagawa.nvim",
    lazy=true,
    event = "UiEnter",
    priority=1000,
    config = function()
      require("kanagawa").setup({
        overrides = function(colors)
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },

            Pmenu = { fg = colors.theme.ui.shade0, bg = colors.theme.ui.bg_p1 },
            PmenuSel = { fg = "none", bg = colors.theme.ui.bg_p2 },
            PmenuSbar = { bg = colors.theme.ui.bg_m1 },
            PmenuThumb = { bg = colors.theme.ui.bg_p2 },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { bg = colors.theme.ui.bg_m3, fg = colors.theme.ui.fg_dim },

            LazyNormal = { bg = colors.theme.ui.bg_m3, fg = colors.theme.ui.fg_dim },
            MasonNormal = { bg = colors.theme.ui.bg_m3, fg = colors.theme.ui.fg_dim },

            NeoTreeWinSeparator = { bg = "none", fg = colors.palette.crystalBlue },
            WinSeparator = { fg = "#54546D", bg = "none"},

            NvChAsciiHeader = { bg = colors.palette.sumiInk3, fg = colors.palette.fujiWhite },
            NvChSection = { bg = colors.palette.sumiInk2 },
            NvCheatsheetWhite = { bg = colors.palette.oldWhite, fg = colors.palette.sumiInk3 },
            NvCheatsheetGray = { bg = colors.palette.dragonGray, fg = colors.palette.sumiInk3 },
            NvCheatsheetBlue = { bg = colors.palette.dragonBlue2, fg = colors.palette.sumiInk3 },
            NvCheatsheetCyan = { bg = colors.palette.lotusCyan, fg = colors.palette.sumiInk3 },
            NvCheatsheetRed = { bg = colors.palette.waveRed, fg = colors.palette.sumiInk3 },
            NvCheatsheetGreen = { bg = colors.palette.springGreen, fg = colors.palette.sumiInk3 },
            NvCheatsheetOrange = { bg = colors.palette.surimiOrange, fg = colors.palette.sumiInk3 },
            NvCheatsheetPurple = { bg = colors.palette.dragonPink, fg = colors.palette.sumiInk3 },
            NvCheatsheetMagenta = { bg = colors.palette.dragonPink, fg = colors.palette.sumiInk3 },
            NvCheatsheetYellow = { bg = colors.palette.boatYellow1, fg = colors.palette.sumiInk3 },
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
      vim.cmd("colorscheme kanagawa-wave")
    end,
  },
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   lazy = true,
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
  --   lazy = true,
  --   opts = {},
  --   config = function()
  --     -- vim.cmd("colorscheme tokyonight")
  --   end,
  -- }
}
