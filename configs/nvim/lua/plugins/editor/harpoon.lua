local function toggle_telescope(harpoon_files)
	local conf = require("telescope.config").values
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	-- dependencies:
	-- 	nvim-lua/plenary.nvim
	keys = {
		{
			"<M-a>",
			function() require("harpoon"):list():add() end,
			desc = "Add file to Harpoon",
		},
		{
			"<M-h>",
			function() toggle_telescope(require("harpoon"):list()) end,
			desc = "Toggle Harpoon ui",
		},

		{
			"<M-p>",
			function() require("harpoon"):list():select(1) end,
		},
		{
			"<M-m>",
			function() require("harpoon"):list():select(2) end,
		},
		{
			"<M-l>",
			function() require("harpoon"):list():select(3) end,
		},
		{
			"<M-o>",
			function() require("harpoon"):list():select(4) end,
		},
	},
	opts = {
		settings = {
			save_on_toggle = true,
			sync_on_ui_close = true,
			key = function() return vim.uv.cwd() end,
		},
	},
}
