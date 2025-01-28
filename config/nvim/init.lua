require("config.autocmd")
require("config.keymaps")
require("config.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins.coding" },
    { import = "plugins.editor" },
    { import = "plugins.features" },
    { import = "plugins.ui" },
    { import = "plugins.util" },
  },
  change_detection = {
    notify = false,
  },
  install = {
    colorscheme = { "kanagawa-wave" },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "netrw",
        "netrwPlugin",
      },
    },
  },
})
