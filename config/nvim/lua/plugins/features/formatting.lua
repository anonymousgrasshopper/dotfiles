vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>format",
      function()
        require("conform").format({
          async = true,
        })
      end,
      mode = { "n", "v" },
      desc = "Format file or range (in visual mode)",
    },
  },
  opts = {
    formatters_by_ft = {
      cpp = { "clang_format_config" },
      lua = { "stylua" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      sh = { "shfmt" },
      -- python = { "isort", "black" },
      ["_"] = { "trim_whitespace" },
    },
    formatters = {
      clang_format_config = {
        command = "clang-format",
        args = "--style=file:$HOME/.config/clang-format",
      },
    },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
  },
}
