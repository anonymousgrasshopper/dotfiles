vim.filetype.add({
	extension = {
		tex = "tex", -- without VimTex plaintex is assigned instead
		rasi = "css",
		muttrc = "neomuttrc",
	},
	filename = {
		["clang-format"] = "yaml",
		["dircolors"] = "dircolors",
	},
	pattern = {
		["${HOME}/.config/mutt/.+"] = "neomuttrc",
		["${HOME}/.config/kitty/.*.conf.bak"] = "kitty",
	},
})
