vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
  },
  virtual_text = false,
  severity_sort = true,
})

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          "williamboman/mason.nvim",
        },
      },
      { "rachartier/tiny-inline-diagnostic.nvim", opts = {} },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      mason_lspconfig.setup({
        ensure_installed = {
          "clangd",
          "lua_ls",
          "bashls",
          "texlab",
          "asm_lsp",
        },
        automatic_installation = false,
      })

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,

        ["clangd"] = function()
          lspconfig.clangd.setup({
            init_options = {
              fallbackFlags = { "--std=c++20" },
            },
            capabilities = capabilities,
          })
        end,

        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            on_init = function(client)
              local path = client.workspace_folders[1].name
              if
                not (vim.fn.getcwd():match("nvim")) and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
              then
                return
              end

              client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                  -- Tell the language server which version of Lua you"re using
                  version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                    -- "${3rd}/busted/library",
                  },
                },
              })
            end,
            settings = {
              Lua = {},
            },
            capabilities = capabilities,
          })
        end,

        ["bashls"] = function()
          lspconfig.bashls.setup({
            filetypes = { "bash", "sh", "zsh" },
            capabilities = capabilities,
          })
        end,

        ["cssls"] = function()
          lspconfig.cssls.setup({
            filetypes = { "html", "css" },
            capabilities = capabilities,
          })
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          vim.keymap.set("n", "<leader>doc", vim.lsp.buf.hover, { desc = "Hover documentation", buffer = bufnr })
          vim.keymap.set("n", "<leader>def", vim.lsp.buf.definition, { desc = "Go to definition", buffer = bufnr })
          vim.keymap.set("n", "<leader>dec", vim.lsp.buf.declaration, { desc = "Go to declaration", buffer = bufnr })
          vim.keymap.set("n", "<leader>ref", vim.lsp.buf.references, { desc = "References", buffer = bufnr })
          vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "Signature help", buffer = bufnr })
          -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions", buffer = bufnr })
        end,
      })
    end,
  },
  {
    "rmagatti/goto-preview",
    keys = {
      { "gpd", function() require("goto-preview").goto_preview_definition() end, desc = "Preview definition" },
      { "gpc", function() require("goto-preview").goto_preview_declaration() end, desc = "Preview declaration" },
      { "gpi", function() require("goto-preview").goto_preview_implementation() end, desc = "Preview implementation" },
      { "gpr", function() require("goto-preview").goto_preview_references() end, desc = "Preview references" },
      { "gpt", function() require("goto-preview").goto_preview_type_definition() end, desc = "Preview type definition" },
      { "gpx", function() require("goto-preview").close_all_win() end, desc = "Close all previews" },
      { "gpX", function() require("goto-preview").close_all_win({ skip_curr_window = true }) end, desc = "Close other previews" },
    },
    opts = {
      width = 120, -- Width of the floating window
      height = 15, -- Height of the floating window
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, -- Border characters of the floating window
      opacity = 20, -- 0-100 opacity level of the floating window where 100 is fully transparent.
      resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
      post_open_hook = function() vim.keymap.set("n", "<esc>", "<Cmd>quit<CR>", { buffer = true }) end,
      focus_on_open = true, -- Focus the floating window when opening it.
      dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
      force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
      bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
      stack_floating_preview_windows = true, -- Whether to nest floating windows
      same_file_float_preview = true, -- Whether to open a new floating window for a reference within the current file
      preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
      zindex = 1, -- Starting zindex for the stack of floating windows
    },
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    keys = {
      {
        "<leader>ca",
        function()
          vim.g.code_action_preview = true
          require("tiny-code-action").code_action()
        end,
        desc = "Code actions",
        silent = true,
      },
    },
    opts = {
      backend = "delta",
    },
  },
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = {
      priority = 5, -- Priority of the lightbulb for all handlers except float.
      hide_in_unfocused_buffer = true,
      link_highlights = true,
      validate_config = "never",
      code_lenses = true,
      sign = { enabled = false, text = " ", lens_text = " " },
      virtual_text = { enabled = false, text = " ", lens_text = " ", pos = "eol" },
      float = { enabled = false, text = " ", lens_text = " ", win_opts = { focusable = false } },
      status_text = { enabled = true, text = " ", lens_text = " ", text_unavailable = "" },
      number = { enabled = false },
      line = { enabled = false },
      autocmd = { enabled = true, updatetime = 200, events = { "CursorHold", "CursorHoldI" } },
      filter = function(client_name, code_action)
        local ignored_patterns = {
          ["lua_ls"] = { "change to parameter" },
        }
        if ignored_patterns[client_name] ~= nil and vim.tbl_contains(ignored_patterns[client_name], code_action.title) then return false end
        return true
      end,
    },
  },
}
