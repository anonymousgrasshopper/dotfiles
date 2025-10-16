local components = {}

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

components.Space = { provider = " " }

components.LeftSeparator = {
	provider = "",
	hl = function(self) return { fg = self.separator_color } end,
}
components.RightSeparator = {
	provider = "",
	hl = function(self) return { fg = self.separator_color } end,
}

components.ViMode = {
	static = {
		mode_names = {
			n = "NORMAL",
			no = "NORMAL-",
			nov = "NORMAL-",
			noV = "NORMAL-",
			["no\22"] = "NORMAL-",
			niI = "NORMAL-",
			niR = "NORMAL-",
			niV = "NORMAL-",
			nt = "NORMAL-",
			v = "VISUAL",
			vs = "VISUAL-",
			V = "V-LINE",
			Vs = "V-LINE-",
			["\22"] = "V-BLOCK",
			["\22s"] = "V-BLOCK-",
			s = "SELECT",
			S = "S-LINE",
			["\19"] = "S-BLOCK",
			i = "INSERT",
			ic = "INSERT-",
			ix = "INSERT-",
			R = "REPLACE",
			Rc = "REPLACE-",
			Rx = "REPLACE-",
			Rv = "REPLACE-",
			Rvc = "REPLACE-",
			Rvx = "REPLACE-",
			c = "COMMAND",
			cv = "COMMAND-",
			r = "PROMPT",
			rm = "MORE",
			["r?"] = "CONFIRM",
			["!"] = "SHELL",
			t = "TERMINAL",
		},
	},
	provider = function(self) return self.mode_names[self.mode] end,
}

components.Git = {
	condition = conditions.is_git_repo,

	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or
		                   self.status_dict.removed ~= 0 or
		                   self.status_dict.changed ~= 0
	end,

	hl = { fg = "fg" },

	components.Space,
	{ -- git branch name
		provider = function(self) return " " .. self.status_dict.head end,
	},
	components.Space,
	{
		provider = function(self)
			local count = self.status_dict.added or 0
			return count > 0 and (" " .. count .. " ")
		end,
		hl = "GitSignsAdd",
	},
	{
		provider = function(self)
			local count = self.status_dict.changed or 0
			return count > 0 and (" " .. count .. " ")
		end,
		hl = "GitSignsChange",
	},
	{
		provider = function(self)
			local count = self.status_dict.removed or 0
			return count > 0 and (" " .. count .. " ")
		end,
		hl = "GitSignsDelete",
	},
}

local FileNameBlock = {
	init = function(self) self.filename = vim.api.nvim_buf_get_name(0) end,
}

local FileName = {
	provider = function(self)
		local filename = vim.fn.fnamemodify(self.filename, ":~")
		if filename == "" then
			return "[No Name]"
		end
		if not conditions.width_percent_below(#filename, 0.30) then
			filename = vim.fn.pathshorten(filename, 3)
		end
		return filename
	end,
	hl = { fg = utils.get_highlight("Directory").fg },
}

local FileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self) return self.icon and self.icon end,
	hl = function(self) return { fg = self.icon_color } end,
}

local FileFlags = {
	{
		condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
		provider = " ",
		hl = { fg = "fg" },
	},
	{
		condition = function()
			local filename = vim.fn.expand("%")
			if
				filename ~= ""
				and filename:match("^%a+://") == nil
				and vim.bo.buftype == ""
				and vim.fn.filereadable(filename) == 0
			then
				return true
			end
			return false
		end,
		provider = " ",
	},
	{
		condition = function() return vim.bo.modified end,
		provider = " ●",
		hl = { fg = "green" },
	},
}

components.FileNameBlock = utils.insert(
	FileNameBlock,
	FileName,
	components.Space,
	FileIcon,
	components.Space,
	FileFlags,
	{ provider = "%<" } -- this means that the statusline is cut here when there's not enough space
)

components.Macro = {
	condition = function() return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0 end,
	provider = function() return " " .. vim.fn.reg_recording() .. "  " end,
	hl = { fg = "orange"},
	update = {
		"RecordingEnter",
		"RecordingLeave",
	},
}

local function OverseerTasksForStatus(status)
	return {
		condition = function(self) return self.tasks[status] end,
		provider = function(self) return string.format("%s%d ", self.symbols[status], #self.tasks[status]) end,
		hl = function(self)
			return {
				fg = utils.get_highlight(string.format("Overseer%s", status)).fg,
			}
		end,
	}
end
components.Overseer = {
	condition = function() return package.loaded.overseer end,
	init = function(self)
		local tasks = require("overseer.task_list").list_tasks({ unique = true })
		local tasks_by_status = require("overseer.util").tbl_group_by(tasks, "status")
		self.tasks = tasks_by_status
	end,
	static = {
		symbols = {
			["CANCELED"] = " ",
			["FAILURE"] = " ",
			["SUCCESS"] = "󰄴 ",
			["RUNNING"] = "󰑮 ",
		},
	},

	OverseerTasksForStatus("CANCELED"),
	OverseerTasksForStatus("RUNNING"),
	OverseerTasksForStatus("SUCCESS"),
	OverseerTasksForStatus("FAILURE"),
}

components.Debugger = {
	condition = function()
		if package.loaded.dap then
			local session = require("dap").session()
			return session ~= nil
		end
		return false
	end,
	provider = function() return " " .. require("dap").status() end,
	hl = "Debug",
	-- see Click-it! section for clickable actions
}

components.Diagnostics = {
	condition = conditions.has_diagnostics,

	init = function(self)
		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

		self.error_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.ERROR]
		self.warn_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.WARN]
		self.info_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.INFO]
		self.hint_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.HINT]
	end,

	update = { "DiagnosticChanged", "BufEnter" },

	{
		provider = function(self) return self.errors > 0 and (self.error_icon .. " " .. self.errors .. " ") end,
		hl = "DiagnosticSignError",
	},
	{
		provider = function(self) return self.warnings > 0 and (self.warn_icon .. " " .. self.warnings .. " ") end,
		hl = "DiagnosticSignWarn",
	},
	{
		provider = function(self) return self.info > 0 and (self.info_icon .. " " .. self.info .. " ") end,
		hl = "DiagnosticSignInfo",
	},
	{
		provider = function(self) return self.hints > 0 and (self.hint_icon .. " " .. self.hints .. " ") end,
		hl = "DiagnosticSignHint",
	},
}

components.Ruler = {
	provider = "%P %5(%l:%c%)",
	hl = { fg = "fg", bg = "grey" },
}

components.Time = {
	provider = function() return " " .. os.date("%R") end,
}

local function is_loclist() return vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 end

local extension_filetypes = {
	"aerial",
	"checkhealth",
	"CompetiTest",
	"dap-repl",
	"dapui_scopes",
	"dapui_stacks",
	"dapui_watches",
	"dapui_console",
	"dapui_breakpoints",
	"DiffviewFiles",
	"fugitive",
	"git",
	"lazy",
	"man",
	"neo-tree",
	"qf",
	"toggleterm",
	"TelescopePrompt",
	"yazi",
	"undotree",
}

components.ExtensionA = {
	condition = function() return vim.tbl_contains(extension_filetypes, vim.bo.filetype) end,
	init = function(self)
		self.ft = vim.bo.filetype
		self.extension_names = {
			["aerial"] = function() return "Aerial" end,
			["checkhealth"] = function() return "Health" end,
			["CompetiTest"] = function() return vim.b.competitest_title or "CompetiTest" end,
			["dap-repl"] = function() return "repl" end,
			["dapui_scopes"] = function() return "Scopes" end,
			["dapui_stacks"] = function() return "Call Stack" end,
			["dapui_watches"] = function() return "Watches" end,
			["dapui_console"] = function() return "Console" end,
			["dapui_breakpoints"] = function() return "Breakpoints" end,
			["DiffviewFiles"] = function() return " " .. (vim.b.gitsigns_status_dict.head or " ") end,
			["fugitive"] = function() return " " .. (vim.b.gitsigns_status_dict.head or " ") end,
			["git"] = function() return " " .. (vim.b.gitsigns_status_dict.head or " ") end,
			["lazy"] = function() return "Lazy" end,
			["man"] = function() return "MAN" end,
			["neo-tree"] = function() return vim.fn.fnamemodify(vim.fn.getcwd(), ":~") end,
			["qf"] = function() return is_loclist() and "Location List" or "Quickfix List" end,
			["TelescopePrompt"] = function() return "Telescope" end,
			["toggleterm"] = function() return "Terminal #" .. vim.b.toggle_number end,
			["yazi"] = function() return "Yazi" end,
			["undotree"] = function() return "Undotree" end,
		}
	end,
	provider = function(self) return self.extension_names[vim.bo.filetype]() end,
}

components.ExtensionB = {
	init = function(self)
		local git_root = require("utils.git").git_root

		self.ft = vim.bo.filetype
		self.extension_left = {
			["checkhealth"] = function() return "󰓙 " end,
			["lazy"] = function() return "loaded: " .. require("lazy").stats().loaded .. "/" .. require("lazy").stats().count end,
			["man"] = function() return vim.fn.expand("%"):sub(7) end,
			["diffview"] = git_root,
			["fugitive"] = git_root,
			["git"] = git_root,
			["qf"] = function()
				if is_loclist() then
					return vim.fn.getloclist(0, { title = 0 }).title
				end
				return vim.fn.getqflist({ title = 0 }).title
			end,
		}
	end,
	condition = function()
		local filetypes = {
			"checkhealth",
			"diffview",
			"fugitive",
			"git",
			"lazy",
			"man",
			"qf",
		}
		return vim.tbl_contains(filetypes, vim.bo.filetype)
	end,
	components.Space,
	{
		provider = function(self) return self.extension_left[vim.bo.filetype]() end,
	},
	components.Space,
}

components.ExtensionC = {
	condition = function() return vim.tbl_contains(extension_filetypes, vim.bo.filetype) end,
	components.Space,
	{
		provider = function()
			if vim.bo.filetype == "lazy" then
				if pcall(require("lazy.status").has_updates) then
					return require("lazy.status").updates()
				end
			end
		end,
	},
	components.Space,
}

components.ExtensionY = {
	condition = function(self) return self.extension_icons[vim.bo.filetype] end,
	init = function(self) self.ft = vim.bo.filetype end,
	static = {
		extension_icons = {
			["aerial"] = "󱏒",
			["CompetiTest"] = "",
			["dap-repl"] = "",
			["dapui_scopes"] = "",
			["dapui_stacks"] = "",
			["dapui_watches"] = "",
			["dapui_console"] = "",
			["dapui_breakpoints"] = "",
			["DiffviewFiles"] = "󰊢",
			["lazy"] = "󰒲",
			["man"] = "󱚊",
			["neo-tree"] = "󰙅",
			["TelescopePrompt"] = "󰭎",
			["toggleterm"] = " ",
			["undotree"] = "󱁊",
			["yazi"] = "󰇥",
		},
	},
	provider = function(self) return self.extension_icons[vim.bo.filetype] end,
}

return components
