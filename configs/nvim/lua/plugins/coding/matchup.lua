return {
	"andymass/vim-matchup",
	event = { "BufReadPre", "BufNewFile" },
	opts = function()
		vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
		vim.cmd("call matchup#util#append_match_words('<<<<<<<:|||||||:=======:>>>>>>>')") -- git conflicts
	end,
}
