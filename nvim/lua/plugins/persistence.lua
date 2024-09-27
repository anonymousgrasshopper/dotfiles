-- vim.api.nvim_create_autocmd( {"UiEnter" }, {
--   callback = function() require("persistence").load() end,
-- })

return {
  "folke/persistence.nvim",
  lazy=true,
  event = "VeryLazy",
  keys = {
    {"<leader>rs", function() require("persistence").load({ last = true }) end, desc = "restore last session" },
  },
  opts = {
  }
}
