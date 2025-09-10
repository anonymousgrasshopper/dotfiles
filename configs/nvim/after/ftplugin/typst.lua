vim.api.nvim_buf_create_user_command(0, "OpenPdf", function()
	local filepath = vim.api.nvim_buf_get_name(0)
	local pdf_path = filepath:gsub("%.typ$", ".pdf")
	vim.system({ "zathura", pdf_path })
end, {})

vim.keymap.set("n", "<localleader>o", "<Cmd>OpenPdf<CR>", { desc = "Open pdf", buffer = true })
