return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	keys = {
		{ "<leader>rs", function() require("persistence").load() end, desc = "Restore session for cwd" },
		{ "<leader>ss", function() require("persistence").select() end, desc = "Search sessions" },
		{ "<leader>sa", function() require("persistence").stop() end, desc = "Stop session saving" },
	},
	opts = {},
}
