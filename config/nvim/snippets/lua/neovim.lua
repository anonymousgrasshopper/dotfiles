local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  s({ trig = "autocmd ", dscr = "Neovim API autocmd", wordTrig = false, snippetType = "autosnippet" },
    fmta([[
        vim.api.nvim_create_autocmd("<>", {
          <>
        })
      ]],
      {
        i(1),
        i(2),
      }
    ),
    { condition = line_begin }
  )
}
