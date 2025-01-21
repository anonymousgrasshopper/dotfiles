return {
  "akinsho/bufferline.nvim",
  event = "UiEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
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
          separator = "▐",
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
        bg = "#2A2A37",
        fg = "#111116",
      },
    }
  }
}
