local M = {}

local highlights = require("neo-tree.ui.highlights")

M.filtered_by = function(_, node, state)
	local fby = node.filtered_by
	if not state.filtered_items or type(fby) ~= "table" then
		return {}
	end
	repeat
		if fby.name then
			return {
				text = "(hide by name)",
				highlight = highlights.HIDDEN_BY_NAME,
			}
		elseif fby.pattern then
			return {
				text = "(hide by pattern)",
				highlight = highlights.HIDDEN_BY_NAME,
			}
		elseif fby.gitignored then
			return {
				text = "(gitignored)",
				highlight = highlights.GIT_IGNORED,
			}
		elseif fby.dotfiles then
			return {
				text = "(dotfile)",
				highlight = highlights.DOTFILE,
			}
		elseif fby.hidden then
			return {
				text = "(hidden)",
				highlight = highlights.WINDOWS_HIDDEN,
			}
		end
		fby = fby.parent
	until not state.filtered_items.children_inherit_highlights or not fby
	return {}
end

function M.get_icon(config, node, state)
	config = {
		folder_closed = "",
		folder_open = "",
		folder_empty = "󰷏",
		folder_empty_open = "󰷏",
		default = "",
	}
	local icon = { text = nil, highlight = nil }
	if node.type == "directory" then
		icon.highlight = highlights.DIRECTORY_ICON
		if node.loaded and not node:has_children() then
			icon.text = not node.empty_expanded and config.folder_empty or config.folder_empty_open
		elseif node:is_expanded() then
			icon.text = config.folder_open or "-"
		else
			icon.text = config.folder_closed or "+"
		end
	elseif node.type == "file" then
		local override = { "out" }
		if not vim.tbl_contains(override, node.ext) then
			local success, web_devicons = pcall(require, "nvim-web-devicons")
			if success then
				local devicon, hl = web_devicons.get_icon(node.name, node.ext or "")
				icon.text = devicon
				icon.highlight = hl
			end
		end
		if not icon.ext then
			if vim.uv.fs_access(node.path, "X") then
				icon.text = ""
				icon.highlight = "DevIconOut"
			end
		end
	end

	local filtered_by = M.filtered_by(config, node, state)

	icon.text = (icon.text or "") .. " " -- add padding
	icon.highlight = filtered_by.highlight or icon.highlight or highlights.FILE_ICON --  prioritize filtered highlighting

	return icon
end

return M
