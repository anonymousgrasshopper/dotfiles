return {
	"rmagatti/auto-session",
  event = "VeryLazy",
  priority = 95,
  keys = {
    { "<leader>rs", "<cmd>SessionRestore<CR>", desc = "Restore session for cwd" },
    { "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session for auto session root dir" },
  },
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_restore_enabled = false,
			auto_session_suppress_dirs = { },
		})
	end,
}
