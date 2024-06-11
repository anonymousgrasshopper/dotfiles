-----------------------------------------------------------------
---------------------------- OPTIONS ----------------------------
-----------------------------------------------------------------

-- lines and line numbers
--vim.opt.relativenumber = true -- show relative line numbers
vim.opt.number     = true -- shows absolute line number on cursor line (when relative number is on)
vim.opt.scrolloff  = 6 --always have >= 8 lines above and beneath your cursor

-- tabs & indentation
vim.opt.tabstop    = 2 -- 2 spaces for tabs
vim.opt.shiftwidth = 2 -- 2 spaces for indent width
vim.opt.expandtab  = true -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping and auto-commenting
vim.opt.wrap       = false -- disable line wrapping
vim.cmd([[autocmd BufEnter * set formatoptions-=r]])

-- search settings
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase  = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
vim.opt.cursorline = true -- highlight the current cursor line

-- mouse
vim.cmd.aunmenu({ "PopUp.How-to\\ disable\\ mouse" })
vim.cmd.aunmenu({ "PopUp.-1-" })

-- turn on termguicolors (true color terminal necessary)
vim.opt.termguicolors = true
vim.opt.background = "dark" -- colorschemes that can be light or dark will be made dark
vim.opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
vim.opt.backspace  = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
vim.opt.swapfile   = false

-- statusline
vim.opt.showmode   = false
vim.opt.ruler      = false
