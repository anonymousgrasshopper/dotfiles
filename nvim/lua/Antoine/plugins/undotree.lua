return {
  "mbbill/undotree",
  event = "VeryLazy",
  vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle, { desc = "Toggle undotree" }) 
}

