return {
  "lewis6991/satellite.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    current_only = false,
    winblend = 0,
    zindex = 40,
    excluded_filetypes = { "neo-tree", "CompetiTest", "undotree", "dapui_scopes", "dapui_breakpoints", "dapui_watches", "dapui_stacks", "dapui_console", "dap-repl" },
    width = 2,
    handlers = {
      cursor = {
        enable = true,
        -- Supports any number of symbols
        symbols = { "⎺", "⎻", "⎼", "⎽" }
      },
      search = {
        enable = true,
      },
      diagnostic = {
        enable = true,
        signs = { "-", "=", "≡" },
        min_severity = vim.diagnostic.severity.HINT,
      },
      gitsigns = {
        enable = true,
        signs = { -- can only be a single character (multibyte is okay)
          add = "│",
          change = "│",
          delete = "-",
        },
      },
      marks = {
        enable = false,
        show_builtins = false, -- shows the builtin marks like [ ] < >
        key = "m",
      },
      quickfix = {
        signs = { "-", "=", "≡" },
      }
    },
  }
}
