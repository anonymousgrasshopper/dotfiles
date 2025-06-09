-- debugging
vim.b.codelldb_stdio_redirection = nil
vim.keymap.set(
	"n",
	"<leader>oc",
	function() vim.b.codelldb_stdio_redirection = not vim.b.codelldb_stdio_redirection end,
	{ desc = "Toggle codelldb stdio redirection", buffer = true }
)

local open_floating_window = function(filepath)
	local buf = vim.api.nvim_get_current_buf()
	local bufnr = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_name(bufnr, filepath)

	-- if the file exists, load its contents
	if vim.fn.filereadable(filepath) == 1 then
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.fn.readfile(filepath))
	end

	-- set buffer options
	vim.bo[bufnr].buftype = ""
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].modifiable = true

	vim.keymap.set("n", "q", "<Cmd>wq<CR>", { buffer = bufnr, nowait = true, silent = true })

	-- Dimensions
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- Create the floating window
	local win_id = vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})
	vim.wo[win_id].number = true
	vim.wo[win_id].relativenumber = false
	vim.wo[win_id].cursorline = true

	-- Set an autocommand to detect when the window is closed
	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(win_id),
		callback = function()
			vim.b[buf].stdio_completed = true
			if vim.b[buf].compilation_completed then
				vim.defer_fn(function() require("dap").continue() end, 0)
			end
		end,
		once = true,
	})
end
local input_filename = vim.fn.fnamemodify(vim.fn.expand("%"), ":r") .. ".in"
vim.keymap.set(
	"n",
	"<localleader>di",
	function() open_floating_window(input_filename) end,
	{ desc = "Edit debugger input ", buffer = true }
)

vim.keymap.set("n", "<localleader>dbg", function()
	vim.cmd("silent! write")
	local buf = vim.api.nvim_get_current_buf()

	vim.b[buf].compilation_completed = false
	vim.system({
		"clang++",
		"-fstandalone-debug",
		"--debug",
		vim.fn.expand("%"),
		"-o",
		vim.fn.fnamemodify(vim.fn.expand("%"), ":r") .. ".exe",
	}, {}, function(obj)
		if obj.stderr ~= nil then
			if obj.stderr:match("error[^\n]*\n$") then
				vim.notify(obj.stderr, "Error", { title = "Compiler", icon = "" })
			elseif obj.stderr ~= "" then
				vim.notify(obj.stderr, "Warn", { title = "Compiler", icon = "" })
			end
		end
		if obj.code == 0 then
			vim.notify("Compilation completed", "Info", { title = "Debugging", icon = "" })
			vim.b[buf].compilation_completed = true
			vim.b[buf].use_default_executable_path = true
			if vim.b[buf].stdio_completed then
				vim.defer_fn(function() require("dap").continue() end, 0)
			end
		end
	end)

	local function file_exists(path)
		local f = io.open(path, "r")
		return f and io.close(f)
	end
	if file_exists(input_filename) then
		vim.b[buf].codelldb_stdio_redirection = true
		vim.b[buf].stdio_completed = true
		if vim.b[buf].compilation_completed then
			vim.defer_fn(function() require("dap").continue() end, 0)
		end
	elseif vim.b.codelldb_stdio_redirection == nil then
		local answer = vim.fn.input("Do you want to use stdio redirection ?")
		if answer:sub(1, 1) == "y" then
			vim.b[buf].codelldb_stdio_redirection = true
			open_floating_window(input_filename)
		else
			vim.notify("hey")
			vim.b[buf].codelldb_stdio_redirection = false
			vim.b[buf].stdio_completed = true
			if vim.b[buf].compilation_completed then
				vim.defer_fn(require("dap").continue(), 0)
			end
		end
	end
end, { buffer = true })

vim.keymap.set(
	"n",
	"<localleader>rm",
	function() vim.system({ "remove_codelldb_stdio_redirection", vim.fn.fnamemodify(vim.fn.expand("%"), ":r") }) end,
	{ buffer = true }
)

-- compile and run SFML programs
vim.keymap.set(
	"n",
	"<localleader>sf",
	function() vim.system({ "compile_sfml", vim.fn.fnamemodify(vim.fn.expand("%"), ":p:r") }, { text = true }) end,
	{ expr = true, buffer = true }
)
