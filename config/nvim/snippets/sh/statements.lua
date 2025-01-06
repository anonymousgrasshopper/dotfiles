local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  s({ trig = "if ", descr = "if", snippetType = "autosnippet" },
    fmta("if [[ <> ]]; then\n\t<>\nfi",
      {
        i(1),
        i(2),
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "for ", descr = "for loop", snippetType = "autosnippet" },
    fmta(
      [[
        for <>; do
          <>
        done
      ]],
      {
        i(1),
        i(2)
      }
    ),
    { condition = line_begin }
  )
}
