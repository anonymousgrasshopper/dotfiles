local obsidian_vaults = {
	["Mathématiques"] = { vim.env.HOME .. "/Mathématiques/Mathématiques", "Solutions et Notes/Compétitions" },
}
local workspaces = {}
for vault, path in pairs(obsidian_vaults) do
	table.insert(workspaces, {
		name = vault,
		path = path[1],
		overrides = {
			notes_subdir = path[2],
		},
	})
end
local vault_enter = {}
for _, path in pairs(obsidian_vaults) do
	table.insert(vault_enter, "BufReadPre " .. path[1] .. "/*.md")
	table.insert(vault_enter, "BufNewFile " .. path[1] .. "/*.md")
end

return {
	-- {
	-- 	"OXY2DEV/markview.nvim",
	-- 	ft = "markdown",
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"nvim-tree/nvim-web-devicons",
	-- 	},
	-- 	opts = function()
	-- 		local presets = require("markview.presets")

	-- 		return {
	-- 			markdown = {
	-- 				headings = presets.headings.glow,
	-- 				list_items = {
	-- 					shift_width = function(buffer, item)
	-- 						local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth)
	-- 						return item.indent * (1 / (parent_indnet * 2))
	-- 					end,
	-- 					marker_minus = {
	-- 						add_padding = function(_, item) return item.indent > 1 end,
	-- 					},
	-- 				},
	-- 			},
	-- 			markdown_inline = {
	-- 				checkboxes = {
	-- 					checked = { text = "󰄲", hl = "MarkviewCheckboxChecked", scope_hl = "MarkviewCheckboxChecked" },
	-- 					unchecked = { text = "", hl = "MarkviewCheckboxUnchecked", scope_hl = "MarkviewCheckboxUnchecked" },
	-- 				},
	-- 			},
	-- 			latex = {
	-- 				enable = false,
	-- 			},
	-- 			preview = {
	-- 				icon_provider = "devicons",
	-- 			},
	-- 		}
	-- 	end,
	-- },
	-- {
	-- 	"bullets-vim/bullets.vim",
	-- 	ft = "markdown",
	-- },
	-- {
	-- 	"obsidian-nvim/obsidian.nvim",
	-- 	version = "*",
	-- 	event = vault_enter,
	-- 	-- dependencies:
	-- 	-- nvim-lua/plenary.nvim
	-- 	opts = {
	-- 		workspaces = workspaces,
	-- 		log_level = vim.log.levels.INFO,
	-- 		completion = {
	-- 			blink = true,
	-- 			nvim_cmp = false,
	-- 			min_chars = 2,
	-- 			picker = {
	-- 				name = "telescope.nvim",
	-- 				note_mappings = {
	-- 					-- Create a new note from your query.
	-- 					new = "<C-x>",
	-- 					-- Insert a link to the selected note.
	-- 					insert_link = "<C-l>",
	-- 				},
	-- 				tag_mappings = {
	-- 					-- Add tag(s) to current note.
	-- 					tag_note = "<C-x>",
	-- 					-- Insert a tag at the current location.
	-- 					insert_tag = "<C-l>",
	-- 				},
	-- 			},
	-- 			open_notes_in = "current", -- vsplit or hsplit

	-- 			ui = {
	-- 				enable = false, -- set to false to disable all additional syntax features
	-- 				update_debounce = 200, -- update delay after a text change (in milliseconds)
	-- 				max_file_length = 5000, -- disable UI features for files with more than this many lines
	-- 				checkboxes = {
	-- 					-- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
	-- 					[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
	-- 					["x"] = { char = "", hl_group = "ObsidianDone" },
	-- 					[">"] = { char = "", hl_group = "ObsidianRightArrow" },
	-- 					["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
	-- 					["!"] = { char = "", hl_group = "ObsidianImportant" },
	-- 				},
	-- 				bullets = { char = "•", hl_group = "ObsidianBullet" },
	-- 				external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
	-- 				reference_text = { hl_group = "ObsidianRefText" },
	-- 				highlight_text = { hl_group = "ObsidianHighlightText" },
	-- 				tags = { hl_group = "ObsidianTag" },
	-- 				block_ids = { hl_group = "ObsidianBlockID" },
	-- 				hl_groups = {
	-- 					ObsidianTodo = { bold = true, fg = "#f78c6c" },
	-- 					ObsidianDone = { bold = true, fg = "#89ddff" },
	-- 					ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
	-- 					ObsidianTilde = { bold = true, fg = "#ff5370" },
	-- 					ObsidianImportant = { bold = true, fg = "#d73128" },
	-- 					ObsidianBullet = { bold = true, fg = "#89ddff" },
	-- 					ObsidianRefText = { underline = true, fg = "#c792ea" },
	-- 					ObsidianExtLinkIcon = { fg = "#c792ea" },
	-- 					ObsidianTag = { italic = true, fg = "#89ddff" },
	-- 					ObsidianBlockID = { italic = true, fg = "#89ddff" },
	-- 					ObsidianHighlightText = { bg = "#75662e" },
	-- 				},
	-- 			},

	-- 			attachments = {
	-- 				img_folder = "assets/imgs",
	-- 				---@return string
	-- 				img_name_func = function()
	-- 					-- Prefix image names with timestamp.
	-- 					return string.format("Pasted image %s", os.date("%Y%m%d%H%M%S"))
	-- 				end,
	-- 				img_text_func = function(client, path)
	-- 					path = client:vault_relative_path(path) or path
	-- 					return string.format("![%s](%s)", path.name, path)
	-- 				end,
	-- 			},
	-- 			statusline = {
	-- 				enabled = false,
	-- 				format = "{{properties}} properties {{backlinks}} backlinks {{words}} words {{chars}} chars",
	-- 			},
	-- 		},
	-- 	},
	-- },
}
