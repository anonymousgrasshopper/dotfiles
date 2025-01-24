local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

return {
  s({ trig = "class%s+([%w_]+)%s", regTrig = true, dscr = "class template", snippetType = "autosnippet" },
    fmta(
      [[
        class <> {
          <>
        }<>;
      ]],
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(0)
      }
    )
  ),
  s({ trig = "struct%s+([%w_]+)%s", regTrig = true, dscr = "struct template", snippetType = "autosnippet" },
    fmta(
      [[
        class <> {
          <>
        }<>;
      ]],
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(0)
      }
    )
  )
}
