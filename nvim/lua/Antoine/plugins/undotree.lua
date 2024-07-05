return {
  "mbbill/undotree",
  event = "VeryLazy",
  priority = 75,
  vim.keymap.set('n', '<leader>utree', vim.cmd.UndotreeToggle, { desc = "Toggle undotree" }) 
}

