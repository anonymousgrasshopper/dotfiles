return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    ignore = "^$",
    pre_hook = function(ctx)
      if vim.bo.filetype == "asm" then return "; %s" end
    end,
  },
}
