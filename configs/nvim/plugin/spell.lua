local ns = vim.api.nvim_create_namespace("nospell_urls")

local function apply_nospell_extmarks(buf, init)
	local line_cnt = init and 0 or vim.api.nvim_win_get_cursor(0)[1] - 1
	local lines = init and vim.api.nvim_buf_get_lines(buf, 0, -1, false) or { vim.api.nvim_get_current_line() }
	if not init then
		vim.api.nvim_buf_clear_namespace(buf, ns, line_cnt, line_cnt + 1)
	end
	local nospell_patterns = {
		[[%w+://[%w%-%._~:/%?#%[%]@!$&'()*+,;=%%]+]], -- url
		[[[%w%.%+%-_]+@[%w%-]+%.%a+]], -- email
	}

	for linenr, line in ipairs(lines) do
		for _, pattern in ipairs(nospell_patterns) do
			for s, e in line:gmatch("()" .. pattern .. "()") do
				vim.api.nvim_buf_set_extmark(buf, ns, line_cnt + linenr - 1, s - 1, {
					end_col = e - 1,
					hl_mode = "combine",
					spell = false,
					priority = 101,
				})
			end
		end
	end
end

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
	callback = function(args)
		if vim.wo.spell then
			apply_nospell_extmarks(args.buf)
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	callback = function(args)
		if vim.wo.spell then
			apply_nospell_extmarks(args.buf, true)
		end
	end,
})
