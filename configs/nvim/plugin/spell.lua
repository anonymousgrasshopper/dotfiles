local ns = vim.api.nvim_create_namespace("nospell_urls")

local function apply_nospell_extmarks(buf, first, last)
	local lines = vim.api.nvim_buf_get_lines(buf, first, last, false)
	vim.api.nvim_buf_clear_namespace(buf, ns, first, last)

	local nospell_patterns = {
		[[%w+://[%w%-%._~:/%?#%[%]@!$&'()*+,;=%%]+]], -- url
		[[[%w%.%+%-_]+@[%w%-]+%.%a+]], -- email
	}

	for linenr, line in ipairs(lines) do
		for _, pattern in ipairs(nospell_patterns) do
			for s, e in line:gmatch("()" .. pattern .. "()") do
				vim.api.nvim_buf_set_extmark(buf, ns, first + linenr - 1, s - 1, {
					end_col = e - 1,
					hl_mode = "combine",
					spell = false,
					priority = 101,
				})
			end
		end
	end
end

vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local buf = args.buf
		apply_nospell_extmarks(buf, 0, -1)
		vim.api.nvim_buf_attach(buf, false, {
			on_lines = function(_, _, _, first, last)
				if vim.wo.spell then
					apply_nospell_extmarks(buf, first, last)
				end
			end,
		})
	end,
})
