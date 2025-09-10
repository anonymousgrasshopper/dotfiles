local M = {}

--- Check if cursor is inside a table of treesitter nodes
--- @return boolean | nil
function M.in_node(ignored_nodes)
	ignored_nodes = type(ignored_nodes) == table and ignored_nodes or { ignored_nodes }

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1

	-- Parse the tree and get its root
	local parser = vim.treesitter.get_parser(0, "typst")
	if not parser then return nil end
	local tree = parser:parse()[1]
	local root = tree:root()

	-- Find the smallest named node that spans the cursor
	local node = root:named_descendant_for_range(row, col, row, col)
	while node do
		if vim.tbl_contains(ignored_nodes, node:type()) then
			return true
		end
		node = node:parent()
	end
	return false
end

function M.not_in_node(ignored_nodes)
	return not M.in_node(ignored_nodes)
end

return M
