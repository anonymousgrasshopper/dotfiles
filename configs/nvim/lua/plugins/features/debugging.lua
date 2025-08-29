return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				clear_on_continue = false,
				virt_text_pos = "eol", -- "inline" or "eol"
			},
		},
	},
	cmd = { "DapContinue", "DapToggleBreakpoint" },
	keys = {
		{ "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
		{ "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
		{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
		{
			"<leader>dB",
			function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
			desc = "Breakpoint Condition",
		},
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
		{ "<leader>df", function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames) end },
		{ "<leader>ds", function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes) end },
		{ "<leader>dR", function() require("dap").restart() end, desc = "Restart", silent = false },
		{ "<leader>de", function() require("dapui").eval() end, desc = "Eval line", silent = false },
		{ "<leader>dl", function() require("dap").run_last() end, desc = "Run last", silent = false },
		{ "<leader>dT", function() require("dap").terminate() end, desc = "Terminate" },
	},

	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local path = vim.fn.expand("%:p:r")

		-- setup dapui
		dap.listeners.before.attach.dapui_config = function() dapui.open() end
		dap.listeners.before.launch.dapui_config = function() dapui.open() end
		dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
		dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
		dapui.setup()

		-- keymaps
		local debugging_keymaps = {
			["b"] = function() dap.toggle_breakpoint() end,
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
		dap.listeners.after["event_initialized"]["me"] = function()
			for key, callback in pairs(debugging_keymaps) do
				vim.keymap.set("n", key, callback)
			end
		end
		dap.listeners.after["event_terminated"]["me"] = function()
			for key, _ in pairs(debugging_keymaps) do
				vim.keymap.del("n", key)
			end
		end

		local telescope_find_executable = function()
			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			return coroutine.create(function(coro)
				local opts = require("telescope.themes").get_dropdown({})
				local exclude = {
					".git/*",
					"build/_deps",
					"CMakeFiles",
				}
				local cmd = { "fd", "--hidden", "--no-ignore", "--type", "x" }
				for _, pattern in pairs(exclude) do
					table.insert(cmd, "--exclude")
					table.insert(cmd, pattern)
				end
				pickers
					.new(opts, {
						prompt_title = "Path to executable",
						finder = finders.new_oneshot_job(cmd, {}),
						sorter = conf.generic_sorter(opts),
						attach_mappings = function(buffer_number)
							actions.select_default:replace(function()
								actions.close(buffer_number)
								coroutine.resume(coro, action_state.get_selected_entry()[1])
							end)
							return true
						end,
					})
					:find()
			end)
		end

		-- run with args
		vim.api.nvim_create_user_command("RunWithArgs", function(obj)
			local args = require("utils").shell_split(vim.fn.expand(obj.args))
			dap.run({
				type = vim.bo.filetype,
				request = "launch",
				name = "Launch file with custom arguments (adhoc)",
				program = telescope_find_executable(),
				args = args,
			})
		end, {
			complete = "file",
			nargs = "*",
		})
		vim.keymap.set("n", "<leader>R", ":RunWithArgs ")

		-- C++
		dap.adapters.cpp = {
			type = "server",
			port = "${port}",
			executable = {
				command = "/usr/bin/codelldb",
				args = { "--port", "${port}" },
			},
		}

		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "cpp",
				request = "launch",
				program = function()
					if vim.b.use_default_executable_path then
						return vim.fn.expand("%:r") .. ".out"
					end
					return telescope_find_executable()
					-- return vim.fn.input("Path to executable: ", vim.fn.expand("%:r") .. ".out", "file")
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
