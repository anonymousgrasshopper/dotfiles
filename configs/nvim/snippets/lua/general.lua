local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local d = ls.dynamic_node
local f = ls.function_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmta

local get_visual = function(_, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else -- If LS_SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

local check_not_in_node = function(ignored_nodes)
	if not require("nvim-treesitter.parsers").has_parser() then
		return true
	end
	local pos = vim.api.nvim_win_get_cursor(0)
	local row, col = pos[1] - 1, pos[2] - 1
	local node_type = vim.treesitter.get_node({ pos = { row, col } }):type()
	return not vim.tbl_contains(ignored_nodes, node_type)
end

local not_in_string_comment = function()
	return check_not_in_node({ "string_content", "comment_content", "comment", "chunk" })
end

return {
	s(
		{ trig = "if ", dscr = "conditional statement", snippetType = "autosnippet" },
		fmt("if <> then\n\t<>\nend<>", {
			i(1),
			d(2, get_visual),
			i(0),
		}),
		{ condition = not_in_string_comment }
	),
	s(
		{ trig = "for ", dscr = "for loop", snippetType = "autosnippet" },
		fmt(
			[[
        for <> do
          <>
        end<>
      ]],
			{
				i(1),
				d(2, get_visual),
				i(0),
			}
		),
		{ condition = not_in_string_comment }
	),
	s(
		{ trig = "repeat ", dscr = "repeat until loop", snippetType = "autosnippet" },
		fmt(
			[[
        repeat
          <>
        until <>
      ]],
			{
				d(1, get_visual),
				i(2),
			}
		),
		{ condition = not_in_string_comment }
	),
	s(
		{ trig = "([^%w_])function", dscr = "function", regTrig = true, snippetType = "autosnippet" },
		fmt(
			[[
        <>function(<>)
          <>
        end<>
      ]],
			{
				f(function(_, snip) return snip.captures[1] end),
				i(1),
				d(2, get_visual),
				i(0),
			}
		),
		{ condition = not_in_string_comment }
	),
	s(
		{ trig = "([^%w_])func ", dscr = "function", regTrig = true, snippetType = "autosnippet" },
		fmt("<>function(<>) <> end<>", {
			f(function(_, snip) return snip.captures[1] end),
			i(1),
			d(2, get_visual),
			i(0),
		}),
		{ condition = not_in_string_comment }
	),
}
