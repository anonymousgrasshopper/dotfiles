local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local line_begin = require("luasnip.extras.expand_conditions").line_begin

local first_line = function()
  return vim.api.nvim_win_get_cursor(0)[1] == 1
end

return {
  s({ trig = "#!", dscr = "shebang", snippetType = "autosnippet" },
    {
      t("#!/bin/"),
      i(1, "bash"),
      t({ "", "" }),
      i(0),
    },
    { condition = first_line * line_begin }
  ),
}
