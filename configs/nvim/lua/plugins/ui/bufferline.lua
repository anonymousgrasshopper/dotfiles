return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    vim.keymap.set("n", "L", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "H", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Next buffer" })
    return {
      options = {
        sort_by = "insert_after_current",
        right_mouse_command = "vert sbuffer %d",
        middle_mouse_command = "horiz sbuffer %d",
        show_close_icon = true,
        move_wraps_at_ends = true,
        always_show_bufferline = false,
        separator_style = "thin",
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "PanelHeading",
            text_align = "center",
            separator = "",
          },
          {
            filetype = "undotree",
            text = "UNDOTREE",
            highlight = "PanelHeading",
            separator = "▐",
          },
        },
      },
      highlights = {
        offset_separator = {
          bg = "#111116",
          fg = "#2a2a37",
        },
        tab = {
          bg = "#1a1a22",
          fg = "#727169",
        },
        tab_selected = {
          bg = "#1f1f28",
          fg = "#dcd7ba",
        },
      },
    }
  end,
}
