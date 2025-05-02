vim.filetype.add({
	extension = {
		tex = "tex", -- without VimTex plaintex is assigned instead
		rasi = "css",
		muttrc = "neomuttrc",
	},
	filename = {
		[".zshrc"] = "bash",
		[".zshenv"] = "bash",
		[".zlogout"] = "bash",
		[".zprofile"] = "bash",
		["clang-format"] = "yaml",
	},
	pattern = {
		["${HOME}/.config/mutt/.+"] = "neomuttrc",
		["${HOME}/.config/kitty/.*.conf.bak"] = "kitty",
	},
})
