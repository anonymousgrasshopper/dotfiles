local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta

local get_visual = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

local tex = {}
tex.in_mathzone = function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end
tex.in_text = function() return not tex.in_mathzone() end

return {
  s({ trig = "[", descr = "display math",  wordTrig = "false", snippetType = "autosnippet" },
    fmta(
      "\\[<>\\",
      {
        i(1),
      }
    )
  ),
  s({ trig = "$", descr = "inline math",  wordTrig = "false", snippetType = "autosnippet" },
    fmta(
      "$<>$",
      {
        i(1),
      }
    )
  ),
  s({ trig = "sm", descr = "sum", wordTrig = "false", snippetType = "autosnippet" },
    fmta(
      [[
        \sum_{<>=<>}^{<>}<>
      ]],
      {
        i(2, "i"),
        i(3, "0"),
        i(4, "n"),
        i(1),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "pd", descr = "product", wordTrig = "false", snippetType = "autosnippet" },
    fmta(
      [[
        \prod_{<>=<>}^{<>}<>
      ]],
      {
        i(2, "i"),
        i(3, "0"),
        i(4, "n"),
        i(1),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "ff", descr = "fraction", wordTrig = "false", snippetType = "autosnippet" },
    fmta(
      "\\frac{<>}{<>}",
      {
        i(1),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "([%w%)%]%}])'", descr = "superscript", wordTrig=false, regTrig = true, snippetType="autosnippet" },
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  s({ trig = "([%w%)%]%}]);", descr = "subscript wordTrig=false", regTrig = true, snippetType="autosnippet" },
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    {condition = tex.in_mathzone}
  ),
  s({ trig = "([%w%)%]%}])__", descr = "subscript and superscript", wordTrig=false, regTrig = true, snippetType="autosnippet" },
    fmta(
      "<>^{<>}_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2),
      }
    ),
    {condition = tex.in_mathzone}
  ),
}
