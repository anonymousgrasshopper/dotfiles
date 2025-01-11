return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "UiEnter",
  config = function()
    local palette = require("kanagawa.colors").setup().palette

    local colors = {
      blue = palette.crystalBlue,
      green = palette.springGreen,
      violet = palette.oniViolet,
      yellow = palette.autumnYellow,
      red = palette.autumnRed,
      grey = palette.sumiInk6,
      fg = palette.springViolet2,
      bg = palette.sumiInk4,
      inactive_bg = palette.sumiInk0,
      semilightgray = palette.springViolet2,
    }

    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    local lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.grey, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.grey, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.grey, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.grey, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.grey, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    local competitest = {
      filetypes = { "CompetiTest" },
      sections = {
        lualine_b = { function()
          return vim.b.competitest_title or "CompetiTest"
        end },
        lualine_y = { "searchcount" },
        lualine_z = { lineinfo },
      },
      inactive_sections = {
        lualine_b = { function()
          return vim.b.competitest_title or "CompetiTest"
        end },
      },
    }

    lualine.setup({
      options = {
        theme = lualine_theme,
        disabled_filetypes = { "alpha" },
      },
      ignore_focus = { "CompetiTest" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "filename",
            file_status = true, -- displays file status (readonly status, modified status)
            path = 3, -- 0 = just filename, 1 = relative path, 2 = absolute path, 3 = use ~ as home directory
            separator = " ",
            padding = { left = 1, right = 0 }
          },
          { "filetype", icon_only = true, padding = { left = 0, right = 1 } },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#FF9E3B" },
          },
          { "diagnostics" },
          {
            require("noice").api.statusline.mode.get,
            cond = require("noice").api.statusline.mode.has,
            color = { fg = "#FF9E3B" },
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      extensions = {
        "lazy",
        "fugitive",
        "mason",
        "nvim-dap-ui",
        "neo-tree",
        "toggleterm",
        competitest,
      }
    })
  end,
}
