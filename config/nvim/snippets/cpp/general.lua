local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local f = ls.function_node
local sn = ls.snippet_node
local fmta = require("luasnip.extras.fmt").fmta

local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

local check_not_in_node = function(ignored_nodes)
  local pos = vim.api.nvim_win_get_cursor(0)
  local row, col = pos[1] - 1, pos[2] - 1

  local node_type = vim.treesitter
    .get_node({
      pos = { row, col },
    })
    :type()

  return not vim.tbl_contains(ignored_nodes, node_type)
end

local out_of_string_comment = function()
  return check_not_in_node({ "string", "comment" })
end

return {
  s({ trig = "if ", dscr = "conditional statement", snippetType = "autosnippet" },
    fmta("if (<>) {\n\t<>\n}<>", {
      i(1),
      d(2, get_visual),
      i(0),
    }),
    { condition = line_begin, out_of_string_comment }
  ),
  s({ trig = "for ", dscr = "for loop", snippetType = "autosnippet" },
    fmta(
      [[
        for (<>) {
          <>
        }<>
      ]],
      {
        i(1),
        d(2, get_visual),
        i(0),
      }
    ),
    { condition = out_of_string_comment }
  ),
  s({ trig = "while ", dscr = "while loop", snippetType = "autosnippet" },
    fmta(
      [[
        while (<>) {
          <>
        }<>
      ]],
      {
        i(1),
        d(2, get_visual),
        i(0),
      }
    ),
    { condition = out_of_string_comment }
  ),
  s({ trig = "template", dscr = "template", snippetType = "autosnippet" },
    {
      t("template <typename "),
      i(1, "T"),
      t({ ">", "" }),
      i(0),
    },
    { condition = out_of_string_comment }
  ),
  s({ trig = "inc ", dscr = "include preprocessor directive", snippetType = "autosnippet" },
    {
      c(1, { sn(nil, { t("#include <"), i(1), t(">"), i(0) }), sn(nil, { t('#include "'), i(1), t('"'), i(0) }) }),
    },
    { condition = line_begin, out_of_string_comment }
  ),
  s({ trig = "namespace%s+([%w_]+)%s", regTrig = true, dscr = "namespace template", snippetType = "autosnippet" },
    {
      t("namespace "),
      f(function(_, snip) return snip.captures[1] end),
      t({ " {", "\t" }),
      i(0),
      t({ "", "}" })
    },
    { condition = out_of_string_comment }
  )
}
