local ls = require("luasnip")
local t = ls.text_node
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmta
local make_condition = require("luasnip.extras.conditions").make_condition

local get_visual = function(_, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else -- If LS_SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

local tex = {}
tex.in_mathzone = function() return vim.fn["vimtex#syntax#in_mathzone"]() == 1 end
tex.in_text = function() return vim.fn["vimtex#syntax#in_mathzone"]() ~= 1 end

return {
	s({ trig = "[", dscr = "math mode", wordTrig = false, snippetType = "autosnippet" }, {
		t("\\["),
		i(1),
		t("\\"),
	}, {
		condition = tex.in_text * make_condition(function()
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local line = vim.api.nvim_get_current_line()
			return (col == 0) or line:sub(col, col) ~= "\\"
		end),
	}),
	s(
		{ trig = "sm", dscr = "sum", wordTrig = false, snippetType = "autosnippet" },
		fmt(
			[[
        \sum_{<>}^{<>}<>
      ]],
			{
				i(1, "i = 0"),
				i(2, "n"),
				i(0),
			}
		),
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = "pd", dscr = "product", wordTrig = false, snippetType = "autosnippet" },
		fmt(
			[[
        \prod_{<>}^{<>}<>
      ]],
			{
				i(1, "i = 0"),
				i(2, "n"),
				i(0),
			}
		),
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = "ff", dscr = "fraction", wordTrig = false, snippetType = "autosnippet" },
		fmt("\\frac{<>}{<>}", {
			i(1),
			i(2),
		}),
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = "floor", dscr = "floor", wordTrig = false, snippetType = "autosnippet" },
		fmt("\\left\\lfoor <> \\right\\rfloor", {
			d(1, get_visual),
		}),
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = "ceil", dscr = "ceil", wordTrig = false, snippetType = "autosnippet" },
		fmt("\\left\\lceil <> \\right\\rceil", {
			d(1, get_visual),
		}),
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = "sq", dscr = "square root", wordTrig = false, snippetType = "autosnippet" },
		fmt("\\sqrt{<>}", {
			d(1, get_visual),
		}),
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = "cbrt", dscr = "cubic root", wordTrig = false, snippetType = "autosnippet" },
		fmt("\\sqrt[3]{<>}", {
			d(1, get_visual),
		}),
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = "cd", dscr = "cdot", wordTrig = false, snippetType = "autosnippet" },
		t("\\cdot"),
		{ condition = tex.in_mathzone }
	),
	s({ trig = "ty", dscr = "lemniscate", snippetType = "autosnippet" }, t("\\infty"), { condition = tex.in_mathzone }),
	s(
		{ trig = "([%w%)%]%}])'", dscr = "superscript", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmt("<>^{<>}", {
			f(function(_, snip) return snip.captures[1] end),
			d(1, get_visual),
		}),
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = "([%w%)%]%}]);", dscr = "subscript", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmt("<>_{<>}", {
			f(function(_, snip) return snip.captures[1] end),
			d(1, get_visual),
		}),
		{ condition = tex.in_mathzone }
	),
	s(
		{
			trig = "([%w%)%]%}])__",
			dscr = "subscript and superscript",
			wordTrig = false,
			regTrig = true,
			snippetType = "autosnippet",
		},
		fmt("<>^{<>}_{<>}", {
			f(function(_, snip) return snip.captures[1] end),
			i(1),
			i(2),
		}),
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = "²", dscr = "square", wordTrig = false, snippetType = "autosnippet" },
		t("^2"),
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = "all ", dscr = "universal quantifier", wordTrig = false, snippetType = "autosnippet" },
		t("\forall "),
		{ condition = tex.in_mathzone }
	),
	s(
		{ trig = "ex ", dscr = "existensial quantifier", wordTrig = false, snippetType = "autosnippet" },
		t("\\exists "),
		{ condition = tex.in_mathzone }
	),
	s({ trig = "ds", dscr = "displaystyle", wordTrig = false, snippetType = "autosnippet" }, {
		t("\\displaystyle"),
	}, { condition = tex.in_mathzone }),
	s({ trig = "\\P", dscr = "Prime numbers set", wordTrig = false, snippetType = "autosnippet" }, {,
		t("\\mathbb{P}"),
	}, { condition = tex.in_mathzone }),
	s({ trig = "\\N", dscr = "Natural numbers set", wordTrig = false, snippetType = "autosnippet" }, {
		t("\\mathbb{N}"),
	}, { condition = tex.in_mathzone }),
	s({ trig = "\\Z", dscr = "integers set", wordTrig = false, snippetType = "autosnippet" }, {
		t("\\mathbb{Z}"),
	}, { condition = tex.in_mathzone }),
	s({ trig = "\\Q", dscr = "Rational numbers set", wordTrig = false, snippetType = "autosnippet" }, {
		t("\\mathbb{Q}"),
	}, { condition = tex.in_mathzone }),
	s({ trig = "\\R", dscr = "Real numbers set", wordTrig = false, snippetType = "autosnippet" }, {
		t("\\mathbb{R}"),
	}, { condition = tex.in_mathzone }),
	s({ trig = "\\C", dscr = "Complex numbers set", wordTrig = false, snippetType = "autosnippet" }, {
		t("\\mathbb{C}"),
	}, { condition = tex.in_mathzone }),
	s({ trig = "(\\?left)", dscr = "pairs", regTrig = true, wordTrig = false, snippetType = "autosnippet" }, {
		t("\\left"),
		i(1),
		d(2, get_visual),
		t("\\right"),
		f(function(arg)
			if arg[1][1] == "{" then
				return "}"
			elseif arg[1][1] == "(" then
				return ")"
			elseif arg[1][1] == "[" then
				return "]"
			elseif arg[1][1]:match("\\l") then
				return "\\r" .. arg[1]:sub("3", "-1")
			else
				return arg[1][1]
			end
		end, { 1 }),
	}),
}
