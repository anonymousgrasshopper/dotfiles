local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local tex = {}
tex.in_text = function() return vim.fn['vimtex#syntax#in_mathzone']() ~= 1 end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  s({ trig = "tmp", descr = "template", wordTrig = "false", snippetType = "autosnippet" },
    fmta(
      [[
        \documentclass{<>}
        \title{<>}
        \author{<>}
        \date{\today}

        \begin{document}
          \maketitle
          <>
        \end{document}
      ]],
      {
        i(3, "article"),
        i(1),
        i(2),
        i(0),
      }
    ),
    { condition = tex.in_text * line_begin }
  ),
  s({ trig = "toc", descr = "Table of contents", snippetType = "autosnippet" },
    t("\\tableofcontents"),
    { condition = line_begin }
  ),
  s({ trig = "pck", descr = "include package", snippetType = "autosnippet"},
    fmta(
      "\\usepackage[<>]{<>}",
      {
        i(2),
        i(1),
      }
    ),
    { condition = tex.in_text * line_begin }
  ),
  s({ trig = "fr", descr = "Français", snippetType = "autosnippet" },
    fmta(
      [[
        \usepackage[T1]{fontenc}
        \usepackage[french]{babel}
      ]],
      {}
    ),
    { condition = tex.in_text * line_begin }
  )
}
