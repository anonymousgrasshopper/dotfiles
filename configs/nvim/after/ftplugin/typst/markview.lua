local bufnr = vim.api.nvim_get_current_buf()

-- Keep only valid keys for nvim_buf_set_extmark()
local function sanitize_opts(opts)
	local clean = {}
	for _, key in ipairs({
		"end_row",
		"end_col",
		"hl_group",
		"virt_text",
		"virt_text_pos",
		"virt_text_win_col",
		"sign_text",
		"sign_hl_group",
		"line_hl_group",
		"cursorline_hl_group",
		"conceal",
		"priority",
		"right_gravity",
		"end_right_gravity",
		"strict",
	}) do
		if opts[key] ~= nil then
			clean[key] = opts[key]
		end
	end
	return clean
end

local hidden_cache = {}
local prev_line = nil

-- Toggle hiding of extmarks on the current line for a given namespace name
local function toggle_extmarks_on_line_for_ns(ns_name)
	local ns_id = vim.api.nvim_get_namespaces()[ns_name]
	if not ns_id then
		return
	end

	local line = vim.api.nvim_win_get_cursor(0)[1] - 1

	hidden_cache[bufnr] = hidden_cache[bufnr] or {}
	hidden_cache[bufnr][ns_id] = hidden_cache[bufnr][ns_id] or {}

	if not prev_line and line == prev_line then
		return
	else
		if prev_line then
			-- Restore hidden extmarks
			for _, item in ipairs(hidden_cache[bufnr][ns_id][prev_line] or {}) do
				pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, item.row, item.col, item.opts)
			end
			hidden_cache[bufnr][ns_id][prev_line] = nil
		end

		-- Hide extmarks and cache their details
		local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, ns_id, { line, 0 }, { line, -1 }, { details = true })

		local cache = {}
		for _, mark in ipairs(extmarks) do
			local row, col, opts = mark[2], mark[3], mark[4]
			table.insert(cache, { row = row, col = col, opts = sanitize_opts(opts) })

			vim.api.nvim_buf_del_extmark(bufnr, ns_id, mark[1])
		end

		if #cache > 0 then
			hidden_cache[bufnr][ns_id][line] = cache
		end
	end
	prev_line = line
end

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	callback = function() toggle_extmarks_on_line_for_ns("markview/typst") end,
	buffer = bufnr,
})
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
	callback = function() hidden_cache = {} end,
	buffer = bufnr,
})
