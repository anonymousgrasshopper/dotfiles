return {
  "karb94/neoscroll.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    mappings = {
      '<C-u>', '<C-d>',  -- up / down
      '<C-b>', '<C-f>',  -- forward /backwards
      '<C-y>', '<C-e>',  -- 3 lines up/down
      'zt', 'zz', 'zb',  -- top / center /bottom  line
    },
    hide_cursor = false,
    duration_multiplier = 0.9,
    easing = "sine",
  }
}
