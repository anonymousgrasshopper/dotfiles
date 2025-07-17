local ls = require("snippet/luasnip")
local i, sn, make_cond = ls.i, ls.sn, ls.make_cond

local helpers = {}

helpers.line_begin = require("luasnip.extras.expand_conditions").line_begin
helpers.first_line = make_cond(function() return vim.api.nvim_win_get_cursor(0)[1] == 1 end)
helpers.word_trig_condition = require("luasnip.extras.expand_conditions").word_trig_condition
helpers.trigger_not_preceded_by = require("luasnip.extras.expand_conditions").trigger_not_preceded_by

function helpers.get_visual(_, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else -- If LS_SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

function helpers.check_not_in_node(ignored_nodes)
	local buf = vim.api.nvim_get_current_buf()
	local highlighter = require("vim.treesitter.highlighter")
	if not highlighter.active[buf] then
		vim.schedule(function() vim.notify(vim.inspect("oiznfeoizoei")) end)
		return true
	end
	local pos = vim.api.nvim_win_get_cursor(0)
	local row, col = pos[1] - 1, pos[2] - 1
	local node_type = vim.treesitter.get_node({ pos = { row, col } }):type()
	vim.schedule(function() vim.notify(vim.inspect(node_type)) end)
	return not vim.tbl_contains(ignored_nodes, node_type)
end

helpers.not_in_string_comment = make_cond(function()
	return helpers.check_not_in_node(
		{ "string", "string_content", "comment", "comment_content" }
	)
end)

function helpers.line_not_match(pattern)
	return make_cond(function()
		local line = vim.api.nvim_get_current_line()
		return not line:match(pattern)
	end)
end

function helpers.check_not_expanded(pattern)
	return make_cond(function()
		local line = vim.api.nvim_get_current_line()
		local col = vim.api.nvim_win_get_cursor(0)[2]
		return not line:sub(col, #line):match(pattern)
	end)
end

return helpers
