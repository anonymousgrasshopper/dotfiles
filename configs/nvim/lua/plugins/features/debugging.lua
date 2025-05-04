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
		{
			"<leader>dc",
			function() require("dap").continue() end,
			desc = "Continue",
		},
		{
			"<leader>dp",
			function() require("dap").pause() end,
			desc = "Pause",
		},
		{
			"<leader>dt",
			function() require("dap").toggle_breakpoint() end,
			desc = "Toggle Breakpoint",
		},
		{
			"<leader>dB",
			function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
			desc = "Breakpoint Condition",
		},
		{
			"<leader>di",
			function() require("dap").step_into() end,
			desc = "Step Into",
		},
		{
			"<leader>do",
			function() require("dap").step_out() end,
			desc = "Step Out",
		},
		{
			"<leader>dO",
			function() require("dap").step_over() end,
			desc = "Step Over",
		},
		{
			"<leader>dC",
			function() require("dap").run_to_cursor() end,
			desc = "Run to Cursor",
		},
		{
			"<leader>dg",
			function() require("dap").goto_() end,
			desc = "Go to Line (No Execute)",
		},
		{
			"<leader>dj",
			function() require("dap").down() end,
			desc = "Down",
		},
		{
			"<leader>dk",
			function() require("dap").up() end,
			desc = "Up",
		},
		{
			"<leader>dr",
			function() require("dap").repl.toggle() end,
			desc = "Toggle repl",
		},
		{
			"<leader>ds",
			function() require("dap").session() end,
			desc = "Debugging session",
		},
		{
			"<leader>dw",
			function() require("dap.ui.widgets").hover() end,
			desc = "Widgets",
		},
		{
			"<leader>dw",
			function() require("dap.ui.widgets").preview() end,
			desc = "Preview widgets",
		},
		{
			"<leader>du",
			function() require("dapui").toggle() end,
			desc = "Toggle ui",
			silent = false,
		},
		{
			"<leader>dR",
			function() require("dap").restart() end,
			desc = "Restart",
			silent = false,
		},
		{
			"<leader>de",
			function() require("dapui").eval() end,
			desc = "Eval line",
			silent = false,
		},
		{
			"<leader>dl",
			function() require("dap").run_last() end,
			desc = "Run last",
			silent = false,
		},
		{
			"<leader>dT",
			function()
				require("dap").terminate()
				require("dapui").close()
			end,
			desc = "Terminate",
		},
	},

	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:r")

		dap.listeners.before.attach.dapui_config = function() dapui.open() end
		dap.listeners.before.launch.dapui_config = function() dapui.open() end
		dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
		dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

		dapui.setup()

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.env.HOME .. "/.local/share/nvim/mason/bin/codelldb",
				args = { "--port", "${port}" },
				-- detached = false,
			},
		}

		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.fnamemodify(vim.fn.expand("%"), ":r") .. ".exe", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				stdio = function()
					if vim.b.codelldb_stdio_redirection then
						return { path .. ".input", path .. ".output", path .. ".errors" }
					else
						return nil
					end
				end,
			},
		}

		local signs = {
			Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
			Breakpoint = " ",
			BreakpointCondition = " ",
			BreakpointRejected = { " ", "DiagnosticError" },
			LogPoint = ".>",
		}
		for name, sign in pairs(signs) do
			sign = type(sign) == "table" and sign or { sign }
			vim.fn.sign_define("Dap" .. name, {
				text = sign[1],
				texthl = sign[2] or "DiagnosticInfo",
				linehl = sign[3],
				numhl = sign[3],
			})
		end

		vim.keymap.set("n", "<leader>df", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.frames)
		end)
		vim.keymap.set("n", "<leader>ds", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		end)
	end,
}
