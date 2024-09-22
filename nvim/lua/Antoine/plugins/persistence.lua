-- vim.api.nvim_create_autocmd( {"VimEnter" }, {
--   callback = function() require("persistence").load() end,
-- })

return {
  "folke/persistence.nvim",
  keys = {
    {"<leader>rs", function() require("persistence").load({ last = true }) end, desc = "restore last session" },
  },
  event = {"VeryLazy", "BufReadPre"},
  priority=80,
  opts = {
  }
}
