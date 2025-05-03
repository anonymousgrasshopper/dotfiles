local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmta = require("luasnip.extras.fmt").fmta

local get_visual = function(_, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else -- If LS_SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

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
		{ trig = "autocmd ", dscr = "Neovim API autocmd", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			[[
        vim.api.nvim_create_autocmd(<>, {<>
          callback = function()
            <>
          end
        })
      ]],
			{
				c(1, {
					{ t('{ "'), i(1), t('" }') },
					{ t('"'), i(1), t('"') },
				}),
				c(2, {
					{ t({ "", '\tpattern = { "' }), i(1), t('" },') },
					{ t({ "", '\tpattern = "' }), i(1), t('",') },
					{ t("") },
				}),
				d(3, get_visual),
			}
		),
		{ condition = not_in_string_comment * line_begin }
	),
	s(
		{ trig = "snp", dscr = "LuaSnip lua snippet template", snippetType = "autosnippet" },
		fmta(
			[=[
        s({ trig = "<>", dscr = "<>"<><><> },
          <>
        ),
      ]=],
			{
				i(1),
				i(2),
				c(3, { t(", regTrig = true"), t("") }),
				c(4, { t(", wordTrig = false"), t("") }),
				c(5, { t(', snippetType = "autosnippet"'), t("") }),
				c(6, {
					sn(
						nil,
						fmta(
							[=[
              fmta(
                  [[
                    <>
                  ]],
                  {
                    <>
                  }
                )
            ]=],
							{
								i(1),
								i(2),
							}
						)
					),
					sn(nil, { t({ "{", '\t\tt("' }), i(1), t({ '")', "\t}" }) }),
				}),
			}
		),
		{ condition = not_in_string_comment * line_begin }
	),
	s({
		trig = "<[cC][mM][dD]>",
		dscr = "Neovim keymap command",
		wordTrig = false,
		regTrig = true,
		snippetType = "autosnippet",
	}, {
		t("<Cmd>"),
		d(1, get_visual),
		t("<CR>"),
	}),
	s({ trig = "vks", dscr = "Create a keymap", snippetType = "autosnippet" }, {
		t('vim.keymap.set("'),
		i(1, "n"),
		t('", "'),
		i(2, "LHS"),
		t('", '),
		i(3, '"RHS"'),
		t(', { desc = "'),
		i(4),
		t('" })'),
	}, { condition = not_in_string_comment * line_begin }),
}
