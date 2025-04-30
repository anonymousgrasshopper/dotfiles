-- debugging
vim.b.codelldb_stdio_redirection = nil
-- stylua: ignore
vim.keymap.set("n", "<leader>oc", function()
	vim.b.codelldb_stdio_redirection = not vim.b.codelldb_stdio_redirection
end, { desc = "Toggle codelldb stdio redirection", buffer = true })

vim.keymap.set("n", "<localleader>dbg", function()
	vim.system({
		"clang++",
		"-fstandalone-debug",
		"--debug",
		vim.fn.expand("%"),
		"-o",
		vim.fn.fnamemodify(vim.fn.expand("%"), ":r") .. ".exe",
	}, {}, function(_)
		vim.notify("Compilation completed", "Info", { title = "Debugging" })
	end)

	if vim.b.codelldb_stdio_redirection == nil then
		local answer = vim.fn.input("Do you want to use codelldb stdio redirection ?")
		if answer:match("y") then
			vim.b.codelldb_stdio_redirection = true
		end
	end
	if vim.b.codelldb_stdio_redirection then
		vim.system({ "codelldb_stdio_redirection", vim.fn.fnamemodify(vim.fn.expand("%"), ":r") })
	end
end, { buffer = true })

vim.keymap.set("n", "<localleader>rm", function()
	vim.system({ "remove_codelldb_stdio_redirection", vim.fn.fnamemodify(vim.fn.expand("%"), ":r") })
end, { buffer = true })

-- compile and run SFML programs
vim.keymap.set("n", "<localleader>sf", function()
	vim.system({ "compile_sfml", vim.fn.fnamemodify(vim.fn.expand("%"), ":p:r") }, { text = true })
end, { expr = true, buffer = true })
