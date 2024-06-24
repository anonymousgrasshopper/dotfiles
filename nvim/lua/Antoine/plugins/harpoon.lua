return {
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  priority = 90,
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },

  config = function()
    local harpoon = require("harpoon")
    harpoon.setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        key = function()
          return vim.loop.cwd()
        end,
      },
    })
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end
    -- keymaps
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Add file to Harpoon"})
    vim.keymap.set("n", "<A-h>", function() toggle_telescope(harpoon:list()) end, {desc = "Toggle Harpoon ui"})

    vim.keymap.set("n", "<A-p>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<A-m>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<A-l>", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<A-o>", function() harpoon:list():select(4) end)
  end,
}
