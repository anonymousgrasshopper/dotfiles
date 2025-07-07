return {
	"saghen/blink.indent",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		blocked = {
			buftypes = { "nofile", "help" },
			filetypes = { "undotree" },
		},
		static = {
			enabled = true,
			char = "│", -- ┊
			highlights = {
				"Indent",
			},
		},
		scope = {
			enabled = true,
			char = "│",
			highlights = {
				"IndentScope",
			},
		},
		underline = {
			enabled = false,
			highlights = {
				"IndentScope",
			},
		},
	},
}
