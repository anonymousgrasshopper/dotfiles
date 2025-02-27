local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node

local line_begin = require("luasnip.extras.expand_conditions").line_begin

local check_not_in_node = function(ignored_nodes)
  local pos = vim.api.nvim_win_get_cursor(0)
  local row, col = pos[1] - 1, pos[2] - 1
  local node_type = vim.treesitter.get_node({ pos = { row, col } }):type()
  return not vim.tbl_contains(ignored_nodes, node_type)
end

local not_in_string_comment = function()
  return check_not_in_node({ "string_content", "comment" })
end

return {
  s({ trig = "template", dscr = "template", snippetType = "autosnippet" },
    {
      t("template <typename "),
      i(1, "T"),
      t({ ">", "" }),
      i(0),
    },
    { condition = not_in_string_comment }
  ),
  s({ trig = "inc ", dscr = "include preprocessor directive", snippetType = "autosnippet" },
    {
      c(1, {
        { t("#include <"), i(1), t({ ">", "" }), i(0) },
        { t('#include "'), i(1), t({ '"', ""}), i(0) },
      }),
    },
    { condition = line_begin, not_in_string_comment }
  ),
  s({ trig = "([^%w_]%s*)virt", dscr = "virtual member function", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    {
      f( function(_, snip) return snip.captures[1] end ),
      t("virtual "),
    }
  ),
}
