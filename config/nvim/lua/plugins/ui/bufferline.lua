return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    vim.keymap.set("n", "L", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
    vim.keymap.set("n", "H", "<cmd>BufferLineCyclePrev<cr>", { desc = "Next buffer" })
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
          fg = "#2A2A37",
        },
        tab = {
          bg = "#1A1A22",
          fg = "#727169",
        },
        tab_selected = {
          bg = "#1F1F28",
          fg = "#DCD7BA",
        },
      },
    }
  end,
}
