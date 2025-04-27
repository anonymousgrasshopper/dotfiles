---@diagnostic disable: undefined-global

require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

th.git = th.git or {}
th.git.added_sign = " "
th.git.modified_sign = " "
th.git.deleted_sign = "󱟃 "
th.git.updated_sign = " "
th.git.untracked_sign = " "
th.git.ignored_sign = ""
require("git"):setup()

require("yatline"):setup({
	section_separator = { open = "", close = "" },
	part_separator = { open = "", close = "" },
	inverse_separator = { open = "", close = "" },

	style_a = {
		fg = "#1f1f28",
		bg_mode = {
			normal = "#7e9cd8",
			select = "957FB8",
			un_set = "#dca561",
		},
	},
	style_b = { bg = "#54546d", fg = "#9cabca" },
	style_c = { bg = "#1f1f28", fg = "#9cabca" },

	permissions_t_fg = "#98bb6c",
	permissions_r_fg = "#e6c384",
	permissions_w_fg = "#ff5d62",
	permissions_x_fg = "#7aa89f",
	permissions_s_fg = "#957fb8",

	tab_width = 20,
	tab_use_inverse = false,

	selected = { icon = "󰻭", fg = "#ffa066" },
	copied = { icon = "", fg = "#98bb6c" },
	cut = { icon = "", fg = "#e46876" },

	total = { icon = "󰮍", fg = "#ff9e3b" },
	succ = { icon = "", fg = "#7aa89f" },
	fail = { icon = "", fg = "#e82424" },
	found = { icon = "󰮕", fg = "#7e9cd8" },
	processed = { icon = "󰐍", fg = "#6A9598" },

	show_background = true,

	display_header_line = true,
	display_status_line = true,

	component_positions = { "header", "tab", "status" },

	status_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_mode" },
			},
			section_b = {
				{ type = "string", custom = false, name = "hovered_size" },
			},
			section_c = {
				-- {type = "string", custom = false, name = "hovered_path"},
				{ type = "coloreds", custom = false, name = "count" },
			},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "cursor_position" },
			},
			section_b = {
				{ type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				-- {type = "string", custom = false, name = "hovered_file_extension", params = {true}},
				{ type = "coloreds", custom = false, name = "permissions" },
			},
		},
	},

	-- header_line = {
	--   left = {
	--     section_a = {
	--       {type = "line", custom = false, name = "tabs", params = {"left"}},
	--     },
	--     section_b = {
	--     },
	--     section_c = {
	--     }
	--   },
	--   right = {
	--     section_a = {
	--       {type = "string", custom = false, name = "date", params = {"%A, %d %B %Y"}},
	--     },
	--     section_b = {
	--       {type = "string", custom = false, name = "date", params = {"%X"}},
	--     },
	--     section_c = {
	--     }
	--   }
	-- },
})
