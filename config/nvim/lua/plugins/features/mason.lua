return {
  {
    "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    priority = 90,  -- We need to setup LSPs before calling lspconfig
    cmd = { "Mason" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local mason           = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      mason_lspconfig.setup({
        ensure_installed = {
          "clangd",
          "lua_ls",
          "bashls",
          "pylsp",
        },
      })

      vim.cmd[[autocmd Filetype mason setlocal cursorline!]]
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = {
      "MasonToolsInstall",
      "MasonToolsInstallSync",
      "MasonToolsUpdate",
      "MasonToolsUpdateSync",
      "MasonToolsClean",
    },
    opts = {
      ensure_installed = {
        "codelldb",
        "clangd",
        "clang-format",
        "lua_ls",
        "bashls",
        "shellcheck",
        "pylsp",
      },
    }
  },
}
