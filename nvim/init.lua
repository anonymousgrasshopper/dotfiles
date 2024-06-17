require("Antoine.core.options")
require("Antoine.core.keymaps")

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

require("lazy").setup( --default plugin priority is 50
  {
	  { import = "Antoine.plugins.util" },
	  { import = "Antoine.plugins" },
  },
  {
	  change_detection = {
		notify = false,
	  },
  }
)

require("Antoine.core.lsp")
