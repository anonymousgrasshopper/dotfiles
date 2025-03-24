return {
  "lervag/vimtex",
  config = function()
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_syntax_conceal_disable = false
    vim.g.vimtex_format_enabled = 1
    vim.g.vimtex_mappings_prefix = "<localleader>l"
  end,
}
