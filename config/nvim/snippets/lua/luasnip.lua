local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  s({ trig = "snp", dscr = "LuaSnip lua snippet template", snippetType = "autosnippet" },
    fmta(
      [=[
        s({ trig = "<>", dscr = "<>"<><><> },
          fmta([[
              <>
            ]],
            {
              <>
            }
          )
        )
      ]=],
      {
        i(1),
        i(2),
        i(3, ", regTrig = true"),
        i(4, ", wordTrig = false"),
        i(5, ", snippetType = \"autosnippet\""),
        i(6),
        i(7),
      }
    ),
    { condition = line_begin }
  )
}
