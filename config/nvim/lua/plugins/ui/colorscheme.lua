return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      compile = true,
      overrides = function(colors)
        local theme = colors.theme
        local palette = colors.palette
        return {
          -- syntax highlighting
          Boolean = { bold = false },

          -- user interface
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },

          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },

          WinSeparator = { fg = palette.sumiInk6 },

          NormalDark = { bg = palette.sumiInk1 },
          TerminalBackground = { bg = palette.sumiInk0 },

          PanelHeading = { fg = palette.autumnYellow, bg = palette.sumiInk4 },

          -- plugins
          MarkviewHeading1 = { fg = "#FF5D62" },
          MarkviewHeading2 = { fg = "#FFA066" },
          MarkviewHeading3 = { fg = "#E6C384" },
          MarkviewHeading4 = { fg = "#98BB6C" },
          MarkviewHeading5 = { fg = "#7FB4CA" },
          MarkviewHeading6 = { fg = "#957FB8" },

          MarkviewBlockQuoteDefault = { fg = "#7E9CD8" },
          MarkviewBlockQuoteError = { fg = "#E82424" },
          MarkviewBlockQuoteNote = { fg = "#6A9589" },
          MarkviewBlockQuoteOk = { fg = "#98BB6C" },
          MarkviewBlockQuoteSpecial = { fg = "#957FB8" },
          MarkviewBlockQuoteWarn = { fg = "#FF9E3B" },

          MarkviewCheckboxChecked = { fg = "#98BB6C" },
          MarkviewCheckboxUnchecked = { fg = "#727169" },

          LazyNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
          MasonNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

          IlluminatedWordText = { bold = true },
          IlluminatedWordRead = { bold = true },
          IlluminatedWordWrite = { bold = true },

          NeoTreeWinSeparator = { fg = palette.sumiInk3 },
          NeoTreeFileIcon = { fg = palette.oldWhite },

          GitConflictIncoming = { bg = palette.waveBlue2 },
          GitConflictCurrent = { bg = palette.sumiInk6 },

          TelescopePromptPrefix = { fg = palette.autumnYellow, bg = palette.sumiInk3 },

          SatelliteBar = { bg = palette.sumiInk5 },
        }
      end,
      colors = {
        palette = {}, -- change all usages of these colors
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
}
