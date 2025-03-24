return {
  "lewis6991/satellite.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    width = 2,
    current_only = false,
    winblend = 0,
    zindex = 40,
    excluded_filetypes = {
      "neo-tree",
      "CompetiTest",
      "undotree",
      "aerial",
      "dapui_scopes",
      "dapui_breakpoints",
      "dapui_watches",
      "dapui_stacks",
      "dapui_console",
      "dap-repl",
    },
    handlers = {
      cursor = {
        enable = true,
        symbols = { "⎺", "⎻", "⎼", "⎽" },
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
        signs = {
          add = "▕",
          change = "▕",
          delete = "-",
        },
      },
      quickfix = {
        signs = { "-", "=", "≡" },
      },
      marks = {
        enable = false,
      },
    },
  },
}
