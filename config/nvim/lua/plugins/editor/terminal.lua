vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    if vim.g.code_action_preview then
      vim.g.code_action_preview = false
      return
    end
    if vim.bo.filetype ~= "yazi" then
      vim.opt_local.number = false
      vim.opt_local.cursorline = false
      vim.opt_local.relativenumber = false
      vim.opt_local.winhighlight = "Normal:TerminalBackground"
      vim.cmd("startinsert")
    end
  end,
})

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = function()
    local Terminal = require("toggleterm.terminal").Terminal

    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      hidden = true,
      direction = "float",
      display_name = "LazyGit",
      close_on_exit = true,
      float_opts = {
        border = "rounded",
      },
    })

    local btop = Terminal:new({
      cmd = "btop",
      hidden = true,
      direction = "float",
      display_name = "Top",
      close_on_exit = true,
      float_opts = {
        border = "solid",
      },
      highlights = {
        NormalFloat = { guibg = "#16161D" },
        FloatBorder = { guibg = "#16161D" },
      },
    })

    vim.keymap.set("n", "<leader>lg", function() lazygit:toggle() end, {
      desc = "Toggle LazyGit",
      silent = true,
    })
    vim.api.nvim_create_user_command("Btop", function() btop:toggle() end, {})

    return {
      open_mapping = [[<c-\>]],
      shade_terminals = false,
      start_in_insert = true,
      autochdir = true,
      direction = "float",
      float_opts = {
        border = "rounded",
        winblend = 10,
        zindex = 5,
      },
      highlights = {
        Normal = { guibg = "#16161D" },
        FloatBorder = { guibg = "none", guifg = "#54546D" },
      },
    }
  end,
}
