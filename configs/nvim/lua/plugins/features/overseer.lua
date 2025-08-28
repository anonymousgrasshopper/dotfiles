return {
	"stevearc/overseer.nvim",
	opts = {},
	cmd = {
		"OverseerRun",
	},
	config = function(_, opts)
		local overseer = require("overseer")

		overseer.setup(opts)

		vim.api.nvim_create_user_command("Grep", function(params)
			local args = vim.fn.expandcmd(params.args)
			-- Insert args at the '$*' in the grepprg
			local cmd, num_subs = vim.o.grepprg:gsub("%$%*", args)
			if num_subs == 0 then
				cmd = cmd .. " " .. args
			end
			local cwd
			local has_oil, oil = pcall(require, "oil")
			if has_oil then
				cwd = oil.get_current_dir()
			end

			local task = overseer.new_task({
				cmd = cmd,
				cwd = cwd,
				name = "grep " .. args,
				components = {
					{
						"on_output_quickfix",
						errorformat = vim.o.grepformat,
						open = not params.bang,
						open_height = 8,
						items_only = true,
					},
					-- We don't care to keep this around as long as most tasks
					{ "on_complete_dispose", timeout = 30, require_view = {} },
					"default",
				},
			})
			task:start()
		end, { nargs = "*", bang = true, bar = true, complete = "file" })

		vim.api.nvim_create_user_command("Make", function(params)
			-- Insert args at the '$*' in the makeprg
			local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
			if num_subs == 0 then
				cmd = cmd .. " " .. params.args
			end
			local task = require("overseer").new_task({
				cmd = vim.fn.expandcmd(cmd),
				components = {
					{ "on_output_quickfix", open = not params.bang, open_height = 8 },
					"unique",
					"default",
				},
			})
			task:start()
		end, {
			desc = "Run your makeprg as an Overseer task",
			nargs = "*",
			bang = true,
		})
	end,
}
