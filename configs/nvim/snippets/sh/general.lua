local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
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

local not_in_string_comment = function() return check_not_in_node({ "string_content", "comment" }) end

local rec_switch
rec_switch = function()
	return sn(
		nil,
		c(1, {
			t(""),
			sn(nil, {
				t({ "", "\t" }),
				i(1),
				t({ ")", "" }),
				t("\t\t"),
				i(2),
				t({ "", "\t\t;;" }),
				d(3, rec_switch, {}),
			}),
		})
	)
end

return {
	s(
		{ trig = "if ", dscr = "conditional statement", snippetType = "autosnippet" },
		fmt("if <>; then\n\t<>\nfi<>", {
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
        for <> in <>; do
          <>
        done<>
      ]],
			{
				i(1),
				i(2),
				d(3, get_visual),
				i(0),
			}
		),
		{ condition = not_in_string_comment }
	),
	s(
		{ trig = "while ", dscr = "while loop", snippetType = "autosnippet" },
		fmt(
			[[
        while <>; do
          <>
        done <>
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
		{ trig = "until ", dscr = "until loop", snippetType = "autosnippet" },
		fmt(
			[[
        until <>; do
          <>
        done <>
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
		{ trig = "select ", dscr = "select loop", snippetType = "autosnippet" },
		fmt(
			[[
        select <> in <>; do
          <>
        done <>
      ]],
			{
				i(1),
				i(2),
				d(3, get_visual),
				i(0),
			}
		),
		{ condition = not_in_string_comment }
	),
	s(
		{ trig = "if [", dscr = "test condition", snippetType = "autosnippet" },
		fmt("if [[ <> ]", {
			i(1),
		}),
		{ condition = not_in_string_comment }
	),
	s(
		{ trig = "while [", dscr = "test condition", snippetType = "autosnippet" },
		fmt("while [[ <> ]", {
			i(1),
		}),
		{ condition = not_in_string_comment }
	),
	s(
		{ trig = "case", name = "cases", dscr = "cases" },
		fmt(
			[[
        case <> in
            <>
            *) <> ;;
        esac
      ]],
			{
				i(1, "expr"),
				i(2),
				i(3, "exit 1"),
			}
		),
		{ condition = not_in_string_comment }
	),
	s(
		{ trig = "func", name = "function", dscr = "define a function" },
		fmt(
			[[
        <>() {
          <>
        }
      ]],
			{
				i(1),
				i(0),
			}
		),
		{ condition = not_in_string_comment }
	),
	s(
		{ trig = "case ", dscr = "switch statement", wordTrig = false, snippetType = "autosnippet" },
		fmt(
			[[
        case <> in<>
        esac
      ]],
			{
				i(1),
				d(2, rec_switch, {}),
			}
		),
		{ condition = not_in_string_comment }
	),
}
