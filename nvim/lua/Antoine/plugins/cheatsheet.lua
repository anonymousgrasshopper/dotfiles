local M = { "smartinellimarco/nvcheatsheet.nvim" }

M.opts = {
	header = {
		"                                      ",
		"                                      ",
		"                                      ",
		"█▀▀ █░█ █▀▀ ▄▀█ ▀█▀ █▀ █░█ █▀▀ █▀▀ ▀█▀",
		"█▄▄ █▀█ ██▄ █▀█ ░█░ ▄█ █▀█ ██▄ ██▄ ░█░",
		"                                      ",
		"                                      ",
		"                                      ",
	},
	keymaps = {
		["Nvim Tree"] = {
      { "Toggle file explorer", "󱁐 ee" },
      { "Toggle file explorer on current file", "󱁐 ef" },
      { "Collapse file explorer", "󱁐 ec" },
      { "Expand All", "E" },
			{ "Add file", "a" },
			{ "Open file", "⏎/o" },
			{ "Rename file", "r" },
			{ "find", "f" },
			{ "Finish search", "F" },
			{ "Refresh Tree", "R / 󱁐 er" },
			{ "delete file or directory", "d" },
			{ "Cut", "x" },
			{ "Copy", "c" },
			{ "Paste", "p" },
			{ "Copy name", "y" },
			{ "Copy relative path", "Y" },
			{ "Copy absolute path", "gy" },
      { "Get help", "g?" },
		},
		["Comment"] = {
			{ "Comment line toggle", "gcc" },
			{ "Comment block toggle", "gbc" },
			{ "Comment visual selection", "gc" },
			{ "Comment visual selection using block delimiters", "gb" },
			{ "Comment out text object line wise", "gc<motion>" },
			{ "Comment out text object block wise", "gb<motion>" },
			{ "Add comment on the line above", "gcO" },
			{ "Add comment on the line below", "gco" },
			{ "Add comment at the end of line", "gcA" },
		},
		["Competitest"] = {
			{ "Add Testcase", "󱁐 c++add" },
			{ "Delete Testcase", "󱁐 c++delete" },
			{ "Run Program", "󱁐 c++run" },
			{ "Show pop-up Interface", "󱁐 c++show" },
		},
    ["Completions"] = {
      { "Previous suggestion", "Ctrl+k" },
      { "Next suggestion", "Ctrl+j" },
      -- { "", "Ctrl+b" },
      -- { "", "Ctrl+f" },
      -- { "", "Ctrl+󱁐" },
      { "Close completion window", "Ctrl+e" },
      { "Abort completion", "⏎" },
    },
		["Restore session"] = {
			{ "Restore session for cwd", "󱁐 wr" },
			{ "Save session for auto session root dir", "󱁐 ws" },
		},
    ["Telescope"] = {
      { "Fuzzy find files in cwd", "󱁐 ff" },
      { "Fuzzy find recent files", "󱁐 fr" },
      { "Find string in cwd", "󱁐 fs" },
      { "Find string under cursor in cwd", "󱁐 fc" },
      { "Next result", "Ctrl+j" },
      { "Previous result", "Ctrl+h" },
      { "Send to qflist", "Ctrl+q" },
    },
    ["Harpoon"] = {
      { "Add file to Harpoon", "󱁐 a" },
      { "Toggle Harpoon ui", "Ctrl+h" },
      { "Switch to Harpoon's i-th file", "Ctrl+h/t/n/s" },
    },
		["Miscellaneous"] = {
			{ "Open Cheatsheet", "󱁐 ch" },
			{ "Reload Plugin", "󱁐 rl" },
      { "Toggle Undotree", "󱁐 <F5>" },
      { "Maximise/minimize current buffer", "󱁐 sm" },
      { "Format file", "󱁐 format" },
		},
	},
}

function M.config(_, opts)
	local nvcheatsheet = require("nvcheatsheet")

	nvcheatsheet.setup(opts)

	-- You can also close it with <Esc>
	vim.keymap.set("n", "<leader>ch", nvcheatsheet.toggle)
end

extensions = {
	{
		sections = {
			lualine_a = {
				function()
					return "Cheatsheet"
				end,
			},
		},
		filetypes = { "Cheatsheet" },
	},
}

return M
