return {
  "hrsh7th/nvim-cmp",
  event = { "ModeChanged" }, -- instead of InsertEnter to be able to use LuaSnip visual snippets before inserting text
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      -- install jsregexp (optional).
      build = "make install_jsregexp",
      config = function ()
        require("luasnip").config.set_config({
          history              = true,
          updateevents         = "TextChanged,TextChangedI",
          enable_autosnippets  = true,
          delete_check_events  = "TextChanged",
          store_selection_keys = "<Tab>",
          ext_opts = {
            [require("luasnip.util.types").choiceNode] = {
              active = {
                virt_text = { { "choiceNode", "Comment" } },
              },
            },
          },
          ft_func = require("luasnip.extras.filetype_functions").from_cursor,
        })

        vim.keymap.set({ "i", "s" }, "<A-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", { noremap = true, silent = true })
        vim.keymap.set({ "i", "s" }, "<A-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", { noremap = true, silent = true })

        vim.keymap.set("n", "<Leader>snp", "<Cmd>lua require('luasnip.loaders.from_lua').load({paths = '~/.config/nvim/snippets'})<CR>")
      end
    },
    "hrsh7th/cmp-path",             -- source for file system paths
    "hrsh7th/cmp-nvim-lsp",         -- source for LSPs
    "hrsh7th/cmp-buffer",           -- source for text in buffer
    "saadparwaiz1/cmp_luasnip",     -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim",         -- pictograms
    "micangl/cmp-vimtex",           -- LaTeX
    "chrisgrieser/cmp_yanky",       -- yank history
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    local WIDE_HEIGHT = 40

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    require("luasnip.loaders.from_vscode").lazy_load({
      paths = {
        vim.fn.stdpath("config") .. "/snippets",
      },
    })
    require("luasnip.loaders.from_lua").lazy_load({
      paths = {
        vim.fn.stdpath("config") .. "/snippets",
      },
    })
    require("luasnip.loaders.from_snipmate").lazy_load({
      paths = {
        vim.fn.stdpath("config") .. "/snippets",
      },
    })

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },

      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      window = {
        completion = {
          border       = "rounded",
          winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
          winblend     = vim.o.pumblend,
          max_width    = 38,
          scrolloff    = 0,
          col_offset   = 0,
          side_padding = 1,
          scrollbar    = false,
        },
        documentation = {
          max_height   = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
          max_width    = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
          border       = "rounded",
          winhighlight = "Normal:CmpPmenu",
          winblend     = vim.o.pumblend,
        },
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-8),    -- scroll documentation backwards
        ["<C-f>"] = cmp.mapping.scroll_docs(8),     -- scroll documentation forward
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),    -- scroll documentation up
        ["<C-d>"] = cmp.mapping.scroll_docs(4),     -- scroll documentation down
        ["<C-Space>"] = cmp.mapping.complete(),     -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(),            -- close completion window
        ["<C-CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if luasnip.expandable() then
              luasnip.expand()
            else
              cmp.confirm({
                select = true,
              })
            end
          else
            fallback()
          end
        end),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          elseif cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          elseif cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "cmp_yanky" }, -- yank history
        { name = "nvim_lsp" }, -- get completions from attached LSPs
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "vimtex" }, -- LaTeX
        { name = "path" }, -- filesystem path
      }),

      -- configure lspkind for pictograms in completion menu
      formatting = {
        fields = { cmp.ItemField.Abbr, cmp.ItemField.Kind },
        format = lspkind.cmp_format({
          maxwidth = 20,
          ellipsis_char = "...",
        }),
      },
    })

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done()
    )

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
  end,
}
