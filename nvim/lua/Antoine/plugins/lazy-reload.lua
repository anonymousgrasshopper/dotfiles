return {
  "MaximilianLloyd/lazy-reload.nvim",
  lazy = true,
  opts = {
    command_name = "Reload Plugin"
  },
  keys = {
    { "<leader>rl", "<cmd>lua require('lazy-reload').feed()<cr>", desc = "Reload a plugin" },
  }
}
