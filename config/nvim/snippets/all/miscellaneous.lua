local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local compare_next_char = function(arg)
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()

  return line:sub(col + 1, col + 1) == arg
end

local next_char_brace = function()
  return compare_next_char("}")
end

local next_char_bracket = function()
  return compare_next_char("]")
end

local next_char_parenthesis = function()
  return compare_next_char(")")
end

return {
  s({ trig = "{ ", dscr = "braces padding", wordTrig = false, snippetType = "autosnippet" },
    {
      t("{ "),
      i(0),
      t(" "),
    },
    { condition = next_char_brace }
  ),
  s({ trig = "[ ", dscr = "brackets padding", wordTrig = false, snippetType = "autosnippet" },
    {
      t("[ "),
      i(0),
      t(" "),
    },
    { condition = next_char_bracket }
  ),  s({ trig = "( ", dscr = "brackets padding", wordTrig = false, snippetType = "autosnippet" },
    {
      t("( "),
      i(0),
      t(" "),
    },
    { condition = next_char_parenthesis }
  ),
}
