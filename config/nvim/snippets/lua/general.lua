local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local get_visual = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  s({ trig = "if ", dscr = "conditional statement", snippetType = "autosnippet" },
    fmta(
      "if <> then\n\t<>\nend<>",
      {
        i(1),
        d(2, get_visual),
        i(0)
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "for ", dscr = "for loop", snippetType = "autosnippet" },
    fmta(
      [[
        for <> do
          <>
        end<>
      ]],
      {
        i(1),
        d(2, get_visual),
        i(0)
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "function ", dscr = "function", snippetType = "autosnippet" },
    fmta(
      [[
        function(<>)
          <>
        end<>
      ]],
      {
        i(1),
        d(2, get_visual),
        i(0)
      }
    ),
    { condition = line_begin }
  ),
  s({ trig = "func ", dscr = "function", snippetType = "autosnippet" },
    fmta(
      [[
        function(<>)
          <>
        end<>
      ]],
      {
        i(1),
        d(2, get_visual),
        i(0)
      }
    ),
    { condition = line_begin }
  )
}
