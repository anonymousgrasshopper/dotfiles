return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog", "MasonUninstallAl" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      mason.setup({
        ui = {
          icons = {
            package_installed = " ",
            package_pending = "➜ ",
            package_uninstalled = "✗",
          },
        },
      })

      mason_lspconfig.setup({
        ensure_installed = {
          "clangd",
          "lua_ls",
          "bashls",
          "texlab",
          "asm_lsp",
        },
      })

      vim.cmd([[autocmd Filetype mason setlocal nocursorline]])
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
        "stylua",
        "bashls",
        "shellcheck",
        "shfmt",
        "texlab",
        "tex-fmt",
        "asm_lsp",
        "prettier",
      },
    },
  },
}
