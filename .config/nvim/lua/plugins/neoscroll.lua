return {
  "karb94/neoscroll.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function ()
    require('neoscroll').setup({
      mappings = {
        '<C-u>', '<C-d>',  -- up / down
        '<C-b>', '<C-f>',  -- forward /backwards
        '<C-y>', '<C-e>',  -- 3 lines up/down
        'zt', 'zz', 'zb',  -- top / center /bottom  line
      },
    })
  end
}
