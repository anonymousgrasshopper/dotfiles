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
	-- part_separator = { open = "", close = "" },
	part_separator = { open = "", close = "" },
	inverse_separator = { open = "", close = "" },

	style_a = {
		fg = "#1f1f28",
		bg_mode = {
			normal = "#7e9cd8",
			select = "#957FB8",
			un_set = "#dca561",
		},
	},

	style_b = { bg = "#54546d", fg = "#9cabca" },
	style_c = { bg = "#2a2a37", fg = "#9cabca" },

	permissions_t_fg = "#98bb6c",
	permissions_r_fg = "#e6c384",
	permissions_w_fg = "#ff5d62",
	permissions_x_fg = "#7aa89f",
	permissions_s_fg = "#957fb8",

	selected = { icon = "󰻭", fg = "#ffa066" },
	copied = { icon = "", fg = "#98bb6c" },
	cut = { icon = "", fg = "#e46876" },
	files = { icon = "", fg = "#7e9cd8" },
	filtereds = { icon = "", fg = "#957fb8" },

	total = { icon = "󰮍", fg = "#ff9e3b" },
	succ = { icon = "", fg = "#7aa89f" },
	fail = { icon = "", fg = "#e82424" },
	found = { icon = "󰮕", fg = "#7e9cd8" },
	processed = { icon = "󰐍", fg = "#6A9598" },

	tab_width = 20,
	tab_use_inverse = false,

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
				-- { type = "string", custom = false, name = "hovered_size" },
			},
			section_c = {
				-- { type = "string", custom = false, name = "hovered_path" },
				{ type = "coloreds", custom = false, name = "count" },
			},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "date", params = { "%R" } },
				{ type = "string", custom = true, name = "" },
			},
			section_b = {
				{ type = "string", custom = false, name = "cursor_position" },
				{ type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				{ type = "coloreds", custom = false, name = "permissions" },
			},
		},
	},
})
