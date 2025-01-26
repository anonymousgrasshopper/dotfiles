local icons = {
  Array         = " ",
  Boolean       = "󰨙 ",
  Class         = " ",
  Codeium       = "󰘦 ",
  Color         = " ",
  Control       = " ",
  Collapsed     = " ",
  Constant      = "󰏿 ",
  Constructor   = " ",
  Copilot       = " ",
  Enum          = " ",
  EnumMember    = " ",
  Event         = " ",
  Field         = " ",
  File          = " ",
  Folder        = " ",
  Function      = "󰊕 ",
  Interface     = " ",
  Key           = " ",
  Keyword       = " ",
  Method        = "󰊕 ",
  Module        = " ",
  Namespace     = "󰦮 ",
  Null          = " ",
  Number        = "󰎠 ",
  Object        = " ",
  Operator      = " ",
  Package       = " ",
  Property      = " ",
  Reference     = " ",
  Snippet       = " ",
  String        = " ",
  Struct        = "󰆼 ",
  Supermaven    = " ",
  TabNine       = "󰏚 ",
  Text          = " ",
  TypeParameter = " ",
  Unit          = " ",
  Value         = " ",
  Variable      = "󰀫 ",
}

return {
  "stevearc/aerial.nvim",
  keys = {
    { "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Toggle code outline window" },
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
          winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
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
        mid_item   = "├╴",
        last_item  = "└╴",
        nested_top = "│ ",
        whitespace = "  ",
      },
      ignore = {
        filetypes = { "alpha", "neo-tree", "CompetiTest", "toggleterm", "undotree" },
      }
    }
    return opts
  end,
}
