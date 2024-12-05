return {
  "akinsho/bufferline.nvim",
  event = "UiEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      mode = "tabs",
      separator_style = "slope",
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      offsets = {
        {
          filetype = "neo-tree",
          raw = " %{%v:lua.__get_selector()%} ",
          text = "File Explorer",
          highlight = "Directory",
          text_align = "center",
          separator = "│",
        },
      },
    },
  },
}
