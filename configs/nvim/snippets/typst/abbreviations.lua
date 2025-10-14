local ls = require("snippets.luasnip")
local s, t, c = ls.s, ls.t, ls.c
local tex = require("snippets.tex_utils")

return {
	s(
		{
			trig = "SPA ",
			dscr = "reductio ad absurdum",
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
			snippetType = "autosnippet",
			condition = tex.in_text * tex.in_document * tex.not_in_cmd,
		},
		{
			c(1, {
				{ t("sans perte de généralité ") },
				{ t("without loss of generality ") },
			})
		}
	),
	s(
		{
			trig = "apcr ",
			dscr = "à partir d'un certain rang",
			snippetType = "autosnippet",
			condition = tex.in_text * tex.in_document * tex.not_in_cmd,
		},
		{
			t("à partir d'un certain rang")
		}
	),
	s(
		{
			trig = "Apcr ",
			dscr = "À partir d'un certain rang",
			snippetType = "autosnippet",
			condition = tex.in_text * tex.in_document * tex.not_in_cmd,
		},
		{
			t("À partir d'un certain rang") }
	),
}
