return {
  "smjonas/inc-rename.nvim",
  keys = {
    { "<leader>rn", ":Rename ", desc = "Change identifier" },
  },
  config = function()
    require("inc_rename").setup({
      cmd_name = "Rename",
    })
  end
}
