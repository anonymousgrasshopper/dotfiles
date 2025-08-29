local function get_session_name()
	local name = vim.fn.getcwd()
	local branch = vim.trim(vim.fn.system("git branch --show-current"))
	if vim.v.shell_error == 0 then
		return name .. branch
	else
		return name
	end
end

return {
	"stevearc/resession.nvim",
	keys = {
		{ "<leader>ss", function() require("resession").save() end, desc = "Save session" },
		{ "<leader>sl", function() require("resession").load() end, desc = "Load session" },
		{
			"<leader>sr",
			function() require("resession").load(get_session_name(), { dir = "dirsession", silence_errors = true }) end,
			desc = "Load session",
		},
		{ "<leader>sd", function() require("resession").delete() end, desc = "Delete session" },
	},
	opts = {
		-- Save and restore these options
		options = {
			"binary",
			"bufhidden",
			"buflisted",
			"diff",
			"filetype",
			"modifiable",
			"previewwindow",
			"readonly",
			"scrollbind",
			"winfixheight",
			"winfixwidth",
		},
		extensions = {
			quickfix = {},
			overseer = {},
		},
	},
	config = function(_, opts)
		local resession = require("resession")

		resession.setup(opts)

		-- vim.api.nvim_create_autocmd("VimEnter", {
		-- 	callback = function()
		-- 		-- Only load the session if nvim was started with no args
		-- 		if vim.fn.argc(-1) == 0 then
		-- 			resession.load(get_session_name(), { dir = "dirsession", silence_errors = true })
		-- 		end
		-- 	end,
		-- })
		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function() resession.save(get_session_name(), { dir = "dirsession", notify = false }) end,
		})
	end,
}
