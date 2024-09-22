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
			{ "Add Testcase", "󱁐 add" },
			{ "Delete Testcase", "󱁐 delete" },
			{ "Run Program", "󱁐 run" },
			{ "Show pop-up Interface", "󱁐 show" },
      { "Download problem", "󱁐 problem" },
      { "Download entire contest", "󱁐 contest" }
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
    ["Sceptre"] = {
    { "Toggle Spectre", "󱁐 S",},
    {  "Search current word", "󱁐 sw" },
    { "Search current word", "󱁐 sw" },
    { "Search on current file", "󱁐 sp" },
    },
    ["LSP"] = {
      { "Stop LSP", ":LspStop" },
      { "Restart LSP", ":LspRestart"},
      { "Informations about active LSP", ":LspInfo" },
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
      { "Toggle Harpoon ui", "Alt+h" },
      { "Switch to Harpoon's i-th file", "Alt+p/m/l/o" },
    },
    ["Leap"] = {
      { "Leap forward", "s"},
      { "Leap backward", "S" },
      { "Leap from window", "gs" },
    },
		["Miscellaneous"] = {
			{ "Open Cheatsheet", "󱁐 ch" },
      { "Toggle UndoTree", "󱁐 tree" },
      { "Maximise/minimize current buffer", "󱁐 sm" },
      { "Format file", "󱁐 format" },
      { "Clear message line", "Ctrl+l" },
      { "Find Nerd icons", "󱁐 nerdy" },
      { "Browse link", ":Browse" },
      { "Change identifier", "󱁐 rn"},
      { "Toggle terminal session", "󱁐 term"}
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
		filetypes = { "nvcheatsheet" },
	},
}
 return M
