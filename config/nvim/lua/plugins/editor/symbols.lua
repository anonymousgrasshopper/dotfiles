local icons = {
  Array             = "󰅪 ",
  Boolean           = "󰨙 ",
  BreakStatement    = "󰙧 ",
  CaseStatement     = "󱃙 ",
  Call              = "󰃷 ",
  Class             = " ",
  Codeium           = "󰘦 ",
  Color             = "󰏘 ",
  ContinueStatement = "→ ",
  Control           = " ",
  Collapsed         = " ",
  Constant          = "󰏿 ",
  Constructor       = " ",
  Copilot           = " ",
  Declaration       = "󰙠 ",
  DoStatement       = "󰑖 ",
  Delete            = "󰩺 ",
  Enum              = " ",
  EnumMember        = "󰒻 ",
  Event             = " ",
  Field             = " ",
  File              = "󰈙 ",
  Folder            = " ",
  ForStatement      = "󰑖 ",
  H1Marker          = "󰉫 ",
  H2Marker          = "󰉬 ",
  H3Marker          = "󰉭 ",
  H4Marker          = "󰉮 ",
  H5Marker          = "󰉯 ",
  H6Marker          = "󰉰 ",
  Function          = "󰊕 ",
  Identifier        = "󰀫 ",
  IfStatement       = "󰇉 ",
  Interface         = " ",
  Key               = "󰌋 ",
  Keyword           = " ",
  List              = "󰅪 ",
  Log               = "󰦪 ",
  Lsp               = " ",
  Macro             = "󰁌 ",
  MarkdownH1        = "󰉫 ",
  MarkdownH2        = "󰉬 ",
  MarkdownH3        = "󰉭 ",
  MarkdownH4        = "󰉮 ",
  MarkdownH5        = "󰉯 ",
  MarkdownH6        = "󰉰 ",
  Method            = " ",
  Module            = "󰏗 ",
  Namespace         = " ",
  Null              = "󰟢 ",
  Number            = "󰎠 ",
  Object            = "󰅩 ",
  Operator          = " ",
  Package           = "󰏖 ",
  Pair              = "󰕘 ",
  Property          = " ",
  Reference         = " ",
  Regex             = " ",
  Repeat            = "󰑖 ",
  Scope             = "󰅩 ",
  Specifier         = "󰦪 ",
  Statement         = "󰅩 ",
  Snippet           = "󰩫 ",
  String            = "󰉾 ",
  Struct            = "󰌗 ",
  Supermaven        = " ",
  SwitchStatement   = "󰺟 ",
  Table             = "󰅩 ",
  TabNine           = "󰏚 ",
  Terminal          = " ",
  Text              = " ",
  Type              = " ",
  TypeParameter     = "󰆩 ",
  Unit              = " ",
  Value             = "󰎠 ",
  Variable          = "󰀫 ",
  WhileStatement    = "󰑖 ",
}

return {
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<leader>a", "<Cmd>AerialToggle!<CR>", desc = "Toggle code outline window" },
    },
    cmd = {
      "AerialCloseAll",
    },
    opts = function()
      icons.lua = { Package = icons.Control }

      local opts = {
        attach_mode = "global",
        backends = { "lsp", "treesitter", "markdown", "man" },
        show_guides = true,
        layout = {
          min_width = 20,
          resize_to_content = true,
          win_opts = {
            winhl = "Normal:NormalDark,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
            signcolumn = "no",
            statuscolumn = "",
          },
        },
        close_automatic_events = { "unsupported" },
        filter_kind = false,
        icons = icons,
        manage_folds = true,
        link_folds_to_tree = true,
        link_tree_to_folds = true,
        guides = {
          mid_item = "├╴",
          last_item = "└╴",
          nested_top = "│ ",
          whitespace = "  ",
        },
        ignore = {
          filetypes = { "alpha", "neo-tree", "CompetiTest", "toggleterm", "undotree" },
        },
      }
      return opts
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    opts = function()
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })

      return {
        bar = {
          pick = {
            pivots = {
              "qsdfghjklmazertyuiopwxcvbn",
            },
          },
        },
        menu = {
          entry = {
            padding = { left = 0, right = 1 },
          },
          win_configs = {
            border = "rounded",
          },
          scrollbar = {
            enable = false,
          },
        },
        fzf = {
          prompt = "❯ ",
        },
        icons = {
          kinds = {
            symbols = icons,
          },
          ui = {
            menu = {
              indicator = "",
            },
          },
        },
        sources = {
          lsp = {
            valid_sources = {
              "array",
              "boolean",
              "break_statement",
              "call",
              "case_statement",
              "class",
              "constant",
              "constructor",
              "continue_statement",
              "delete",
              "do_statement",
              "element",
              "enum",
              "enum_member",
              "event",
              "for_statement",
              "function",
              "h1_marker",
              "h2_marker",
              "h3_marker",
              "h4_marker",
              "h5_marker",
              "h6_marker",
              "if_statement",
              "interface",
              "keyword",
              "macro",
              "method",
              "module",
              "namespace",
              "null",
              "number",
              "operator",
              "package",
              "pair",
              "property",
              "reference",
              "repeat",
              "rule_set",
              "scope",
              "specifier",
              "struct",
              "switch_statement",
              "type",
              "type_parameter",
              "unit",
              "value",
              "variable",
              "while_statement",
              "declaration",
              "field",
              "identifier",
              "object",
              "statement",
            },
          },
        },
      }
    end,
  },
  {
    "bassamsdata/namu.nvim",
    keys = {
      { "<localleader>ss", "<Cmd>Namu symbols<CR>", desc = "Search symbols", silent = true },
    },
    config = function()
      require("namu").setup({
        namu_symbols = {
          enable = true,
          options = {
            AllowKinds = {
              default = {
                "Function",
                "Method",
                "Class",
                "Module",
                "Property",
                "Variable",
                "Constant",
                "Enum",
                "Interface",
                "Field",
                "Struct",
              },
              go = {
                "Function",
                "Method",
                "Struct",
                "Field",
                "Interface",
                "Constant",
                -- "Variable",
                "Property",
                -- "TypeParameter", -- For type parameters if using generics
              },
              lua = { "Function", "Method", "Table", "Module" },
              python = { "Function", "Class", "Method" },
              yaml = { "Object", "Array" },
              json = { "Module" },
              toml = { "Object" },
              markdown = { "String" },
            },
            BlockList = {
              default = {},
              lua = {
                "^vim%.", -- anonymous functions passed to nvim api
                "%.%.%. :", -- vim.iter functions
                ":gsub", -- lua string.gsub
                "^callback$", -- nvim autocmds
                "^filter$",
                "^map$", -- nvim keymaps
              },
              -- example: python = { "^__" }, -- ignore __init__ functions
            },
            display = {
              mode = "icon", -- "icon" or "raw"
              padding = 2,
            },
            -- This is a preset that let's set window without really get into the hassle of tuning window options
            -- top10 meaning top 10% of the window
            row_position = "top10", -- options: "center"|"top10"|"top10_right"|"center_right"|"bottom",
            preview = {
              highlight_on_move = true, -- Whether to highlight symbols as you move through them
              highlight_mode = "always", -- "always" | "select" (only highlight when selecting)
            },
            window = {
              auto_size = true,
              min_height = 1,
              min_width = 20,
              max_width = 120,
              max_height = 30,
              padding = 2,
              border = "rounded",
              title_pos = "left",
              show_footer = true,
              footer_pos = "right",
              relative = "editor",
              style = "minimal",
              width_ratio = 0.6,
              height_ratio = 0.6,
              title_prefix = "󱠦 ",
            },
            debug = false,
            focus_current_symbol = true,
            auto_select = false,
            initially_hidden = false,
            multiselect = {
              enabled = true,
              indicator = "✓", -- or ●
              keymaps = {
                toggle = "<Tab>",
                untoggle = "<S-Tab>",
                select_all = "<C-a>",
                clear_all = "<C-l>",
              },
              max_items = nil, -- No limit by default
            },
            actions = {
              close_on_yank = false, -- Whether to close picker after yanking
              close_on_delete = true, -- Whether to close picker after deleting
            },
            movement = { -- Support multiple keys
              next = { "<C-n>", "<DOWN>" },
              previous = { "<C-p>", "<UP>" },
              close = { "<ESC>" }, -- "<C-c>" can be added as well
              select = { "<CR>" },
              delete_word = {}, -- it can assign "<C-w>"
              clear_line = {}, -- it can be "<C-u>"
            },
            custom_keymaps = {
              yank = {
                keys = { "<C-y>" },
                desc = "Yank symbol text",
              },
              delete = {
                keys = { "<C-d>" },
                desc = "Delete symbol text",
              },
              vertical_split = {
                keys = { "<C-v>" },
                desc = "Open in vertical split",
              },
              horizontal_split = {
                keys = { "<C-h>" },
                desc = "Open in horizontal split",
              },
              codecompanion = {
                keys = "<C-o>",
                desc = "Add symbol to CodeCompanion",
              },
              avante = {
                keys = "<C-t>",
                desc = "Add symbol to Avante",
              },
            },
            icon = "󱠦 ", -- 󱠦 -  -  -- 󰚟
            kindText = {
              Function = "function",
              Class = "class",
              Module = "module",
              Constructor = "constructor",
              Interface = "interface",
              Property = "property",
              Field = "field",
              Enum = "enum",
              Constant = "constant",
              Variable = "variable",
            },
            kindIcons = icons,
            highlight = "NamuPreview",
            highlights = {
              parent = "NamuParent",
              nested = "NamuNested",
              style = "NamuStyle",
            },
            kinds = {
              prefix_kind_colors = true,
              enable_highlights = true,
              highlights = {
                PrefixSymbol = "NamuPrefixSymbol",
                Function = "NamuSymbolFunction",
                Method = "NamuSymbolMethod",
                Class = "NamuSymbolClass",
                Interface = "NamuSymbolInterface",
                Variable = "NamuSymbolVariable",
                Constant = "NamuSymbolConstant",
                Property = "NamuSymbolProperty",
                Field = "NamuSymbolField",
                Enum = "NamuSymbolEnum",
                Module = "NamuSymbolModule",
              },
            },
          },
        },
        ui_select = { enable = false }, -- vim.ui.select() wrapper
        colorscheme = { enable = false }, --colorscheme switcher
      })
    end,
  },
}
