local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local add_brace_padding = function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()

  return line:sub(col + 1, col + 1) == "}"
end

return {
  s({ trig = "{ ", dscr = "braces padding", wordTrig = false, snippetType = "autosnippet" },
    {
      t("{ "),
      i(0),
      t(" "),
    },
    { condition = add_brace_padding }
  ),
}
