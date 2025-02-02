return {
  "mbbill/undotree",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "Undotree" },
  keys = {
    { "<leader>tr", vim.cmd.UndotreeToggle, desc = "Toggle UndoTree" },
  },
  init = function()
    vim.g.undotree_SplitWidth = 30
    vim.g.undotree_CustomUndotreeCmd = "vertical 32 new"
    vim.g.undotree_CustomDiffpanelCmd = "belowright 12 new"
    vim.g.undotree_SetFocusWhenToggle = 0
    vim.g.undotree_HelpLine = 0
  end,
}
