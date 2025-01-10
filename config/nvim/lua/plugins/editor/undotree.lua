return {
  "mbbill/undotree",
  event = { "BufReadPre", "BufNewFile" },
  vim.keymap.set("n", "<leader>tr", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })
}

