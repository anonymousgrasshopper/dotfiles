return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
    opts = {
      keymap = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },

        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "accept",
          "fallback",
        },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },

        ["<M-j>"] = { "snippet_forward", "fallback" },
        ["<M-k>"] = { "snippet_backward", "fallback" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
      cmdline = {
        keymap = {
          ["<C-e>"] = { "hide", "fallback" },

          ["<Tab>"] = { "accept", "fallback" },

          ["<C-p>"] = { "select_prev", "fallback" },
          ["<C-n>"] = { "select_next", "fallback" },
        },
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then return { "buffer" } end
          if type == ":" or type == "@" then return { "cmdline" } end
          return {}
        end,
      },

      appearance = {
        nerd_font_variant = "normal",
      },

      snippets = { preset = "luasnip" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      completion = {
        keyword = {
          -- "prefix" will fuzzy match on the text before the cursor
          -- "full" will fuzzy match on the text before *and* after the cursor
          range = "prefix",
        },
        list = {
          selection = {
            preselect = true,
          },
        },
        menu = {
          enabled = true,
          min_width = 15,
          max_height = 10,
          border = "rounded",
          winblend = vim.o.pumblend,
          winhighlight = "Normal:CmpMenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          scrolloff = 2,
          scrollbar = false,
          direction_priority = { "s", "n" },
          auto_show = true,

          -- Screen coordinates of the command line
          cmdline_position = function()
            if vim.g.ui_cmdline_pos ~= nil then
              local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
              local type = vim.fn.getcmdtype()
              if type == "/" or type == "?" then return { pos[1] - 1, pos[2] } end
              if type == ":" then return { pos[1], pos[2] } end
            end
            local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
            return { vim.o.lines - height, 0 }
          end,

          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          window = {
            border = "rounded",
            winblend = vim.o.pumblend,
            winhighlight = "Normal:CmpMenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            scrollbar = false,
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
  {
    "L3MON4D3/LuaSnip",
    event = "ModeChanged", -- instead of InsertEnter to be able to use visual snippets before having entered insert mode
    version = "v2.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    -- install jsregexp (optional).
    build = "make install_jsregexp",
    config = function()
      require("luasnip").config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
        delete_check_events = "TextChanged",
        store_selection_keys = "<Tab>",
        ext_opts = {
          [require("luasnip.util.types").choiceNode] = {
            active = {
              virt_text = { { "  ", "Comment" } },
            },
          },
        },
        ft_func = require("luasnip.extras.filetype_functions").from_cursor,
      })

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

      vim.keymap.set({ "i", "s" }, "<M-j>", function()
        if require("luasnip").expand_or_locally_jumpable() then require("luasnip").expand_or_jump() end
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<M-k>", function()
        if require("luasnip").locally_jumpable(-1) then require("luasnip").jump(-1) end
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<M-n>", function()
        if require("luasnip").choice_active() then require("luasnip").change_choice(1) end
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<M-N>", function()
        if require("luasnip").choice_active() then require("luasnip").change_choice(-1) end
      end, { silent = true })

      vim.keymap.set("n", "<Leader><leader>s", "<Cmd>lua require('luasnip.loaders.from_lua').load({paths = '~/.config/nvim/snippets'})<CR>", { desc = "Reload snippets" })
    end,
  },
}
