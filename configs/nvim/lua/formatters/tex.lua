local ts = vim.treesitter
local ts_query = ts.query

return {
	format = function(bufnr)
		bufnr = bufnr or vim.api.nvim_get_current_buf()

		local lang = ts.language.get_lang(vim.bo[bufnr].filetype)
		if lang ~= "latex" then
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
			local sr, sc, er, ec = node:range()
			local lines = vim.api.nvim_buf_get_text(bufnr, sr, sc, er, ec, {})
			if #lines == 0 then
				goto continue
			end

			if name == "inline" then
				if #lines == 1 then
					local l = lines[1]
					-- already \( ... \)
					if l:sub(1, 2) == "\\(" and l:sub(-2) == "\\)" then
						goto continue
					end
					-- convert $...$
					if l:sub(1, 1) == "$" and l:sub(-1) == "$" then
						lines[1] = "\\(" .. l:sub(2, -2) .. "\\)"
						table.insert(replacements, { sr = sr, sc = sc, er = er, ec = ec, new = lines })
					end
				else
					local first, last = lines[1], lines[#lines]
					-- already \( ... \)
					if first:sub(1, 2) == "\\(" and last:sub(-2) == "\\)" then
						goto continue
					end
					-- convert $...$ across lines
					if first:sub(1, 1) == "$" and last:sub(-1) == "$" then
						lines[1] = "\\(" .. first:sub(2)
						lines[#lines] = last:sub(1, #last - 1) .. "\\)"
						table.insert(replacements, { sr = sr, sc = sc, er = er, ec = ec, new = lines })
					end
				end
			elseif name == "display" then
				if #lines == 1 then
					local l = lines[1]
					-- already \[ ... \]
					if l:sub(1, 2) == "\\[" and l:sub(-2) == "\\]" then
						goto continue
					end
					-- convert $$...$$
					if l:sub(1, 2) == "$$" and l:sub(-2) == "$$" then
						lines[1] = "\\[" .. l:sub(3, -3) .. "\\]"
						table.insert(replacements, { sr = sr, sc = sc, er = er, ec = ec, new = lines })
					end
				else
					local first, last = lines[1], lines[#lines]
					-- already \[ ... \]
					if first:sub(1, 2) == "\\[" and last:sub(-2) == "\\]" then
						goto continue
					end
					-- convert $$...$$ across lines
					if first:sub(1, 2) == "$$" and last:sub(-2) == "$$" then
						lines[1] = "\\[" .. first:sub(3)
						lines[#lines] = last:sub(1, #last - 2) .. "\\]"
						table.insert(replacements, { sr = sr, sc = sc, er = er, ec = ec, new = lines })
					end
				end
			end

			::continue::
		end

		-- Apply from bottom to top so ranges remain valid
		for i = #replacements, 1, -1 do
			local r = replacements[i]
			vim.api.nvim_buf_set_text(bufnr, r.sr, r.sc, r.er, r.ec, r.new)
		end
	end,
}
