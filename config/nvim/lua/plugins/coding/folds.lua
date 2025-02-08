return {
  "domharries/foldnav.nvim",
  version = "*",
  config = function()
    vim.g.foldnav = {
      flash = {
        enabled = true,
      },
    }
  end,
  keys = {
    { "<M-Left>", function() require("foldnav").goto_start() end },
    { "<M-Down>", function() require("foldnav").goto_next() end },
    { "<M-Up>", function() require("foldnav").goto_prev_start() end },
    { "<M-Right>", function() require("foldnav").goto_end() end },
  },
}
