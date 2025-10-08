-- conceal delimiters
local buf = vim.api.nvim_get_current_buf()
local ns = vim.api.nvim_create_namespace("typst_delims")

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
		hl_group = "TypstDelimsConceal",
	})
end

local function conceal_delims(first, last)
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

		for id, node in query:iter_captures(root, buf, first, last) do
			if query.captures[id] == capture then
				local srow, scol, erow, ecol = node:range()
				conceal_symbol_at(srow, scol, opts.symbol)
				conceal_symbol_at(erow, ecol - 1, opts.symbol)
			end
		end
	end
end

vim.api.nvim_buf_attach(buf, false, {
	on_lines = function(_, _, _, first, last) conceal_delims(first, last) end,
})

conceal_delims(0, -1)

-- conceal symbols
local ns_conceal = vim.api.nvim_create_namespace("typst_conceal")

local sub_map = require("static.lang.typst.subscripts")
local sup_map = require("static.lang.typst.superscripts")
local symbols = require("static.lang.typst.symbols")

-- returns a list of {row=, col=, ch=} for each character in the buffer span
local function get_char_positions_in_range(bufnr, sr, sc, er, ec)
	local lines = vim.api.nvim_buf_get_text(bufnr, sr, sc, er, ec, {})
	local pos = {}
	local row = sr
	for i, line in ipairs(lines) do
		local chars = vim.fn.split(line, "\\zs")
		local col = (i == 1) and sc or 0
		for _, ch in ipairs(chars) do
			table.insert(pos, { row = row, col = col, ch = ch })
			col = col + #ch -- byte-length increment
		end
		if i < #lines then
			row = row + 1
		end
	end
	return pos
end

-- place covering extmark + per-character extmarks at given positions with given text chars
local function conceal_at_positions(bufnr, cover_sr, cover_sc, cover_er, cover_ec, positions, text, hl)
	-- cover the entire span first (hides underlying text)
	pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_conceal, cover_sr, cover_sc, {
		end_row = cover_er,
		end_col = cover_ec,
		conceal = "",
		hl_group = hl,
		priority = 100,
	})

	-- split translated text into characters
	local tch = vim.fn.split(text, "\\zs")
	local n = math.min(#tch, #positions)
	for i = 1, n do
		local pos = positions[i]
		if pos then
			pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_conceal, pos.row, pos.col, {
				end_row = pos.row,
				end_col = pos.col + #pos.ch,
				conceal = tch[i],
				hl_group = hl,
				priority = 101,
			})
		end
	end
end

-- token-aware translator (uses symbols table and per-char map)
local function translate_tokenwise(text, map)
	if not text or text == "" then
		return text
	end
	local out_parts = {}
	local pos = 1
	for token in text:gmatch("%S+") do
		local s, e = text:find(token, pos, true)
		if not s then
			table.insert(out_parts, text:sub(pos))
			pos = #text + 1
			break
		end
		if s > pos then
			table.insert(out_parts, text:sub(pos, s - 1))
		end

		if symbols[token] then
			table.insert(out_parts, symbols[token])
		elseif token:match("^%a+$") and #token > 1 then
			table.insert(out_parts, token)
		else
			local chars = vim.fn.split(token, "\\zs")
			local mapped = {}
			local all_mapped = true
			for _, ch in ipairs(chars) do
				local m = map[ch]
				if not m then
					all_mapped = false
					break
				end
				table.insert(mapped, m)
			end
			if all_mapped then
				table.insert(out_parts, table.concat(mapped, ""))
			else
				table.insert(out_parts, token)
			end
		end
		pos = e + 1
	end
	if pos <= #text then
		table.insert(out_parts, text:sub(pos))
	end
	return table.concat(out_parts, "")
end

local function math_conceal(first, last)
	local ok, parser = pcall(vim.treesitter.get_parser, buf, "typst")
	if not ok or not parser then
		return
	end
	local tree = parser:parse()[1]
	if not tree then
		return
	end
	local root = tree:root()

	-- queries
	local q_symbols = vim.treesitter.query.parse(
		"typst",
		[[
			(
				(field)
				@symbol
				(#lua-match? @symbol "^[a-z.]+$")
				(#not-has-ancestor? @symbol field )
			)
			(
				(ident)
				@symbol
				(#has-ancestor? @symbol math )
				(#lua-match? @symbol "^[A-Za-z.]+$")
				(#not-has-ancestor? @symbol field )
				(#not-has-ancestor? @symbol sub )
				(#not-has-ancestor? @symbol attach )
			)
			(
				(ident)
				@symbol
				(#has-ancestor? @symbol math )
				(#lua-match? @symbol "^[A-Za-z.]+$")
				(#not-has-ancestor? @symbol field )
				(#not-has-ancestor? @symbol sub )
				(#has-parent? @symbol attach )
			)
		]]
	)
	local q_subsup = vim.treesitter.query.parse(
		"typst",
		[[
			(attach sub: (_) @sub)
			(attach sup: (_) @sup)
		]]
	)

	-- subscripts and superscripts
	for id, node, _ in q_subsup:iter_captures(root, buf, first, last) do
		local cap = q_subsup.captures[id] -- "sub" or "sup"

		-- node is the child node (group/number/formula) that holds the sub/sup content
		local attach = node:parent()
		if not attach or attach:type() ~= "attach" then
			goto continue_script
		end

		-- find operator node (last child before the sub node)
		local op_node = nil
		for i = 0, attach:child_count() - 1 do
			local ch = attach:child(i)
			if ch == node then
				-- found the sub node position; operator should be a previous sibling
				-- search backwards for a child whose text is "_" or "^"
				for j = i - 1, 0, -1 do
					local cand = attach:child(j)
					local t = vim.treesitter.get_node_text(cand, buf)
					if t == "_" or t == "^" then
						vim.notify(vim.inspect(t))
						op_node = cand
						break
					end
				end
				break
			end
		end

		-- prepare node text and translation (strip one pair of parens around the captured node)
		local raw = vim.treesitter.get_node_text(node, buf) or ""
		local inner = raw:gsub("^%s*%((.*)%)%s*$", "%1")
		local map = (cap == "sub") and sub_map or sup_map
		local translated = translate_tokenwise(inner, map)

		-- compute cover start (operator start if present, else the node start)
		local srow, scol = nil, nil
		if op_node then
			local a, b = op_node:range() -- returns (sr, sc, er, ec), but we only unpack start
			srow, scol = a, b
		else
			local a, b = node:range()
			srow, scol = a, b
		end
		local _, _, erow, ecol = node:range()

		-- gather inner positions (only the inner characters, not the wrapping parentheses)
		local node_sr, node_sc, node_er, node_ec = node:range()
		local positions = get_char_positions_in_range(buf, node_sr, node_sc, node_er, node_ec)

		-- if first char '(' and last ')' in positions, strip them
		local inner_positions = positions
		if #positions >= 2 and positions[1].ch == "(" and positions[#positions].ch == ")" then
			inner_positions = {}
			for i = 2, #positions - 1 do
				table.insert(inner_positions, positions[i])
			end
		end

		-- conceal: cover from operator start to node end, then place translated chars over inner positions
		conceal_at_positions(buf, srow, scol, erow, ecol, inner_positions, translated, "TypstScriptConceal")

		::continue_script::
	end

	-- symbols
	for id, node, metadata, match in q_symbols:iter_captures(root, buf, first, last) do
		local sr, sc, er, ec = node:range() -- range of the capture
		local text = vim.treesitter.get_node_text(node, 0, { metadata = metadata })
		local repl = symbols[text]
		if repl then
			local positions = get_char_positions_in_range(buf, sr, sc, er, ec)
			conceal_at_positions(buf, sr, sc, er, ec, positions, repl, "TypstSymbolsConceal")
		end
	end
end

vim.api.nvim_buf_attach(buf, false, {
	on_lines = function(_, _, _, first, last) math_conceal(first, last) end,
})

math_conceal(0, -1)
