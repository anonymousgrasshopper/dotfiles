return {
  "smjonas/inc-rename.nvim",
  lazy = true,
  keys = {
    { "<leader>rn", ":Rename", desc = "Change identifier" },
  },
  config = function()
    require("inc_rename").setup({
      cmd_name = "Rename",
    })
  end
}
