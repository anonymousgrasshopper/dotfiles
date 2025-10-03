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
local function conceal_at_positions(bufnr, cover_sr, cover_sc, cover_er, cover_ec, positions, text)
	-- cover the entire span first (hides underlying text)
	pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_conceal, cover_sr, cover_sc, {
		end_row = cover_er,
		end_col = cover_ec,
		conceal = "",
		hl_group = "Conceal",
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
				hl_group = "Conceal",
			})
		end
	end
end

-- determine whether `node` is inside the `sub` or `sup` field of some attach ancestor
local function node_is_inside_sub_or_sup(node)
	local cur = node
	while cur do
		local parent = cur:parent()
		if not parent then
			break
		end
		if parent:type() == "attach" then
			local sub = parent:field("sub")[1]
			if sub then
				-- is our node descendant of that sub-field?
				local n = node
				while n do
					if n == sub then
						return true
					end
					n = n:parent()
				end
			end
			local sup = parent:field("sup")[1]
			if sup then
				local n = node
				while n do
					if n == sup then
						return true
					end
					n = n:parent()
				end
			end
		end
		cur = parent
	end
	return false
end

-- Collect dotted symbol parts and also the first/last ident nodes for range
local function collect_dotted_parts_and_range(start_ident, bufnr)
	local parts = {}
	local first_ident = nil
	local last_ident = nil

	local function collect(n)
		if not n then
			return
		end
		local t = n:type()
		if t == "ident" or t == "identifier" then
			if not first_ident then
				first_ident = n
			end
			last_ident = n
			table.insert(parts, vim.treesitter.get_node_text(n, bufnr))
		elseif t == "field" then
			-- left-hand side is child(0), right hand field named "field"
			local lhs = n:child(0)
			collect(lhs)
			local rhs_list = n:field("field")
			if rhs_list and #rhs_list > 0 then
				collect(rhs_list[1])
			end
		else
			-- fallback: traverse children to find idents
			for i = 0, n:child_count() - 1 do
				collect(n:child(i))
			end
		end
	end

	-- find the topmost field ancestor (the whole dotted-expression node)
	local top = start_ident
	local p = top:parent()
	while p and p:type() == "field" do
		top = p
		p = top:parent()
	end

	collect(top)

	if not first_ident or not last_ident then
		-- fallback to just using the original ident
		first_ident = start_ident
		last_ident = start_ident
		parts = { vim.treesitter.get_node_text(start_ident, bufnr) }
	end

	local sr, sc = first_ident:range()
	local _, _, er, ec = last_ident:range()
	return table.concat(parts, "."), sr, sc, er, ec, top
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

local function apply_conceal()
	vim.api.nvim_buf_clear_namespace(buf, ns_conceal, 0, -1)

	local parser_ok, parser = pcall(vim.treesitter.get_parser, buf, "typst")
	if not parser_ok or not parser then
		return
	end
	local tree = parser:parse()[1]
	if not tree then
		return
	end
	local root = tree:root()

	-- two queries
	local q_symbols = vim.treesitter.query.parse(
		"typst",
		[[
    (ident) @id
    (field (ident) @id)
  ]]
	)

	local q_subsup = vim.treesitter.query.parse(
		"typst",
		[[
    (attach sub: (_) @sub)
    (attach sup: (_) @sup)
  ]]
	)

	-- 1) sub/sup first: translate tokenwise and conceal from operator to node end
	for id, node, _ in q_subsup:iter_captures(root, buf, 0, -1) do
		local cap = q_subsup.captures[id] -- "sub" or "sup"
		-- node is the child node (group/number/formula) that holds the sub/sup content
		local attach = node:parent()
		if not attach or attach:type() ~= "attach" then
			goto continue_sub
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

		if translated ~= inner then
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
			conceal_at_positions(buf, srow, scol, erow, ecol, inner_positions, translated)
		end

		::continue_sub::
	end

	-- 2) symbols (dotted names). Skip idents that are inside sub/sup.
	local seen = {}
	for id, node, _ in q_symbols:iter_captures(root, buf, 0, -1) do
		if q_symbols.captures[id] ~= "id" then
			goto continue_id
		end

		-- skip if this ident is inside a sub/sup field
		if node_is_inside_sub_or_sup(node) then
			goto continue_id
		end

		-- find the topmost field/root and collect dotted name + range
		local name, sr, sc, er, ec, top = collect_dotted_parts_and_range(node, buf)
		if not name or name == "" then
			goto continue_id
		end
		if seen[name .. ":" .. sr .. ":" .. sc] then
			goto continue_id
		end
		seen[name .. ":" .. sr .. ":" .. sc] = true

		local repl = symbols[name]
		if repl then
			-- conceal entire dotted span from sr,sc to er,ec; map characters across that span
			local positions = get_char_positions_in_range(buf, sr, sc, er, ec)
			conceal_at_positions(buf, sr, sc, er, ec, positions, repl)
		end

		::continue_id::
	end
end

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
	callback = function() apply_conceal() end,
	buffer = buf,
})
