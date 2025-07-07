-- don't mark urls and email adresses as misspelled
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	callback = function()
		vim.cmd([[
			syntax match url '\w\+:\/\/[a-zA-Z0-9\-._~:/?#\[\]@!$&''()*+,;=%]\+' contains=@NoSpell
			syntax match email '[a-zA-Z0-9._%+-]\+@[a-zA-Z0-9.-]\+\.[a-zA-Z]\+' contains=@NoSpell
		]])
	end,
})
