return {
  {
    "OXY2DEV/markview.nvim",
    branch = "dev",
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      vim.cmd([[
      hi MarkviewHeading1 guifg=#FF5D62
      hi MarkviewHeading2 guifg=#FFA066
      hi MarkviewHeading3 guifg=#E6C384
      hi MarkviewHeading4 guifg=#98BB6C
      hi MarkviewHeading5 guifg=#7FB4CA
      hi MarkviewHeading6 guifg=#b8b4d0

      hi MarkviewBlockQuoteDefault guifg=#7E9CD8
      hi MarkviewBlockQuoteError   guifg=#E82424
      hi MarkviewBlockQuoteNote    guifg=#6A9589
      hi MarkviewBlockQuoteOk      guifg=#98BB6C
      hi MarkviewBlockQuoteSpecial guifg=#957FB8
      hi MarkviewBlockQuoteWarn    guifg=#FF9E3B

      hi MarkviewCheckboxChecked   guifg=#98BB6C
      hi MarkviewCheckboxUnchecked guifg=#727169
      ]])
      local presets = require("markview.presets")

      require("markview").setup({
        markdown = {
          headings = presets.headings.glow,
          list_items = {
            shift_width = function(buffer, item)
              local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth)
              return item.indent * (1 / (parent_indnet * 2))
            end,
            marker_minus = {
              add_padding = function(_, item) return item.indent > 1 end,
            },
          },
        },
        markdown_inline = {
          checkboxes = {
            checked = { text = "󰄲", hl = "MarkviewCheckboxChecked", scope_hl = "MarkviewCheckboxChecked" },
            unchecked = { text = "", hl = "MarkviewCheckboxUnchecked", scope_hl = "MarkviewCheckboxUnchecked" },
          },
        },
        preview = {
          icon_provider = "devicons",
        },
      })
    end,
  },
  {
    "bullets-vim/bullets.vim",
    ft = "markdown",
  },
}
