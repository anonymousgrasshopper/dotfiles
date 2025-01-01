return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function()
    local Rule = require("nvim-autopairs.rule")
    local pairs = require("nvim-autopairs")

    require("nvim-autopairs").setup()

    pairs.add_rules({
      Rule("$", "$", "tex"),
      Rule("\\[", "\\]", "tex"),
    })
  end
}
