local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

return {
  s({ trig = "([^%w_])all%(", regTrig = true, wordTrig = false, dscr = "iterator range", snippetType = "autosnippet" },
    fmta(
        "<><>.begin(), <>.end(",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        rep(1),
      }
    )
  ),
  s({ trig = "([^%w_])rall%(", regTrig = true, wordTrig = false, dscr = "reverse iterator range", snippetType = "autosnippet" },
    fmta(
        "<><>.rbegin(), <>.rend(",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        rep(1),
      }
    )
  ),
}
