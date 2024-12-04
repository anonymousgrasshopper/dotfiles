return {
  "mbbill/undotree",
  event = "VeryLazy",
  priority = 75,
  vim.keymap.set('n', '<leader>tree', vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })
}

