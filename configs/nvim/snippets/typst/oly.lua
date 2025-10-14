local ls = require("snippets.luasnip")
local s, t, i, c, d, sn, rep, fmt =
      ls.s, ls.t, ls.i, ls.c, ls.d, ls.sn, ls.rep, ls.fmt
local helpers = require("snippets.helpers")
local line_begin = helpers.line_begin

return {
	s({ trig = "!T", dscr = "theorem", snippetType = "autosnippet", cond = line_begin },
		fmt(
			[[
				#theorem[
					<>
				]
			]],
			{
				i(1),
			}
		)
	),
	s({ trig = "!thm", dscr = "theorem", snippetType = "autosnippet", cond = line_begin },
		fmt(
			[[
				#theorem[
					<>
				]
			]],
			{
				i(1),
			}
		)
	),
	s({ trig = "!L", dscr = "lemma", snippetType = "autosnippet", cond = line_begin },
		fmt(
			[[
				#lemma[
					<>
				]
			]],
			{
				i(1),
			}
		)
	),
	s({ trig = "!lem", dscr = "lemma", snippetType = "autosnippet", cond = line_begin },
		fmt(
			[[
				#lemma[
					<>
				]
			]],
			{
				i(1),
			}
		)
	),
	s({ trig = "!P", dscr = "proof", snippetType = "autosnippet", cond = line_begin },
		fmt(
			[[
				#proof[
					<>
				]
			]],
			{
				i(1),
			}
		)
	),
	s({ trig = "!C", dscr = "corollary", snippetType = "autosnippet", cond = line_begin },
		fmt(
			[[
				#corollary[
					<>
				]
			]],
			{
				i(1),
			}
		)
	),
	s({ trig = "!cor", dscr = "corollary", snippetType = "autosnippet", cond = line_begin },
		fmt(
			[[
				#corollary[
					<>
				]
			]],
			{
				i(1),
			}
		)
	),
	s({ trig = "!prop", dscr = "proposition", snippetType = "autosnippet", cond = line_begin },
		fmt(
			[[
				#proposition[
					<>
				]
			]],
			{
				i(1),
			}
		)
	),
	s({ trig = "!E", dscr = "exercise", snippetType = "autosnippet", cond = line_begin },
		fmt(
			[[
				#exercise[
					<>
				]
			]],
			{
				i(1),
			}
		)
	),
	s({ trig = "!Q", dscr = "question", snippetType = "autosnippet", cond = line_begin },
		fmt(
			[[
				#question[
					<>
				]
			]],
			{
				i(1),
			}
		)
	),
}
