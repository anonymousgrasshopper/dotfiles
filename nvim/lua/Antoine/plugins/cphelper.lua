return {
  "p00f/cphelper.nvim",
  name = "cphelper",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("cphelper").setup()
  end
}
