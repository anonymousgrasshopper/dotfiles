return {
	"nvim-lualine/lualine.nvim",
	event = "UiEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local lualine = require("lualine")
		local palette = require("kanagawa.colors").setup().palette

		local colors = {
			blue = palette.crystalBlue,
			green = palette.springGreen,
			violet = palette.oniViolet,
			yellow = palette.autumnYellow,
			red = palette.autumnRed,
			grey = palette.sumiInk6,
			fg = palette.springViolet2,
			bg = palette.sumiInk4,
			inactive_bg = palette.sumiInk0,
			semilightgray = palette.springViolet2,
		}

		local lualine_theme = {
			normal = {
				a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
				b = { bg = colors.grey, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				b = { bg = colors.grey, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
				b = { bg = colors.grey, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
				b = { bg = colors.grey, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.grey, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			inactive = {
				a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.semilightgray },
				c = { bg = colors.inactive_bg, fg = colors.semilightgray },
			},
		}

		local competitest = {
			filetypes = { "CompetiTest" },
			sections = {
				lualine_a = {
					function() return vim.b.competitest_title or "CompetiTest" end,
				},
				lualine_y = {
					function() return " " end,
				},
				lualine_z = {
					function() return " " .. os.date("%R") end,
				},
			},
		}

		local telescope = {
			filetypes = { "TelescopePrompt" },
			sections = {
				lualine_a = {
					function() return "Telescope" end,
				},
				lualine_y = {
					function() return "󰭎 " end,
				},
				lualine_z = {
					function() return " " .. os.date("%R") end,
				},
			},
		}

		local yazi = {
			filetypes = { "yazi" },
			sections = {
				lualine_a = {
					function() return "Yazi" end,
				},
				lualine_y = {
					function() return "󰇥 " end,
				},
				lualine_z = {
					function() return " " .. os.date("%R") end,
				},
			},
		}

		local toggleterm = {
			filetypes = { "toggleterm" },
			sections = {
				lualine_a = {
					function() return "Terminal #" .. vim.b.toggle_number end,
				},
				lualine_y = {
					function() return " " end,
				},
				lualine_z = {
					function() return " " .. os.date("%R") end,
				},
			},
		}

		local neo_tree = {
			filetypes = { "neo-tree" },
			sections = {
				lualine_a = {
					function() return vim.fn.fnamemodify(vim.fn.getcwd(), ":~") end,
				},
				lualine_y = {
					function() return "󰙅 " end,
				},
				lualine_z = {
					function() return " " .. os.date("%R") end,
				},
			},
		}

		local nvim_dap_ui = {
			filetypes = {
				"dap-repl",
				"dapui_scopes",
				"dapui_stacks",
				"dapui_watches",
				"dapui_console",
				"dapui_breakpoints",
			},
			sections = {
				lualine_a = {
					function() return vim.bo.filetype:match("[-_](%w+)$") end,
				},
				lualine_y = {
					function() return " " end,
				},
				lualine_z = {
					function() return " " .. os.date("%R") end,
				},
			},
		}

		local aerial = {
			filetypes = { "aerial" },
			sections = {
				lualine_a = {
					function() return "Aerial" end,
				},
				lualine_y = {
					function() return "󱏒 " end,
				},
				lualine_z = {
					function() return " " .. os.date("%R") end,
				},
			},
		}

		local lazy = {
			filetypes = { "lazy" },
			sections = {
				lualine_a = {
					function() return "Lazy" end,
				},
				lualine_b = {
					function() return "loaded: " .. require("lazy").stats().loaded .. "/" .. require("lazy").stats().count end,
				},
				lualine_c = {
					require("lazy.status").updates,
					cond = require("lazy.status").has_updates,
				},
				lualine_y = {
					function() return "󰒲 " end,
				},
				lualine_z = {
					function() return " " .. os.date("%R") end,
				},
			},
		}

		local mason = {
			filetypes = { "mason" },
			sections = {
				lualine_a = {
					function() return "Mason" end,
				},
				lualine_b = {
					function()
						return "Installed: "
							.. #require("mason-registry").get_installed_packages()
							.. "/"
							.. #require("mason-registry").get_all_package_specs()
					end,
				},
				lualine_y = {
					function() return " " end,
				},
				lualine_z = {
					function() return " " .. os.date("%R") end,
				},
			},
		}

		local git_root = function()
			if vim.b.lualine_git_dir then
				return vim.b.lualine_git_dir
			end
			local gitdir = vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.getcwd()))
			local isgitdir = vim.fn.matchstr(gitdir, "^fatal:.*") == ""
			vim.b.lualine_git_dir = isgitdir and vim.trim(vim.fn.fnamemodify(gitdir, ":t")) or "git"
			return vim.b.lualine_git_dir
		end

		local git = {
			filetypes = { "git", "fugitive" },
			sections = {
				lualine_a = {
					function() return " " .. vim.fn.FugitiveHead() end,
				},
				lualine_b = {
					{ git_root },
					{ "filetype", icon_only = true, padding = { left = 1, right = 1 } },
				},
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function() return " " .. os.date("%R") end,
				},
			},
		}

		local diffview = {
			filetypes = { "DiffviewFiles" },
			sections = {
				lualine_a = {
					function() return " " .. vim.fn.FugitiveHead() end,
				},
				lualine_b = { { git_root } },
				lualine_y = {
					function() return "󰊢 " end,
				},
				lualine_z = {
					function() return " " .. os.date("%R") end,
				},
			},
		}

		lualine.setup({
			options = {
				theme = lualine_theme,
				disabled_filetypes = { "alpha" },
			},
			ignore_focus = { "CompetiTest" },
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{ "branch" },
					{
						"diff",
						symbols = {
							added = " ",
							modified = " ",
							removed = " ",
						},
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
				},
				lualine_c = {
					{
						"filename",
						file_status = true, -- displays file status (readonly status, modified status)
						path = 3, -- 0 = just filename, 1 = relative path, 2 = absolute path, 3 = use ~ as home directory
						separator = " ",
						padding = { left = 1, right = 0 },
					},
					{ "filetype", icon_only = true, padding = { left = 0, right = 1 } },
				},
				lualine_x = {
					{
						require("noice").api.statusline.mode.get,
						cond = require("noice").api.statusline.mode.has,
						color = { fg = "#ff9e3b" },
					},
					{ "diagnostics" },
				},
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function() return " " .. os.date("%R") end,
				},
			},
			extensions = {
				git,
				aerial,
				"man",
				lazy,
				"fugitive",
				mason,
				nvim_dap_ui,
				neo_tree,
				toggleterm,
				competitest,
				telescope,
				diffview,
				yazi,
			},
		})
	end,
}
