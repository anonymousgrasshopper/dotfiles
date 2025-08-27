return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {},
	},
	{
		"olimorris/codecompanion.nvim",
		cmd = {
			"CodeCompanion",
			"CodeCompanionChat",
			"CodeCompanionActions",
			"CodeCompanionCmd",
		},
		opts = {},
		-- dependencies:
		-- 	nvim-lua/plenary.nvim
		-- 	nvim-treesitter/nvim-treesitter
	},
}
