local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
	s({ trig = "^(%s*[%-%w]+:%s+)", dscr = "auto add semicolon", regTrig = true, snippetType = "autosnippet" }, {
		f(function(_, snip) return snip.captures[1] end),
		i(1),
		t(";"),
		i(0),
	}, {
		condition = function()
			local col = vim.fn.col(".")
			local line = vim.fn.getline(".")
			return col - 1 == #line
		end,
	}),
	s({ trig = "!i", dscr = "!important keyword", snippetType = "autosnippet" }, { t("!important") }),
}
