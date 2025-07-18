local ts = vim.treesitter
local ts_query = ts.query

return {
	format = function(bufnr)
		bufnr = bufnr or vim.api.nvim_get_current_buf()

		local lang = ts.language.get_lang(vim.bo[bufnr].filetype)
		if not lang then
			return
		end

		local parser = ts.get_parser(bufnr, lang)
		if not parser then
			return
		end

		local tree = parser:parse()[1]
		if not tree then
			return
		end
		local root = tree:root()

		local query = ts_query.parse(
			lang,
			[[
				(inline_formula) @inline
				(displayed_equation) @display
			]]
		)

		local replacements = {}

		for id, node in query:iter_captures(root, bufnr, 0, -1) do
			local name = query.captures[id]
			local start_row, start_col, end_row, end_col = node:range()

			local lines = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})
			local full_text = table.concat(lines, "\n")

			if name == "inline" then
				if full_text:match("^%$.*%$$") and not full_text:match("^\\%b()$") then
					local content = full_text:sub(2, -2)
					table.insert(replacements, {
						start_row = start_row,
						start_col = start_col,
						end_row = end_row,
						end_col = end_col,
						new_lines = { "\\(" .. content .. "\\)" },
					})
				end
			elseif name == "display" then
				if full_text:match("^%$%$.*%$%$") and not full_text:match("^\\%b[]$") then
					local content = full_text:sub(3, -3)
					local content_lines = vim.split(content, "\n", { plain = true, trimempty = false })
					content_lines[1] = "\\[" .. content_lines[1]
					content_lines[#content_lines] = content_lines[#content_lines] .. "\\]"
					table.insert(replacements, {
						start_row = start_row,
						start_col = start_col,
						end_row = end_row,
						end_col = end_col,
						new_lines = content_lines,
					})
				end
			end
		end

		for i = #replacements, 1, -1 do
			local r = replacements[i]
			vim.api.nvim_buf_set_text(bufnr, r.start_row, r.start_col, r.end_row, r.end_col, r.new_lines)
		end
	end,
}
