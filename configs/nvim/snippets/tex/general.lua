local ls = require("snippet/luasnip")
local s, t, i, fmt = ls.s, ls.t, ls.i, ls.fmt
local helpers = require("snippet/helpers")
local first_line, line_begin = helpers.first_line, helpers.line_begin
local tex = require("snippet/tex_utils")

return {
	s(
		{
			trig = "tmp",
			dscr = "template",
			snippetType = "autosnippet",
			condition = first_line * line_begin,
		},
		fmt(
			[[
        \documentclass[<>]{<>}

        \begin{document}
        \title{<>}
        \author{<>}
        \date{\today}
        \maketitle
        <>
        \end{document}
      ]],
			{
				i(3, "article"),
				i(4, "11pt"),
				i(1),
				i(2),
				i(0),
			}
		)
	),
	s(
		{
			trig = "toc",
			dscr = "Table of contents",
			snippetType = "autosnippet",
			condition = tex.in_text * line_begin,
		},
		fmt(
			[[
        \tablofcontents
        <>
      ]],
			{
				i(0),
			}
		)
	),
	s(
		{
			trig = "pkg",
			dscr = "include package",
			snippetType = "autosnippet",
			condition = tex.in_text * line_begin * tex.in_preamble,
		},
		fmt("\\usepackage[<>]{<>}", {
			i(2),
			i(1),
		})
	),
	s(
		{
			trig = "fr",
			dscr = "Français",
			snippetType = "autosnippet",
			condition = tex.in_text * line_begin * tex.in_preamble,
		},
		fmt(
			[[
        \usepackage[T1]{fontenc}
        \usepackage[french]{babel}
      ]],
			{}
		)
	),
	s(
		{
			trig = "...",
			dscr = "dots",
			wordTrig = false,
			snippetType = "autosnippet",
			condition = tex.in_text,
		},
		{
			t("\\dots"),
		}
	),
}
