return {
  "mbbill/undotree",
  event = "VeryLazy",
  vim.keymap.set('n', '<leader>utree', vim.cmd.UndotreeToggle, { desc = "Toggle undotree" }) 
}

