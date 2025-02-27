return {
  {
    "ggandor/leap.nvim",
    dependencies = {
      "tpope/vim-repeat",
    },
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
      vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
    end,
  },
  {
    "ggandor/flit.nvim",
    dependencies = {
      "ggandor/leap.nvim",
    },
    opts = {},
  },
  -- {
  --   "mfussenegger/nvim-treehopper",
  --   -- dependencies = {
  --   --   "smoka7/hop.nvim",
  --   -- },
  --   keys = {
  --     { "x", function() require("tsht").nodes() end, mode = { "o", "x" }, desc = "Region selection" },
  --   },
  --   config = function() require("tsht").config.hint_keys = { "a", "o", "e", "u", "i", "d", "h", "t", "n", "s" } end,
  -- },
  -- {
  --   "domharries/foldnav.nvim",
  --   version = "*",
  --   config = function()
  --     vim.g.foldnav = {
  --       flash = {
  --         enabled = true,
  --       },
  --     }
  --   end,
  --   keys = {
  --     { "<M-Left>", function() require("foldnav").goto_start() end },
  --     { "<M-Down>", function() require("foldnav").goto_next() end },
  --     { "<M-Up>", function() require("foldnav").goto_prev_start() end },
  --     { "<M-Right>", function() require("foldnav").goto_end() end },
  --   },
  -- },
}
