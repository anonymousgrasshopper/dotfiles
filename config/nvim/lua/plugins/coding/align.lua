return {
  "junegunn/vim-easy-align",
  keys = {
    { "gl", "<Plug>(EasyAlign)", mode = { "n", "v" }, desc = "Align text interactively" },
  },
  config = function() vim.g.easy_align_bypass_fold = 1 end,
}
