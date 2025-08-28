local M = {}

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

M.Space = { provider = " " }

M.LeftSeparator = {
	provider = "",
	hl = function(self) return { fg = self.separator_color } end,
}
M.RightSeparator = {
	provider = "",
	hl = function(self) return { fg = self.separator_color } end,
}

M.ViMode = {
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
	update = {
		"ModeChanged",
		pattern = "*:*",
		callback = vim.schedule_wrap(function() vim.cmd("redrawstatus") end),
	},
}

M.Git = {
	condition = conditions.is_git_repo,

	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,

	hl = { fg = "fg" },

	M.Space,
	{ -- git branch name
		provider = function(self) return " " .. self.status_dict.head end,
		hl = { bold = true },
	},
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
	M.Space,
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
		if not conditions.width_percent_below(#filename, 0.25) then
			filename = vim.fn.pathshorten(filename)
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

M.FileNameBlock = utils.insert(
	FileNameBlock,
	FileName,
	M.Space,
	FileIcon,
	M.Space,
	FileFlags,
	{ provider = "%<" } -- this means that the statusline is cut here when there's not enough space
)

M.Overseer = {
	condition = function()
		local ok, _ = pcall(require, "overseer")
		if ok then
			return true
		end
	end,
	init = function(self)
		self.overseer = require("overseer")
		self.tasks = self.overseer.task_list
		self.STATUS = self.overseer.constants.STATUS
	end,
	static = {
		symbols = {
			["FAILURE"] = "  ",
			["CANCELED"] = "  ",
			["SUCCESS"] = "  ",
			["RUNNING"] = " 省",
		},
		colors = {
			["FAILURE"] = "red",
			["CANCELED"] = "grey",
			["SUCCESS"] = "green",
			["RUNNING"] = "yellow",
		},
	},
	{
		condition = function(self) return #self.tasks.list_tasks() > 0 end,
		{
			provider = function(self)
				local tasks_by_status = self.overseer.util.tbl_group_by(self.tasks.list_tasks({ unique = true }), "status")

				for _, status in ipairs(self.STATUS.values) do
					local status_tasks = tasks_by_status[status]
					if self.symbols[status] and status_tasks then
						self.color = self.colors[status]
						return self.symbols[status]
					end
				end
			end,
			hl = function(self) return { fg = self.color } end,
		},
	},
}

M.Debugger = {
	condition = function()
		local session = require("dap").session()
		return session ~= nil
	end,
	provider = function() return " " .. require("dap").status() end,
	hl = "Debug",
	-- see Click-it! section for clickable actions
}

M.Macro = {
	condition = function() return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0 end,
	provider = function() return " " .. vim.fn.reg_recording() .. "  " end,
	hl = { fg = "orange", bold = true },
	update = {
		"RecordingEnter",
		"RecordingLeave",
	},
}

M.Diagnostics = {
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

M.Ruler = {
	provider = "%P %5(%l:%c%)",
	hl = { fg = "fg", bg = "grey" },
}

M.Time = {
	init = function(self) self.mode = vim.fn.mode(1) end,
	provider = function() return " " .. os.date("%R") end,
	update = {
		"ModeChanged",
		pattern = "*:*",
		callback = vim.schedule_wrap(function() vim.cmd("redrawstatus") end),
	},
}

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
	"mason",
	"neo-tree",
	"toggleterm",
	"TelescopePrompt",
	"yazi",
	"undotree",
}

M.ExtensionA = {
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
			["mason"] = function() return "Mason" end,
			["neo-tree"] = function() return vim.fn.fnamemodify(vim.fn.getcwd(), ":~") end,
			["TelescopePrompt"] = function() return "Telescope" end,
			["toggleterm"] = function() return "Terminal #" .. vim.b.toggle_number end,
			["yazi"] = function() return "Yazi" end,
			["undotree"] = function() return "Undotree" end,
		}
	end,
	provider = function(self) return self.extension_names[vim.bo.filetype]() end,
}

M.ExtensionB = {
	init = function(self)
		local git_root = require("utils").git_root

		self.ft = vim.bo.filetype
		self.extension_left = {
			["checkhealth"] = function() return "󰓙 " end,
			["lazy"] = function() return "loaded: " .. require("lazy").stats().loaded .. "/" .. require("lazy").stats().count end,
			["mason"] = function()
				return "Installed: "
					.. #require("mason-registry").get_installed_packages()
					.. "/"
					.. #require("mason-registry").get_all_package_specs()
			end,
			["diffview"] = git_root,
			["fugitive"] = git_root,
			["git"] = git_root,
		}
	end,
	condition = function()
		local filetypes = {
			"checkhealth",
			"diffview",
			"fugitive",
			"git",
			"lazy",
			"mason",
		}
		return vim.tbl_contains(filetypes, vim.bo.filetype)
	end,
	M.Space,
	{
		provider = function(self) return self.extension_left[vim.bo.filetype]() end,
	},
	M.Space,
}

M.ExtensionC = {
	condition = function() return vim.tbl_contains(extension_filetypes, vim.bo.filetype) end,
	M.Space,
	{
		provider = function()
			if vim.bo.filetype == "lazy" then
				if pcall(require("lazy.status").has_updates) then
					return require("lazy.status").updates()
				end
			end
		end,
	},
	M.Space,
}

M.ExtensionY = {
	condition = function()
		local excluded_filetypes = {
			"checkhealth",
			"git",
			"fugitive",
		}
		return not vim.tbl_contains(excluded_filetypes, vim.bo.filetype)
			and vim.tbl_contains(extension_filetypes, vim.bo.filetype)
	end,
	init = function(self)
		self.ft = vim.bo.filetype
		self.extension_icons = {
			["aerial"] = "󱏒 ",
			["CompetiTest"] = " ",
			["dap-repl"] = " ",
			["dapui_scopes"] = " ",
			["dapui_stacks"] = " ",
			["dapui_watches"] = " ",
			["dapui_console"] = " ",
			["dapui_breakpoints"] = " ",
			["DiffviewFiles"] = "󰊢 ",
			["lazy"] = "󰒲 ",
			["mason"] = " ",
			["neo-tree"] = "󰙅 ",
			["TelescopePrompt"] = "󰭎 ",
			["toggleterm"] = " ",
			["undotree"] = "󱁊 ",
			["yazi"] = "󰇥 ",
		}
	end,
	provider = function(self) return self.extension_icons[vim.bo.filetype] end,
}

return M
