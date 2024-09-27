return {
  "karb94/neoscroll.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function ()
    require('neoscroll').setup({
      mappings = {
        '<C-u>', '<C-d>',
        '<C-b>', '<C-f>',
        '<C-y>', '<C-e>',
        'zt', 'zz', 'zb',
      },
    })
  end
}
