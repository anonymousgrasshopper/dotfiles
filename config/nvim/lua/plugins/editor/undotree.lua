return {
  "mbbill/undotree",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "Undotree" },
  keys = {
    { "<leader>tr", vim.cmd.UndotreeToggle, desc = "Toggle UndoTree" }
  },
  config = function ()
    vim.g.undotree_SplitWidth = 30
  end
}
