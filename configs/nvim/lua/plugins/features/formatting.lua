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
      "<leader>fmt",
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
      cpp = { "clang_format" },
      lua = { "stylua" },
      bash = { "shfmt" },
      sh = { "shfmt" },
      tex = { "tex-fmt" },
      html = { "superhtml" },
      css = { "prettier" },
      js = { "prettier" },
      ["_"] = { "trim_whitespace" },
    },
    formatters = {
      clang_format = {
        command = "clang-format",
        args = "--style=file:$HOME/.config/clang-format",
      },
    },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end

      local disabled_paths = { "nvim/snippets", "nvim/lua/config/options.lua", "zsh/.zshrc" }
      for _, disabled_path in ipairs(disabled_paths) do
        if vim.api.nvim_buf_get_name(0):match(disabled_path) then return end
      end

      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
  },
}
