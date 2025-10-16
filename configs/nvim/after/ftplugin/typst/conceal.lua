local buf = vim.api.nvim_get_current_buf()

local function char_at(row, col)
	local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
	if not line or col < 0 or col >= #line then return nil end
	return line:sub(col + 1, col + 1)
end

local function conceal_char_at(row, col, ns, chars)
	if type(chars) == "table" then
		if not vim.tbl_contains(chars, char_at(row, col)) then return end
	else
		if char_at(row, col) ~= chars then return end
	end

	vim.api.nvim_buf_set_extmark(buf, ns, row, col, {
		end_row = row,
		end_col = col + 1,
		conceal = "",
		priority = 101,
		hl_group = "TypstConcealDelims",
	})
end

-- conceal delimiters
local ns_delims = vim.api.nvim_create_namespace("typst_delims")

local nodes = {
	math = { symbol = "$", node = "math" },
	emph = { symbol = "_", node = "emph" },
	strong = { symbol = "*", node = "strong" },
}

local function conceal_delims(first, last)
	vim.api.nvim_buf_clear_namespace(buf, ns_delims, first, last)

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
				conceal_char_at(srow, scol, ns_delims, opts.symbol)
				conceal_char_at(erow, ecol - 1, ns_delims, opts.symbol)
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
local ns_math = vim.api.nvim_create_namespace("typst_math_conceal")

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
	pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_math, sr, sc, {
		end_row = er,
		end_col = ec,
		conceal = "",
		hl_group = hl,
		priority = 101,
	})

	-- split translated text into characters
	local tch = vim.fn.split(text, "\\zs")
	local n = math.min(#tch, #positions)
	for i = 1, n do
		local pos = positions[i]
		if pos then
			pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_math, pos.row, pos.col, {
				end_row = pos.row,
				end_col = pos.col + #pos.ch,
				conceal = tch[i],
				hl_group = hl,
				priority = 105,
			})
		end
	end
end

local queries = {
	symbols = vim.treesitter.query.parse(
		"typst",
		[[
			(
				(field) @symbol
				(#lua-match? @symbol "^[a-z.]+$")
				(#not-has-ancestor? @symbol field )
				(#not-has-ancestor? @symbol attach)
			)
			(
				(ident) @symbol
				(#has-ancestor? @symbol math )
				(#lua-match? @symbol "^[A-Za-z.]+$")
				(#not-has-ancestor? @symbol field)
				(#not-has-ancestor? @symbol attach)
			)
			(
				attach . (ident) @symbol
				(#lua-match? @symbol "^[A-Za-z.]+$")
				(#not-has-ancestor? @symbol field)
			)
		]]
	),
	scripts = {
		subscripts = vim.treesitter.query.parse(
			"typst",
			[[
				(attach sub: (_) @sub)
			]]
		),
		superscripts = vim.treesitter.query.parse(
			"typst",
			[[
				(attach sup: (_) @sup)
			]]
		),
		subsup = vim.treesitter.query.parse(
			"typst",
			[[
				(attach sub: (_) @sub)
				(attach sup: (_) @sup)
			]]
		),
	},
	functions = vim.treesitter.query.parse(
		"typst",
		[[
			(
				(call)
				@function
				(#has-ancestor? @function math)
			)
		]]
	),
}

local function math_conceal(first, last)
	local ok, parser = pcall(vim.treesitter.get_parser, buf, "typst")
	if not ok or not parser then return end
	local tree = parser:parse()[1]
	if not tree then return end
	local root = tree:root()

	vim.api.nvim_buf_clear_namespace(buf, ns_math, first, last)

	-- symbols
	for _, node, metadata in queries.symbols:iter_captures(root, buf, first, last) do
		local sr, sc, er, ec = node:range()
		local text = vim.treesitter.get_node_text(node, 0, { metadata = metadata })
		local repl = symbols[text]
		if repl then
			conceal_at_positions(buf, sr, sc, er, ec, repl.cchar, repl.hl)
		end
	end

	-- subscripts and superscripts
	for _, node in queries.scripts.subsup:iter_captures(root, buf, first, last) do
		local sr, sc, er, ec = node:range()
		conceal_char_at(sr, sc - 1, ns_math, { "^", "_" })
		conceal_char_at(sr, sc, ns_math, "(")
		conceal_char_at(er, ec - 1, ns_math, ")")

		pcall(vim.api.nvim_buf_set_extmark, buf, ns_math, sr, sc, {
			end_row = er,
			end_col = ec,
			hl_group = "TypstConcealScript",
			priority = 103,
		})
	end


	local function conceal_node_recursively(node, map)
		local concealed = ""

		local function rec(node)
			if node:type() == "field" or node:type() == "ident" then
				local text = vim.treesitter.get_node_text(node, 0, {})
				local repl = map[text]
				if repl then
					concealed = concealed .. repl
				else
					local repl = symbols[text]
					if repl then
						concealed = concealed .. repl.cchar
					end
				end
			elseif node:type() == "letter" or node:type() == "symbol" then
				local text = vim.treesitter.get_node_text(node, 0, {})
				local repl = map[text]
				if repl then
					concealed = concealed .. repl
				end
			elseif node:type() == "number" then
				local text = vim.treesitter.get_node_text(node, 0, {})
				for i = 1, #text + 1 do
					concealed = concealed .. (map[text:sub(i, i)] or "")
				end
			else
				for child in node:iter_children() do
					rec(child)
				end
			end
		end

		rec(node)
		local sr, sc, er, ec = node:range()
		conceal_at_positions(buf, sr, sc, er, ec, concealed, "TypstConcealScript")
	end

	for _, node in queries.scripts.subscripts:iter_captures(root, buf, first, last) do
		conceal_node_recursively(node, subscripts)
	end

	for _, node in queries.scripts.superscripts:iter_captures(root, buf, first, last) do
		conceal_node_recursively(node, superscripts)
	end

	-- function calls
	for _, node in queries.functions:iter_captures(root, buf, first, last) do
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
				conceal_at_positions(buf, child_sr, child_sc, child_er, child_ec, delims[1], "TypstConcealSurround")
				conceal_at_positions(buf, er, ec - 1, er, ec, delims[2], "TypstConcealSurround")
			end
		end
	end
end

vim.api.nvim_buf_attach(buf, false, {
	on_lines = function(_, _, _, first, last) math_conceal(first, last) end,
})

math_conceal(0, -1)
