local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local make_condition = require("luasnip.extras.conditions").make_condition

local line_begin = require("luasnip.extras.expand_conditions").line_begin

local first_line = make_condition(function() return vim.api.nvim_win_get_cursor(0)[1] == 1 end)

local update_filetype = function(index)
	return f(function(arg)
		local shells = { "bash", "zsh", "sh", "python" }
		for _, shell in ipairs(shells) do
			if arg[1][1]:match(shell) then
				vim.bo.filetype = shell
				return
			end
		end
	end, { index, index })
end

return {
	s({ trig = "#!", dscr = "shebang", snippetType = "autosnippet" }, {
		t("#!/bin/"),
		i(1, "bash"),
		update_filetype(1),
	}, { condition = first_line * line_begin }),
}
