local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

local tex = {}
tex.in_text = function() return vim.fn['vimtex#syntax#in_mathzone']() ~= 1 end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  s({ trig = "env", descr = "Environment", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{<>}
          <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        rep(1),
      }
    ),
    { condition = tex.in_text * line_begin }
  ),
  s({ trig = "se", descr = "section", snippetType = "autosnippet" },
    fmta(
      [[
        \section<>{<>}
      ]],
      {
        i(2),
        i(1),
      }
    ),
    { condition = tex.in_text * line_begin }
  ),
  s({ trig = "sb", descr = "section", snippetType = "autosnippet" },
    fmta(
      [[
        \subsection<>{<>}
      ]],
      {
        i(2),
        i(1),
      }
    ),
    { condition = tex.in_text * line_begin }
  ),
}
