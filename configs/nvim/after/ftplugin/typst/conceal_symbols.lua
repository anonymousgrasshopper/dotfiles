local buf = vim.api.nvim_get_current_buf()

local symbols = require("static.lang.typst.symbols_conceal")
local ns_conceal = vim.api.nvim_create_namespace("typst_conceal")

local query = vim.treesitter.query.parse("typst", [[ (ident) @id ]])

-- Helper: climb ancestors and see if node is inside a math/formula node.
local function is_symbol_root(node)
	-- must be inside a math node
	local p = node:parent()
	local in_math = false
	while p do
		if p:type() == "math" then
			in_math = true
			break
		end
		p = p:parent()
	end
	if not in_math then
		return false
	end

	-- reject if parent is also ident/field (i.e. not topmost)
	local parent = node:parent()
	if parent and parent:type() == "field" then
		return false
	end

	return true
end

-- Given any node that is part of a dotted expression (or just an ident),
-- find the topmost node representing the whole dotted expression, collect
-- all ident parts, and return the joined dotted name + range for that topmost node.
local function get_symbol_and_range(start_node, bufnr)
	-- climb up to the topmost 'field' node (if present)
	local top = start_node
	local p = top:parent()
	while p and p:type() == "field" do
		top = p
		p = top:parent()
	end

	-- collect parts (handles both ident and field nodes, and fallback)
	local parts = {}
	local function collect(n)
		if not n then
			return
		end
		local nt = n:type()
		if nt == "ident" or nt == "identifier" then
			table.insert(parts, vim.treesitter.get_node_text(n, bufnr))
		elseif nt == "field" then
			-- typical structure: (field <lhs> field: (ident))
			local lhs = n:child(0)
			local rhs_list = n:field("field")
			local rhs = (rhs_list and #rhs_list > 0) and rhs_list[1] or nil
			collect(lhs)
			if rhs then
				collect(rhs)
			end
		else
			-- fallback: traverse children to find ident nodes (robust to grammar variations)
			for i = 0, n:child_count() - 1 do
				collect(n:child(i))
			end
		end
	end

	collect(top)
	local sr, sc, er, ec = top:range()
	return table.concat(parts, "."), sr, sc, er, ec
end

local function set_conceal_extmark(bufnr, sr, sc, er, ec, ch)
	vim.api.nvim_buf_set_extmark(bufnr, ns_conceal, sr, sc, {
		end_row = er,
		end_col = ec,
		conceal = ch,
		hl_group = "Conceal",
		priority = 200,
	})
end

-- apply conceal to a buffer
local function apply_conceal()
	vim.api.nvim_buf_clear_namespace(buf, ns_conceal, 0, -1)

	local parser_ok, parser = pcall(vim.treesitter.get_parser, buf, "typst")
	if not parser_ok or not parser then
		return
	end
	local trees = parser:parse()
	if not trees or #trees == 0 then
		return
	end
	local root = trees[1]:root()

	for id, node in query:iter_captures(root, buf, 0, -1) do
		if query.captures[id] == "id" and is_symbol_root(node) then
			local name, sr, sc, er, ec = get_symbol_and_range(node, buf)
			local char = symbols[name]
			if char then
				set_conceal_extmark(buf, sr, sc, er, ec, char)
			end
		end
	end
end

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
	callback = function() apply_conceal() end,
	buffer = buf,
})
