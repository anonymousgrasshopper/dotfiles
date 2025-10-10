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
	if not line or col < 0 or col >= #line then return nil end
	return line:sub(col + 1, col + 1)
end

local function conceal_symbol_at(row, col, symbol)
	if char_at(row, col) ~= symbol then return end
	vim.api.nvim_buf_set_extmark(buf, ns, row, col, {
		end_row = row,
		end_col = col + 1,
		conceal = "",
		hl_group = "TypstDelimsConceal",
	})
end

local function conceal_delims(first, last)
	vim.api.nvim_buf_clear_namespace(buf, ns, first, last)

	local parser = vim.treesitter.get_parser(buf, "typst")
	if not parser then return end
	local tree = parser:parse()[1]
	if not tree then return end
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
	on_lines = function(_, _, _, first, last)
		conceal_delims(first, last)
	end,
})

conceal_delims(0, -1)

-- conceal symbols
local ns_conceal = vim.api.nvim_create_namespace("typst_conceal")

local functions = require("static.lang.typst.calls")
local subscripts = require("static.lang.typst.subscripts")
local superscripts = require("static.lang.typst.superscripts")
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

-- apply a per-character extmark on the given range
local function conceal_at_positions(bufnr, sr, sc, er, ec, text, hl)
	local positions = get_char_positions_in_range(buf, sr, sc, er, ec)

	-- cover the entire span first (hides underlying text)
	pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_conceal, sr, sc, {
		end_row = er,
		end_col = ec,
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

-- returns the concealed text
local function translate_tokenwise(text, map)
	if not text or text == "" then return text end
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
	if not ok or not parser then return end
	local tree = parser:parse()[1]
	if not tree then return end
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

	local q_calls = vim.treesitter.query.parse(
		"typst",
		[[
			(
				(call)
				@function
				(#has-ancestor? @function math)
			)
		]]
	)

	-- subscripts and superscripts
	for id, node, _ in q_subsup:iter_captures(root, buf, first, last) do
		local cap = q_subsup.captures[id] -- "sub" or "sup"

		-- prepare node text and translation (strip one pair of parens around the captured node)
		local raw = vim.treesitter.get_node_text(node, buf) or ""
		local inner = raw:gsub("^%s*%((.*)%)%s*$", "%1")
		local map = (cap == "sub") and subscripts or superscripts
		local translated = translate_tokenwise(inner, map)

		local sr, sc, er, ec = node:range()
		local char = char_at(sr, sc - 1)
		if char == "_" or char == "^" then
			sc = sc - 1
		end

		conceal_at_positions(buf, sr, sc, er, ec, translated, "TypstScriptConceal")
	end

	-- symbols
	for _, node, metadata, _ in q_symbols:iter_captures(root, buf, first, last) do
		local sr, sc, er, ec = node:range() -- range of the capture
		local text = vim.treesitter.get_node_text(node, 0, { metadata = metadata })
		local repl = symbols[text]
		if repl then
			conceal_at_positions(buf, sr, sc, er, ec, repl, "TypstSymbolsConceal")
		end
	end

	-- function calls
	for _, node, _, _ in q_calls:iter_captures(root, buf, first, last) do
		local _, _, er, ec = node:range()
		local child = node:field("item")[1]
		if child then
			local name = vim.treesitter.get_node_text(child, 0, {})
			local delims = functions[name]
			if delims then
				local text = vim.treesitter.get_node_text(node, 0, {})
				text = text:match("^" .. name .. "%((.*)%)$") or text
				local child_sr, child_sc, child_er, child_ec = child:range()
				if char_at(child_er, child_ec) == "(" then
					child_ec = child_ec + 1
				end
				conceal_at_positions(buf, child_sr, child_sc, child_er, child_ec, delims[1], "TypstSurroundConceal")
				conceal_at_positions(buf, er, ec - 1, er, ec, delims[2], "TypstSurroundConceal")
			end
		end
	end
end

vim.api.nvim_buf_attach(buf, false, {
	on_lines = function(_, _, _, first, last) math_conceal(first, last) end,
})

math_conceal(0, -1)
