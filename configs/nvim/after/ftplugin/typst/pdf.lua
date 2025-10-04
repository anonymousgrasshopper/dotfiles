-- export pdf
vim.api.nvim_buf_create_user_command(0, "ExportPdf", function()
	local filepath = vim.b.typst_root and vim.b.typst_root or vim.api.nvim_buf_get_name(0)
	local client = vim.lsp.get_clients({ name = "tinymist" })[1]
	if client then
		client:exec_cmd({
			title = "exportpdf",
			command = "tinymist.exportPdf",
			arguments = { filepath },
		})
	else
		vim.notify("Tinymist is not running !", vim.log.levels.ERROR, { title = "Generate PDF", icon = "" })
	end
end, {})

vim.keymap.set("n", "<localleader>p", "<Cmd>ExportPdf<CR>", { desc = "Export pdf", buffer = true })

-- open pdf
vim.api.nvim_buf_create_user_command(0, "OpenPdf", function()
	local filepath = vim.b.typst_root and vim.b.typst_root or vim.api.nvim_buf_get_name(0)
	local pdf_path = filepath:gsub("%.typ$", ".pdf")
	if vim.uv.fs_stat(pdf_path) then
		vim.system({ "zathura", pdf_path }, {}, function(obj)
			if obj.code ~= 0 and obj.stderr then
				vim.notify(obj.stderr, vim.log.levels.ERROR, { title = "Open PDF", icon = "" })
			end
		end)
		vim.notify("Opening " .. pdf_path, vim.log.levels.INFO, { title = "Open PDF", icon = "" })
	else
		vim.notify(pdf_path .. " does not exist !", vim.log.levels.ERROR, { title = "Open PDF", icon = "" })
	end
end, {})

vim.keymap.set("n", "<localleader>o", "<Cmd>OpenPdf<CR>", { desc = "Open pdf", buffer = true })
