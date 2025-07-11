return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {
				enabled = true, -- enable this plugin (the default)
				enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
				highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
				highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
				show_stop_reason = true, -- show stop reason when stopped for exceptions
				commented = false, -- prefix virtual text with comment string
				only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
				all_references = false, -- show virtual text on all all references of the variable (not only definitions)
				clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
				virt_text_pos = "eol", -- "inline" or "eol"
			},
		},
	},
	cmd = { "DapContinue", "DapToggleBreakpoint" },
	keys = {
		{ "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
		{ "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
		{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
		{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
		{ "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
		{ "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
		{ "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
		{ "<leader>dg", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
		{ "<leader>dG", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
		{ "<leader>dj", function() require("dap").down() end, desc = "Down" },
		{ "<leader>dk", function() require("dap").up() end, desc = "Up" },
		{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle repl" },
		{ "<leader>ds", function() require("dap").session() end, desc = "Debugging session" },
		{ "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
		{ "<leader>dW", function() require("dap.ui.widgets").preview() end, desc = "Preview widgets" },
		{ "<leader>du", function() require("dapui").toggle() end, desc = "Toggle ui", silent = false },
		{ "<leader>df", function() local widgets = require("dap.ui.widgets") widgets.centered_float(widgets.frames) end },
		{ "<leader>ds", function() local widgets = require("dap.ui.widgets") widgets.centered_float(widgets.scopes) end },
		{ "<leader>dR", function() require("dap").restart() end, desc = "Restart", silent = false },
		{ "<leader>de", function() require("dapui").eval() end, desc = "Eval line", silent = false },
		{ "<leader>dl", function() require("dap").run_last() end, desc = "Run last", silent = false },
		{ "<leader>dT", function() require("dap").terminate() end, desc = "Terminate" },
	},

	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:r")

		-- icons
		local signs = {
			Stopped = { "󰁕", "DiagnosticWarn", "DapStoppedLine" },
			Breakpoint = { "" },
			BreakpointCondition = { "" },
			BreakpointRejected = { "", "DiagnosticError" },
			LogPoint = { ".>" },
		}
		for name, sign in pairs(signs) do
			vim.fn.sign_define("Dap" .. name, {
				text = sign[1],
				texthl = sign[2] or "DiagnosticInfo",
				linehl = sign[3],
				numhl = sign[3],
			})
		end

		-- setup dapui
		dap.listeners.before.attach.dapui_config = function() dapui.open() end
		dap.listeners.before.launch.dapui_config = function() dapui.open() end
		dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
		dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
		dapui.setup()

		-- keymaps
		local debugging_keymaps = {
			["t"] = function() require("dap").toggle_breakpoint() end,
			["i"] = function()
				require("dap.ui.widgets").hover()
				vim.cmd("hi Cursor blend=100")
			end,
			["c"] = function() require("dap").continue() end,
			["H"] = function() require("dap").step_out() end,
			["J"] = function() require("dap").step_over() end,
			["K"] = function() require("dap").step_back() end,
			["L"] = function() require("dap").step_into() end,
			["G"] = function() require("dap").run_to_cursor() end,
			["q"] = function() require("dap").terminate() end,
		}
		local buf
		dap.listeners.after["event_initialized"]["me"] = function()
			buf = vim.fn.bufnr()
			for key, callback in pairs(debugging_keymaps) do
				vim.keymap.set("n", key, callback, { buffer = buf })
			end
		end
		dap.listeners.after["event_terminated"]["me"] = function()
			for key, _ in pairs(debugging_keymaps) do
				vim.keymap.del("n", key, { buffer = buf })
			end
		end

		-- C++
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.env.HOME .. "/.local/share/nvim/mason/bin/codelldb",
				args = { "--port", "${port}" },
			},
		}

		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					if vim.b.use_default_executable_path then
						return vim.fn.fnamemodify(vim.fn.expand("%"), ":r") .. ".exe"
					end
					return vim.fn.input("Path to executable: ", vim.fn.fnamemodify(vim.fn.expand("%"), ":r") .. ".exe", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				stdio = function()
					if vim.b.codelldb_stdio_redirection then
						return { path .. ".in", path .. ".out", path .. ".err" }
					else
						return nil
					end
				end,
			},
		}

		-- automatically add a breakpoint at the beginning of main in C and C++
		dap.listeners.before.event_initialized["auto-main-breakpoint"] = function()
			if vim.tbl_contains({ "c", "cpp" }, vim.bo.filetype) then
				for lnum = 1, vim.fn.line("$") do
					if vim.fn.getline(lnum):match("^[%w_]*%s+main%s*%(") then
						vim.api.nvim_win_set_cursor(0, { lnum, 0 })
						require("dap").set_breakpoint()
						return
					end
				end
			end
		end
	end,
}
