local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmta

local rec_item
rec_item = function()
	return sn(
		nil,
		c(1, {
			t(""),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_item, {}) }),
		})
	)
end

local tex = {}
tex.in_text = function() return vim.fn["vimtex#syntax#in_mathzone"]() ~= 1 end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
	s(
		{ trig = "beg", dscr = "Environment", snippetType = "autosnippet" },
		fmt(
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
		{ condition = line_begin }
	),
	s(
		{ trig = "\\beg", dscr = "Environment", snippetType = "autosnippet" },
		fmt(
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
		)
	),
	s(
		{ trig = "\\?se", dscr = "section", regTrig = true, snippetType = "autosnippet" },
		fmt(
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
	s(
		{ trig = "\\?sb", dscr = "section", regTrig = true, snippetType = "autosnippet" },
		fmt(
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
	s({ trig = "\\?ls", dscr = "unordered list", regTrig = true, snippetType = "autosnippet" }, {
		t({ "\\begin{itemize}", "\t\\item " }),
		i(1),
		d(2, rec_item, {}),
		t({ "", "\\end{itemize}" }),
	}, { condition = tex.in_text * line_begin }),
	s(
		{ trig = "\\?enn", dscr = "orderdered list", regTrig = true, snippetType = "autosnippet" },
		fmt(
			[[
      \begin{enumerate}

          \item <>

      \end{enumerate}
    ]],
			{
				i(0),
			}
		),
		{ condition = tex.in_text * line_begin }
	),
}
