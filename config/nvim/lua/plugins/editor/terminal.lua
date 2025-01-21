return {
  "akinsho/toggleterm.nvim", version = "*",
  cmd = { "ToggleTerm" },
  keys = {
    { "<leader>ter", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" }
  },
  opts = {
    highlights = {
      Normal = {
        guibg = "#16161D",
      },
    },
    border = "single",
    shade_terminals = false,
  }
}
