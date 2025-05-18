local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmta
local make_condition = require("luasnip.extras.conditions").make_condition

local tex = {}
tex.in_text = function() return vim.fn["vimtex#syntax#in_mathzone"]() ~= 1 end

local line_begin = require("luasnip.extras.expand_conditions").line_begin
local first_line = make_condition(function() return vim.api.nvim_win_get_cursor(0)[1] == 1 end)

return {
	s(
		{ trig = "tmp", dscr = "template", snippetType = "autosnippet" },
		fmt(
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
		{ condition = first_line * line_begin }
	),
	s(
		{ trig = "toc", dscr = "Table of contents", snippetType = "autosnippet" },
		fmt(
			[[
        \tablofcontents
        <>
      ]],
			{
				i(0),
			}
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "pkg", dscr = "include package", snippetType = "autosnippet" },
		fmt("\\usepackage[<>]{<>}", {
			i(2),
			i(1),
		}),
		{ condition = tex.in_text * line_begin }
	),
	s(
		{ trig = "fr", dscr = "Français", snippetType = "autosnippet" },
		fmt(
			[[
        \usepackage[T1]{fontenc}
        \usepackage[french]{babel}
      ]],
			{}
		),
		{ condition = tex.in_text * line_begin }
	),
}
