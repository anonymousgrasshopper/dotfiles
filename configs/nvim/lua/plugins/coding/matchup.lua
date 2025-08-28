return {
	"andymass/vim-matchup",
	event = { "BufReadPre", "BufNewFile" },
	opts = function() vim.g.matchup_matchparen_offscreen = { method = "status_manual" } end,
}
