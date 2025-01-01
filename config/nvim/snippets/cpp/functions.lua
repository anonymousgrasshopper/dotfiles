local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

return {
  s({ trig = "([^%w%d_])all(", descr = "iterator range", snippetType = "autosnippet" },
    fmta(
        "<><>.begin(), <>.end()",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        rep(1),
      }
    )
  ),
  s({ trig = "([^%w%d_])rall(", descr = "reverse iterator range", snippetType = "autosnippet" },
    fmta(
        "<><>.rbegin(), <>.rend()",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        rep(1),
      }
    )
  ),
}
