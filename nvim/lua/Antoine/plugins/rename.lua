return {
  "smjonas/inc-rename.nvim",
  lazy = true,
  config = function()
    require("inc_rename").setup({
      cmd_name = "Rename",
    })
    vim.keymap.set("n", "<leader>rn", ":Rename", { desc = "New identifier" })
  end
}
