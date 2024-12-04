return {
  "gbprod/yanky.nvim",
  lazy = true,
  keys = {
    {"p", "<Plug>(YankyPutAfter)"},
    {"P", "<Plug>(YankyPutBefore)"},
    {"gp", "<Plug>(YankyGPutAfter)"},
    {"gP", "<Plug>(YankyGPutBefore)"},

    {"<c-p>", "<Plug>(YankyPreviousEntry)"},
    {"<c-n>", "<Plug>(YankyNextEntry)"},

    {"]p", "<Plug>(YankyPutIndentAfterLinewise)"},
    {"[p", "<Plug>(YankyPutIndentBeforeLinewise)"},
    {"]P", "<Plug>(YankyPutIndentAfterLinewise)"},
    {"[P", "<Plug>(YankyPutIndentBeforeLinewise)"},

    {">p", "<Plug>(YankyPutIndentAfterShiftRight)"},
    {"<p", "<Plug>(YankyPutIndentAfterShiftLeft)"},
    {">P", "<Plug>(YankyPutIndentBeforeShiftRight)"},
    {"<P", "<Plug>(YankyPutIndentBeforeShiftLeft)"},

    {"=p", "<Plug>(YankyPutAfterFilter)"},
    {"=P", "<Plug>(YankyPutBeforeFilter)"},

    {"y", "<Plug>(YankyYank)"},
  },
  config = function()
    require("yanky").setup({
      ring = {
        history_length = 10,
      },
    })
  end
}
