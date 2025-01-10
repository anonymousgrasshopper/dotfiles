return {
  "stevearc/conform.nvim",
  keys = {
    {
      "<leader>format", function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end,
      mode = { "n", "v" },
      desc = "Format file or range (in visual mode)"
    }
  },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        cpp = { "clang_format" },
        lua = { "stylua" },
        python = { "isort", "black" },
      },
      -- format_on_save = {
      -- 	lsp_fallback = true,
      -- 	async = false,
      -- 	timeout_ms = 1000,
      -- },
    })
  end,
}
