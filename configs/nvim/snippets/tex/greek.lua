local ls = require("snippets.luasnip")
local s, t = ls.s, ls.t
local tex = require("snippet/tex_utils")

return {
	s({ trig = ";a", snippetType = "autosnippet" }, {
		t("\\alpha"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";b", snippetType = "autosnippet" }, {
		t("\\beta"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";g", snippetType = "autosnippet" }, {
		t("\\gamma"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";G", snippetType = "autosnippet" }, {
		t("\\Gamma"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";d", snippetType = "autosnippet" }, {
		t("\\delta"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";D", snippetType = "autosnippet" }, {
		t("\\Delta"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";e", snippetType = "autosnippet" }, {
		t("\\epsilon"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";ve", snippetType = "autosnippet" }, {
		t("\\varepsilon"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";z", snippetType = "autosnippet" }, {
		t("\\zeta"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";h", snippetType = "autosnippet" }, {
		t("\\eta"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";o", snippetType = "autosnippet" }, {
		t("\\theta"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";vo", snippetType = "autosnippet" }, {
		t("\\vartheta"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";O", snippetType = "autosnippet" }, {
		t("\\Theta"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";k", snippetType = "autosnippet" }, {
		t("\\kappa"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";l", snippetType = "autosnippet" }, {
		t("\\lambda"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";L", snippetType = "autosnippet" }, {
		t("\\Lambda"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";m", snippetType = "autosnippet" }, {
		t("\\mu"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";n", snippetType = "autosnippet" }, {
		t("\\nu"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";x", snippetType = "autosnippet" }, {
		t("\\xi"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";X", snippetType = "autosnippet" }, {
		t("\\Xi"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";i", snippetType = "autosnippet" }, {
		t("\\pi"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";I", snippetType = "autosnippet" }, {
		t("\\Pi"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";r", snippetType = "autosnippet" }, {
		t("\\rho"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";s", snippetType = "autosnippet" }, {
		t("\\sigma"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";S", snippetType = "autosnippet" }, {
		t("\\Sigma"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";t", snippetType = "autosnippet" }, {
		t("\\tau"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";f", snippetType = "autosnippet" }, {
		t("\\phi"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";vf", snippetType = "autosnippet" }, {
		t("\\varphi"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";F", snippetType = "autosnippet" }, {
		t("\\Phi"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";c", snippetType = "autosnippet" }, {
		t("\\chi"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";p", snippetType = "autosnippet" }, {
		t("\\psi"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";P", snippetType = "autosnippet" }, {
		t("\\Psi"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";w", snippetType = "autosnippet" }, {
		t("\\omega"),
	}, { condition = tex.in_mathzone }),
	s({ trig = ";W", snippetType = "autosnippet" }, {
		t("\\Omega"),
	}, { condition = tex.in_mathzone }),
}
