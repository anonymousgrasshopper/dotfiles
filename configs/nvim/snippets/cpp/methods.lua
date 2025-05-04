local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmta

local check_not_in_node = function(ignored_nodes)
	if not require("nvim-treesitter.parsers").has_parser() then
		return true
	end
	local pos = vim.api.nvim_win_get_cursor(0)
	local row, col = pos[1] - 1, pos[2] - 1
	local node_type = vim.treesitter.get_node({ pos = { row, col } }):type()
	return not vim.tbl_contains(ignored_nodes, node_type)
end

local not_in_string_comment = function() return check_not_in_node({ "string_content", "comment" }) end

return {
	s(
		{ trig = "([^%w_])all%(", regTrig = true, wordTrig = false, dscr = "iterator range", snippetType = "autosnippet" },
		fmt("<><>.begin(), <>.end(", {
			f(function(_, snip) return snip.captures[1] end),
			i(1),
			rep(1),
		}),
		{ condition = not_in_string_comment }
	),
	s(
		{
			trig = "([^%w_])rall%(",
			regTrig = true,
			wordTrig = false,
			dscr = "reverse iterator range",
			snippetType = "autosnippet",
		},
		fmt("<><>.rbegin(), <>.rend(", {
			f(function(_, snip) return snip.captures[1] end),
			i(1),
			rep(1),
		}),
		{ condition = not_in_string_comment }
	),
}
