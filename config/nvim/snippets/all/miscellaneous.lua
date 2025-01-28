local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({ trig = "{ ", dscr = "braces padding", wordTrig = false, snippetType = "autosnippet" },
    {
      t("{ "),
      i(0),
      t(" ")
    }
  ),
}
