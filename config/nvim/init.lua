require("config.autocmds")
require("config.filetypes")
require("config.keymaps")
require("config.options")

-- download lazy.nvim if it isn't here yet
local lazypath = vim.fn.stdpath("data") .. "/packages/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  root = vim.fn.stdpath("data") .. "/packages",
  lockfile = vim.fn.stdpath("config") .. "/lockfile.json",
  readme = { root = vim.fn.stdpath("state") .. "docs/readme" },
  spec = {
    { import = "plugins.coding" },
    { import = "plugins.editor" },
    { import = "plugins.features" },
    { import = "plugins.lang" },
    { import = "plugins.ui" },
    { import = "plugins.util" },
  },
  install = {
    missing = true,
    colorscheme = { "kanagawa-wave" },
  },
  diff = {
    cmd = "diffview.nvim",
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
