local ls = require("luasnip")
local t = ls.text_node
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
tex.in_mathzone = function() return vim.fn["vimtex#syntax#in_mathzone"]() == 1 end

return {
  s({ trig = "[", dscr = "math mode", wordTrig = false, snippetType ="autosnippet" },
    {
      t("\\["),
      i(1),
      t("\\"),
    },
    {
      condition = function()
        if vim.fn["vimtex#syntax#in_mathzone"]() == 1 then
          return false
        end
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local line = vim.api.nvim_get_current_line()
        if col == 0 then
          return true
        end
        return line:sub(col, col) ~= "\\"
      end
    }
  ),
  s({ trig = "sm", dscr = "sum", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      [[
        \sum_{<>=<>}^{<>}<>
      ]],
      {
        i(1, "i"),
        i(2, "0"),
        i(3, "n"),
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "pd", dscr = "product", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      [[
        \prod_{<>=<>}^{<>}<>
      ]],
      {
        i(1, "i"),
        i(2, "0"),
        i(3, "n"),
        i(0),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "ff", dscr = "fraction", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      "\\frac{<>}{<>}",
      {
        i(1),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "\\floor", dscr = "floor", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      "\\left\\lfoor <> \\right\\rfloor",
      {
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "\\ceil", dscr = "ceil", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      "\\left\\lceil <> \\right\\rceil",
      {
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "sq", dscr = "square root", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      "\\sqrt{<>}",
      {
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "\\cbrt", dscr = "cubic root", wordTrig = false, snippetType = "autosnippet" },
    fmta(
      "\\sqrt[3]{<>}",
      {
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "cd", dscr = "cdot", wordTrig = false, snippetType = "autosnippet"},
    t("\\cdot"),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "ty", dscr = "lemniscate", snippetType = "autosnippet" },
    t("\\infty"),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "([%w%)%]%}])'", dscr = "superscript", wordTrig = false, regTrig = true, snippetType="autosnippet" },
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "([%w%)%]%}]);", dscr = "subscript", wordTrig = false, regTrig = true, snippetType="autosnippet" },
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "([%w%)%]%}])__", dscr = "subscript and superscript", wordTrig = false, regTrig = true, snippetType="autosnippet" },
    fmta(
      "<>^{<>}_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2),
      }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "²", dscr = "square", wordTrig = false, snippetType = "autosnippet" },
    t("^2"),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "all ", dscr = "universal quantifier", wordTrig = false, snippetType = "autosnippet" },
    t("\\forall "),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "ex ", dscr = "existensial quantifier", wordTrig = false, snippetType = "autosnippet" },
    t("\\exists "),
    { condition = tex.in_mathzone }
  ),
  s({ trig = "ds", dscr = "displaystyle", wordTrig = false, snippetType = "autosnippet" },
    {
      t("\\displaystyle"),
    },
    { condition = tex.in_mathzone }
  ),
  s({ trig = "\\N", dscr = "Natural numbers set", snippetType = "autosnippet" },
    {
      t("\\mathbb{N}")
    },
    { condition = tex.in_mathzone }
  ),
  s({ trig = "\\Q", dscr = "Rational numbers set", snippetType = "autosnippet" },
    {
      t("\\mathbb{Q}")
    },
    { condition = tex.in_mathzone }
  ),
  s({ trig = "\\R", dscr = "Real numbers set", snippetType = "autosnippet" },
    {
      t("\\mathbb{R}")
    },
    { condition = tex.in_mathzone }
  ),
  s({ trig = "\\C", dscr = "Complex numbers set", snippetType = "autosnippet" },
    {
      t("\\mathbb{C}")
    },
    { condition = tex.in_mathzone }
  ),
}
