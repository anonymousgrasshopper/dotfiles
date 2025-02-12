return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local Rule = require("nvim-autopairs.rule")
      local pairs = require("nvim-autopairs")

      require("nvim-autopairs").setup()

      pairs.add_rules({
        Rule("$", "$", "tex"),
        Rule("\\[", "\\]", "tex"),
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "markdown",
      "typescript",
    },
    config = function() require("nvim-ts-autotag").setup() end,
  },
}
