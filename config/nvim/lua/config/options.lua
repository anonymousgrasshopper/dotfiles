---------------------------------------------------------------------------------------------------
--------------------------------------------- OPTIONS  --------------------------------------------
---------------------------------------------------------------------------------------------------

vim.opt.fillchars = {
  foldopen  = "",
  foldclose = "",
  fold      = "•",
  foldsep   = " ",
  diff      = "╱",
  eob       = " ",
  lastline  = " ",
}

-- folding
vim.opt.foldlevel      = 99     -- only close folds with at least 100 lines
vim.opt.foldlevelstart = 99     -- no folds closed upon entering buffer
vim.opt.foldmethod     = "manual" -- use treesitter to determine the level of each line
-- vim.opt.foldexpr       = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn     = "0"    --size of column for folding indications
vim.opt.foldlevelstart = 99
vim.opt.conceallevel   = 2      -- replace concealed text by predefined fillchars

-- lines & statuscolumn
vim.opt.number         = true   -- shows absolute line number in the cursorcolumn
vim.opt.relativenumber = true   -- shows relative line number in the cursorcolumn
vim.opt.signcolumn     = "yes"  -- show sign column so that text doesn't shift
vim.opt.scrolloff      = 5      -- have at least this number of lines above and below your cursor when possible
vim.opt.sidescrolloff  = 10     -- have at least this number of columns around your cursor when possible
vim.opt.smoothscroll   = true   -- smooth scroll with wraped lines
vim.opt.cursorline     = true   -- highlight the current line
-- vim.opt.statuscolumn   = "%@SignCb@%s%=%T%@NumCb@%l│%T"

-- line wrapping and auto-commenting
vim.opt.wrap           = false  -- enable/disable line wrapping
vim.opt.breakindent    = true   --
vim.opt.breakindentopt = { "min:30", "shift:-1" }
vim.opt.linebreak      = true   --
vim.opt.breakat        = " "    --
vim.cmd([[autocmd BufEnter * set formatoptions=jcqlnt2]])

-- writing, undo & backup
vim.opt.autowrite      = false  -- enable/disable autowrite
vim.opt.swapfile       = false  -- disable swapfiles
vim.opt.undofile       = true   -- save undofiles
vim.opt.undolevels     = 1024   -- number of inverted operations that can be done per file
vim.opt.confirm        = false  -- when quitting with unsaved changes, open dialog instead of asking to override
vim.o.sessionoptions   = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- tabs & indentation
vim.opt.tabstop        = 2      -- 2 spaces for tabs
vim.opt.shiftwidth     = 2      -- 2 spaces for indent width
vim.opt.expandtab      = true   -- expand tab to spaces
vim.opt.autoindent     = true   -- copy indent from current line when starting new one
vim.opt.shiftround     = true   -- round indentation

-- split windows
vim.opt.splitkeep      = "screen"
vim.opt.splitright     = true   -- split vertical window to the right
vim.opt.splitbelow     = true   -- split horizontal window to the bottom
vim.opt.winminwidth    = 5      -- minimum window width
vim.o.winwidth         = 10
vim.o.equalalways      = false

-- popup windows
vim.o.timeout          = true -- enable timeout for mapped sequences to complete 
vim.o.timeoutlen       = 500  -- time in milliseconds to wait for a mapped sequence to complete 
vim.opt.pumblend       = 20   -- transparency of the window
vim.opt.pumheight      = 10   -- Maximum number of entries in a popup
vim.opt.updatetime     = 250  -- delay for LSP pop-up windows to appear
vim.opt.completeopt    = "menu,menuone,noselect"

-- statusline
vim.opt.laststatus     = 3
vim.opt.showmode       = false
vim.opt.ruler          = false
vim.opt.cmdheight      = 0

-- mouse
vim.opt.mouse          = "nvi"  -- disable mouse for command mode
vim.cmd.aunmenu({ "PopUp.How-to\\ disable\\ mouse" })
vim.cmd.aunmenu({ "PopUp.-2-" })

-- search settings
vim.opt.smartcase      = true   -- if mixed cases are used, then the search is case-sensitive

-- colors
vim.opt.termguicolors  = true   -- requires a true colors terminal emulator
vim.opt.background     = "dark" -- colorschemes that can be light or dark will be made dark

-- cursor
vim.opt.guicursor      = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:Cursor/lCursor"

-- backspace
vim.opt.backspace      = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- command-line completion
vim.opt.wildmode = "longest:full,full"

-- prompts
vim.opt.shortmess      = "tToOcCFI"

-- bell
vim.opt.belloff        = "all"    -- disable all bell sounds from Neovim

-- spellcheck
vim.opt.spelllang      = "en_us,fr"
