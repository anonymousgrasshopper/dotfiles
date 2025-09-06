local ls = require("snippets.luasnip")
local s, t, c = ls.s, ls.t, ls.c
local helpers = require("snippets.helpers")
local tex = require("snippets.tex_utils")

return {
	s(
		{
			trig = "SPA ",
			dscr = "reductio ad absurdum",
			wordTrig = true,
			snippetType = "autosnippet",
			condition = tex.in_text * tex.in_document * tex.not_in_cmd,
		},
		{
			c(1, {
				{ t("Supposons par l'absurde ") },
				{ t("Assume for the sake of contradiction ") },
			})
		}
	),
	s(
		{
			trig = "Wlog ",
			dscr = "without loss of generality",
			wordTrig = true,
			snippetType = "autosnippet",
			condition = tex.in_text * tex.in_document * tex.not_in_cmd,
		},
		{
			c(1, {
				{ t("Supposons sans perte de généralité que ") },
				{ t("Without loss of generality, ") },
			})
		}
	),
	s(
		{
			trig = "wlog ",
			dscr = "without loss of generality",
			wordTrig = true,
			snippetType = "autosnippet",
			condition = tex.in_text * tex.in_document * tex.not_in_cmd,
		},
		{
			c(1, {
				{ t("supposons sans perte de généralité que ") },
				{ t("without loss of generality, ") },
			})
		}
	),
}
