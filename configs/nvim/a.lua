filter = function(client_name, code_action)
	local ignored_patterns = {
		["lua_ls"] = { "Change to parameter" },
	}
	return not vim.tbl_contains(
		ignored_patterns[client_name] or {},
		function(pattern) return code_action.title:match(pattern) end
	)
end
local str = "Change to parameter 1 of vim.tbl_deep exten"
print(str:match("Change to parameter"))
-- print(filter("lua_ls",))
-- print()
