return {
  "folke/noice.nvim",
  event = "VeryLazy",
  keys = { { "<A-x>", "<Cmd>Noice dismiss<CR>", desc = "Dismiss all notifications" } },
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = function()
        vim.notify = require("notify")
        return {
          timeout = 3000,
        }
      end,
    },
  },
  opts = {
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      lsp_doc_border = true, -- add a border to hover docs and signature help
      inc_rename = {
        cmdline = {
          format = {
            Rename = {
              pattern = "^:%s*Rename%s+",
              icon = " ",
              conceal = true,
              opts = {
                relative = "cursor",
                size = { min_width = 20 },
                position = { row = -3, col = 0 },
              },
            },
          },
        },
      }, -- enables an input dialog for inc-rename.nvim
    },
    cmdline = {
      format = {
        cmdline = {
          pattern = "^:",
          icon = " ",
          title = "",
          lang = "vim",
        },
        search_down = {
          view = "cmdline",
        },
        search_up = {
          view = "cmdline",
        },
        filter = { title = "" },
        lua = { title = "" },
        help = { title = "" },
        input = { title = "" },
      },
    },
    messages = {
      view_search = false, -- view for search count messages. "virtualtext" or 'false' to disable
    },
    views = {
      cmdline_popup = {
        border = {
          style = "single",
        },
        filter_options = {},
        win_options = {
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      },
    },
    routes = {
      {
        filter = {
          event = "notify",
          kind = "info",
          any = {
            { find = "[Neo-tree INFO]" },
          },
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "notify",
          kind = "warn",
          any = {
            { find = "[Neo-tree WARN]" },
          },
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "lsp",
          kind = "progress",
          cond = function(message)
            local client = vim.tbl_get(message.opts, "progress", "client")
            return client == "lua_ls"
          end,
        },
        opts = { skip = true },
      },
    },
  },
}
