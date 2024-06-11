return {
  "MaximilianLloyd/lazy-reload.nvim",
  opts = {
    command_name = "Reload Plugin"
  },
  keys = {
    -- Opens the command. 
    { "<leader>rl", "<cmd>lua require('lazy-reload').feed()<cr>", desc = "Reload a plugin" },
  }
}
