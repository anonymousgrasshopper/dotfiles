-- local buf = vim.api.nvim_get_current_buf()

-- local symbols = require("data.lang.typst.symbols_conceal")
-- local ns_conceal = vim.api.nvim_create_namespace("typst_conceal")

-- local query = vim.treesitter.query.parse("typst", "(ident) @id")

-- -- reconstruct full dotted symbol name from a node
-- local function full_symbol_name(node, bufnr)
-- 	local parts = {}

-- 	local function collect(n)
-- 		if not n then
-- 			return
-- 		end
-- 		if n:type() == "ident" then
-- 			table.insert(parts, vim.treesitter.get_node_text(n, bufnr))
-- 		elseif n:type() == "field" then
-- 			-- field structure: (field <lhs> field: (ident))
-- 			local lhs = n:child(0)
-- 			local rhs = n:field("field")[1]
-- 			collect(lhs)
-- 			if rhs then
-- 				collect(rhs)
-- 			end
-- 		end
-- 	end

-- 	collect(node)
-- 	return table.concat(parts, ".")
-- end

-- local function apply_conceal()
-- 	vim.api.nvim_buf_clear_namespace(buf, ns_conceal, 0, -1)

-- 	local parser = vim.treesitter.get_parser(buf, "typst", {})
-- 	if not parser then
-- 		return
-- 	end
-- 	local tree = parser:parse()[1]
-- 	local root = tree:root()

-- 	for id, node in query:iter_captures(root, buf, 0, -1) do
-- 		if query.captures[id] == "id" then
-- 			local text = full_symbol_name(node, buf)
-- 			local char = symbols[text]
-- 			if char then
-- 				local sr, sc, er, ec = node:range()
-- 				vim.api.nvim_buf_set_extmark(buf, ns_conceal, sr, sc, {
-- 					end_row = er,
-- 					end_col = ec,
-- 					conceal = char,
-- 					hl_group = "Conceal",
-- 					priority = 200,
-- 				})
-- 			end
-- 		end
-- 	end
-- end

-- vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
-- 	callback = function() apply_conceal() end,
-- 	buffer = buf,
-- })

-- -- conceal ^2 -> ² superscripts
-- -- conceal subscritps
