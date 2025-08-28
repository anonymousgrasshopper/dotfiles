local ls = require("snippets.luasnip")
local s, t, i, f = ls.s, ls.t, ls.i, ls.f
local helpers = require("snippets.helpers")
local first_line, line_begin = helpers.first_line, helpers.line_begin

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
	s(
		{
			trig = "#!",
			dscr = "shebang",
			snippetType = "autosnippet",
			hidden = true,
			condition = first_line * line_begin,
		},
		{
			t("#!/bin/"),
			i(1, "bash"),
			update_filetype(1),
		}
	),
}
