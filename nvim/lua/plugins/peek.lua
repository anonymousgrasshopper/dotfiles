return {
  "toppair/peek.nvim",
  lazy = true,
  build = "deno task --quiet build:fast",
  config = function()
    require("peek").setup({
      auto_load = false,
    })
    vim.api.nvim_create_user_command("MdOpen", require("peek").open, {})
    vim.api.nvim_create_user_command("MdClose", require("peek").close, {})
  end,
}
