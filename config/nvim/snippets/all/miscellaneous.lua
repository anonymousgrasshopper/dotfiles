local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  s({ trig = "#!", dscr = "shebang", snippetType = "autosnippet" },
    {
      t("#!/bin/"),
      i(1, "bash"),
      t({ "", "" }),
      i(0),
    },
    { condition = line_begin }
  ),
}
