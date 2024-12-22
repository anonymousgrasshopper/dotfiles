local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- disble virtual text for diagnostics
vim.diagnostic.config({
  virtual_text = false
})

-- Show line diagnostics automatically in hover window
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      winblend = vim.o.pumblend,
      border = "single",
      source = "always",
      prefix = " ",
      scope = "cursor",
    }
    vim.diagnostic.open_float(nil, opts)
  end
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

return {
  {
    "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    priority = 90,  -- We need to install LSPs before calling lspconfig
    cmd = { "Mason" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "mfussenegger/nvim-lint",
    },
    config = function()
      local mason           = require("mason")
      local mason_installer = require("mason-tool-installer")
      local mason_lspconfig = require("mason-lspconfig")
      local nvim_lint       = require("lint")

      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      mason_lspconfig.setup()

      mason_installer.setup({
        ensure_installed = {
          "clangd",
          "codelldb",
          "lua_ls",
          "bashls",
          "shellcheck",
          "pylsp",
        },
      })

      nvim_lint.linters_by_ft = {
        shell = { "shellcheck" },
        zsh = { "shellcheck" },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    priority = 80,
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim"
        },
        opts = { lsp = { auto_attach = true } }
      },
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      lspconfig.clangd.setup({
        capabilities = capabilities,
      })
      lspconfig.clangd.setup { handlers=handlers }

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path.."/.luarc.json") or vim.loop.fs_stat(path.."/.luarc.jsonc") then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you"re using
              version = "LuaJIT"
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
              }
            }
          })
        end,
        settings = {
          Lua = {}
        },
      })

      lspconfig.bashls.setup {
        filetypes = { "sh", "bash", "zsh" }
      }

      vim.keymap.set("n", "<leader>doc", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>def", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>ref", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

      vim.keymap.set("n", "<leader>vtxt", "<cmd>lua vim.diagnostic.config({virtual_text=(not virtual_text)})<CR>", { silent = true })
    end,
  },
}
