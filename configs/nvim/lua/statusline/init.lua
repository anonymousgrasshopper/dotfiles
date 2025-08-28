local components = require("statusline.components")

-- Dynamic mode highlight
local function mode_hl(self) return { fg = "bg", bg = self.mode_color, bold = true } end

-- Initialize mode color
local function init_mode(self)
	self.mode = vim.fn.mode(1)
	self.mode_color = self.mode_colors[self.mode:sub(1, 1)] or "grey"
end

local SectionA = {
	init = init_mode,
	hl = mode_hl,
	static = {
		separator_color = "grey",
	},
	components.Space,
	{
		fallthrough = false,
		components.ExtensionA,
		components.ViMode,
	},
	components.Space,
	components.LeftSeparator,
}

local SectionB = {
	hl = { bg = "grey", fg = "fg" },
	static = {
		separator_color = "bg",
	},
	{
		fallthrough = false,
		components.ExtensionB,
		components.Git,
	},
	components.LeftSeparator,
}

local SectionC = {
	hl = { bg = "bg", fg = "fg" },
	components.Space,
	{
		fallthrough = false,
		components.ExtensionC,
		components.FileNameBlock,
	},
}

local Align = { provider = "%=" }

local SectionX = {
	hl = { bg = "bg", fg = "fg" },
	components.Macro,
	components.Space,
	components.Space,
	components.Diagnostics,
}

local SectionY = {
	hl = { bg = "grey", fg = "fg" },
	static = {
		separator_color = "bg",
	},
	components.RightSeparator,
	components.Space,
	{
		fallthrough = false,
		components.ExtensionY,
		components.Ruler,
	},
	components.Space,
}

local SectionZ = {
	init = init_mode,
	hl = mode_hl,
	static = {
		separator_color = "grey",
	},
	components.RightSeparator,
	components.Space,
	components.Time,
	components.Space,
}

local Statusline = {
	SectionA,
	SectionB,
	SectionC,
	Align,
	SectionX,
	SectionY,
	SectionZ,
}

return {
	hl = "Statusline",
	static = {
		mode_colors = {
			n = "blue",
			i = "green",
			v = "violet",
			V = "violet",
			["\22"] = "blue",
			c = "yellow",
			s = "violet",
			S = "violet",
			["\19"] = "violet",
			R = "red",
			r = "red",
			["!"] = "red",
			t = "yellow",
		},
		mode_color = function(self)
			local mode = vim.fn.mode() or "n"
			return self.mode_colors[mode]
		end,
	},
	Statusline,
}
