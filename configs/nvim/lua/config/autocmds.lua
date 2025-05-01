---------------------------------------------------------------------------------------------------
--------------------------------------------- AUTOCMDS  -------------------------------------------
---------------------------------------------------------------------------------------------------

-- show the cursorline in the active buffer only, and hide for some filetypes
vim.api.nvim_create_autocmd("WinLeave", {
	callback = function() vim.opt_local.cursorline = false end,
})
vim.api.nvim_create_autocmd("WinEnter", {
	callback = function()
		local excluded_filetypes = { "alpha", "neo-tree-popup" }
		if not vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
			vim.opt_local.cursorline = true
		end
	end,
})

-- hide the cursor in chosen filetypes
vim.api.nvim_create_autocmd({ "BufEnter", "CmdlineLeave" }, {
	callback = function()
		local enabled_filetypes = {
			"aerial",
			"alpha",
			"diff",
			"DiffviewFiles",
			"dropbar_menu",
			"neo-tree",
			"neo-tree-popup",
			"trouble",
			"undotree",
			"yazi",
		}
		if vim.tbl_contains(enabled_filetypes, vim.bo.filetype) or vim.g.undotree_settargetfocus then
			vim.cmd("hi Cursor blend=100")
		else
			vim.cmd("hi Cursor blend=0")
		end
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "alpha",
	callback = function() vim.cmd("hi Cursor blend=100") end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
	callback = function() vim.cmd("hi Cursor blend=0") end,
})

-- toggle some options in terminals and darken their background
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		if vim.g.code_action_preview then
			vim.api.nvim_create_autocmd("BufLeave", {
				group = vim.api.nvim_create_augroup("Code Action Preview", { clear = true }),
				callback = function()
					vim.g.code_action_preview = nil
					vim.api.nvim_del_augroup_by_name("Code Action Preview")
				end,
			})
			return
		end
		if vim.bo.filetype == "yazi" then
			return
		end

		vim.opt_local.cursorline = false
		vim.opt_local.winhighlight = "Normal:TerminalBackground"
		vim.cmd("startinsert")
	end,
})

-- Auto create dir when saving a file if some of the intermediate directories do not exist
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help", "diff", "tutor", "lspinfo", "grug-far", "checkhealth" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = event.buf, silent = true })
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
			return
		end
		vim.b[buf].last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "mail", "text", "plaintex", "typst", "gitcommit", "markdown", "tex" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true

		vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { desc = "Correct last spelling mistake", buffer = true })
		vim.keymap.set(
			"i",
			"<C-r>",
			"<c-g>u<Esc>[szg`]a<c-g>u",
			{ desc = "Add last word marked as misspelled to dictionnary", buffer = true }
		)
	end,
})

-- type 's ' in the command line to subsitute globally with very magic mode
vim.api.nvim_create_autocmd("CmdlineChanged", {
	pattern = "*",
	callback = function()
		local cmd_type = vim.fn.getcmdtype()
		local cmd_line = vim.fn.getcmdline()

		if cmd_type == ":" then
			if cmd_line == "s " then
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes("<C-u>%s/\\v//g<Left><Left><Left>", true, true, true),
					"n",
					false
				)
			elseif cmd_line == "'<,'>s " then
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes("<C-u>'<,'>s/\\v//g<Left><Left><Left>", true, true, true),
					"n",
					false
				)
			else
				local match = cmd_line:match("(%d+,%s*%d+%s*s) ")
				if match then
					vim.api.nvim_feedkeys(
						vim.api.nvim_replace_termcodes("<C-u>" .. match .. "/\\v//g<Left><Left><Left>", true, true, true),
						"n",
						false
					)
				end
			end
		end
	end,
})

-- restore the padding of the terminal emulator
if vim.env.TERM:match("kitty") then
	vim.api.nvim_create_autocmd("VimLeave", {
		callback = function() vim.cmd("silent !kitty @ set-spacing margin=20") end,
	})
end
