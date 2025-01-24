local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  s({ trig = "if ", dscr = "conditional statement", snippetType = "autosnippet" },
    fmta(
      "if <>; then\n\t<>\nfi",
      {
        i(1),
        i(2),
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "if [", dscr = "test condition", snippetType = "autosnippet" },
    fmta(
      "if [[ <> ]",
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "for ", dscr = "for loop", snippetType = "autosnippet" },
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
