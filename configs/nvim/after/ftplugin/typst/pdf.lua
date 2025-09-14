-- open pdf
vim.api.nvim_buf_create_user_command(0, "OpenPdf", function()
	local filepath = vim.b.typst_root and vim.b.typst_root or vim.api.nvim_buf_get_name(0)
	local pdf_path = filepath:gsub("%.typ$", ".pdf")
	vim.system({ "zathura", pdf_path })
	vim.notify("Opening " .. pdf_path, vim.log.levels.INFO)
end, {})

vim.keymap.set("n", "<localleader>o", "<Cmd>OpenPdf<CR>", { desc = "Open pdf", buffer = true })
