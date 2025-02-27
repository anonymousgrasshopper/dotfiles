local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl, priority = 15 })
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      { "rachartier/tiny-inline-diagnostic.nvim", opts = {} },
    },
    config = function()
      vim.diagnostic.config({ virtual_text = false })
      local lspconfig = require("lspconfig")

      lspconfig.clangd.setup({})

      lspconfig.texlab.setup({})

      lspconfig.bashls.setup({
        filetypes = { "bash", "sh", "zsh" },
      })

      lspconfig.lua_ls.setup({
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if
            not (string.match(vim.fn.getcwd(), "nvim"))
            and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
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
      })

      vim.keymap.set("n", "<leader>doc", vim.lsp.buf.hover, { desc = "Hover documentation", buffer = bufnr })
      vim.keymap.set("n", "<leader>def", vim.lsp.buf.definition, { desc = "Go to definition", buffer = bufnr })
      vim.keymap.set("n", "<leader>dec", vim.lsp.buf.declaration, { desc = "Go to declaration", buffer = bufnr })
      vim.keymap.set("n", "<leader>ref", vim.lsp.buf.references, { desc = "References", buffer = bufnr })
      vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "Signature help", buffer = bufnr })
      -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions", buffer = bufnr })
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
      post_open_hook = function() vim.keymap.set("n", "<esc>", "<cmd>quit<cr>", { buffer = true }) end,
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
    opts = {
      -- Priority of the lightbulb for all handlers except float.
      priority = 5,
      hide_in_unfocused_buffer = true,
      link_highlights = true,
      validate_config = "never",
      code_lenses = true,
      sign = {
        enabled = true,
        text = " ",
        lens_text = " ",
      },
      virtual_text = {
        enabled = false,
        text = " ",
        lens_text = " ",
        pos = "eol",
      },
      float = {
        enabled = false,
        text = " ",
        lens_text = " ",
        win_opts = {
          focusable = false,
        },
      },
      status_text = {
        enabled = false,
        text = " ",
        lens_text = " ",
        text_unavailable = "",
      },
      number = {
        enabled = false,
      },
      line = {
        enabled = false,
      },
      autocmd = {
        enabled = true,
        updatetime = 200,
        events = { "CursorHold", "CursorHoldI" },
      },
    },
    filter = function(client_name, result)
      if client_name == "lua_ls" then
        if string.match(result, "change to parameter") then
          print(result)
          return false
        end

        print(result)
        return true
      end
      print(client_name)
    end,
  },
}
