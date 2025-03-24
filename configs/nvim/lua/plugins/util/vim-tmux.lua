return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-h>", "<Cmd><C-U>TmuxNavigateLeft<CR>" },
    { "<c-j>", "<Cmd><C-U>TmuxNavigateDown<CR>" },
    { "<c-k>", "<Cmd><C-U>TmuxNavigateUp<CR>" },
    { "<c-l>", "<Cmd><C-U>TmuxNavigateRight<CR>" },
    { "<c-\\>", "<Cmd><C-U>TmuxNavigatePrevious<CR>" },
  },
}
