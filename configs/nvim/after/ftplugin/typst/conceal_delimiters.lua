local buf = vim.api.nvim_get_current_buf()
local ns = vim.api.nvim_create_namespace("typst_math_delims")

local nodes = {
	math = { symbol = "$", node = "math" },
	emph = { symbol = "_", node = "emph" },
	strong = { symbol = "*", node = "strong" },
}

local function char_at(row, col)
	local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
	if not line or col < 0 or col >= #line then
		return nil
	end
	return line:sub(col + 1, col + 1)
end

local function conceal_symbol_at(row, col, symbol)
	if char_at(row, col) ~= symbol then
		return
	end
	vim.api.nvim_buf_set_extmark(buf, ns, row, col, {
		end_row = row,
		end_col = col + 1,
		conceal = "",
		hl_group = "Conceal",
	})
end

local function update()
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

	local parser = vim.treesitter.get_parser(buf, "typst")
	if not parser then
		return
	end
	local tree = parser:parse()[1]
	if not tree then
		return
	end
	local root = tree:root()

	for capture, opts in pairs(nodes) do
		local ok, query = pcall(vim.treesitter.query.parse, "typst", string.format("(%s) @%s", opts.node, capture))
		if not ok then
			vim.notify("Typst conceal: failed to compile query", vim.log.levels.ERROR)
			return
		end

		for id, node in query:iter_captures(root, buf, 0, -1) do
			if query.captures[id] == capture then
				local srow, scol, erow, ecol = node:range()
				conceal_symbol_at(srow, scol, opts.symbol)
				conceal_symbol_at(erow, ecol - 1, opts.symbol)
			end
		end
	end
end

local function reveal_cursor_line()
	update()
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	vim.api.nvim_buf_clear_namespace(buf, ns, row, row + 1)
end

vim.api.nvim_create_autocmd(
	{ "BufEnter", "BufWritePost", "TextChanged", "TextChangedI" },
	{ buffer = buf, callback = update }
)

vim.api.nvim_create_autocmd("CursorMoved", { buffer = buf, callback = reveal_cursor_line })

update()
