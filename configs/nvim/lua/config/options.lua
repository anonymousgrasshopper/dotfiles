---------------------------------------------------------------------------------------------------
--------------------------------------------- OPTIONS  --------------------------------------------
---------------------------------------------------------------------------------------------------

local opt = vim.opt

opt.fillchars = {
  foldopen  = "",
  foldclose = "",
  fold      = "•",
  foldsep   = " ",
  diff      = "╱",
  eob       = " ",
  lastline  = " ",
}

-- folding
opt.foldlevel      = 99     -- only close folds with at least 100 lines
opt.foldlevelstart = 99     -- no folds closed upon entering buffer
opt.foldmethod     = "indent"
opt.foldcolumn     = "0"    --size of column for folding indications
opt.foldlevelstart = 99
opt.conceallevel   = 2      -- replace concealed text by predefined fillchars
opt.concealcursor  = "nc"   -- modes in which the cursor line is concealed

-- lines & statuscolumn
opt.number         = true   -- shows absolute line number in the cursorcolumn
opt.relativenumber = true   -- shows relative line number in the cursorcolumn
opt.signcolumn     = "yes"  -- show sign column so that text doesn't shift
opt.scrolloff      = 5      -- have at least this number of lines above and below your cursor when possible
opt.sidescrolloff  = 10     -- have at least this number of columns around your cursor when possible
opt.smoothscroll   = true   -- smooth scroll with wraped lines
opt.cursorline     = true   -- highlight the current line

-- line wrapping and auto-commenting
opt.wrap           = false  -- enable/disable line wrapping
opt.breakindent    = true   --
opt.breakindentopt = { "min:30", "shift:-1" }
opt.linebreak      = true   --
opt.breakat        = " "    --
opt.formatoptions  = "jcqlnt2"
vim.cmd([[autocmd BufEnter * set formatoptions=jcqlnt2]])

-- writing, undo & backup
opt.autowrite      = false  -- enable/disable autowrite
opt.swapfile       = false  -- disable swapfiles
opt.undofile       = true   -- save undofiles
opt.undolevels     = 1024   -- number of inverted operations that can be done per file
opt.confirm        = false  -- when quitting with unsaved changes, open dialog instead of asking to override
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- tabs & indentation
opt.tabstop        = 2      -- 2 spaces for tabs
opt.shiftwidth     = 2      -- 2 spaces for indent width
opt.expandtab      = false  -- expand tab to spaces
opt.autoindent     = true   -- copy indent from current line when starting new one
opt.shiftround     = true   -- round indentation
opt.smarttab       = true   -- use tabs for indenting and spaces for aligning

-- split windows
opt.splitkeep      = "screen"
opt.splitright     = true   -- split vertical window to the right
opt.splitbelow     = true   -- split horizontal window to the bottom
opt.winminwidth    = 5      -- minimum window width
opt.winwidth       = 10
opt.equalalways    = false

-- popup windows
opt.timeout        = true -- enable timeout for mapped sequences to complete
opt.timeoutlen     = 500  -- time in milliseconds to wait for a mapped sequence to complete
opt.pumblend       = 20   -- transparency of the window
opt.pumheight      = 10   -- Maximum number of entries in a popup
opt.updatetime     = 250  -- delay for LSP pop-up windows to appear
opt.completeopt    = "menu,menuone,noselect"

-- statusline
opt.laststatus     = 3
opt.showmode       = false
opt.ruler          = false
opt.cmdheight      = 0

-- mouse
opt.mouse          = "nvi"  -- disable the mouse in command mode

-- search settings
opt.gdefault       = true   -- substitute globally (in the whole line) by default
opt.ignorecase     = true   -- ignore case when searching
opt.smartcase      = true   -- override ignorecase if mixed cases are used

-- colors
opt.termguicolors  = true   -- requires a true colors terminal emulator
opt.background     = "dark" -- colorschemes that can be light or dark will be made dark

-- cursor
opt.guicursor      = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:Cursor/lCursor"

-- backspace
opt.backspace      = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- command-line completion
opt.wildmode       = "longest:full,full"

-- prompts
opt.shortmess      = "tToOcCFI"

-- bell
opt.belloff        = "all"    -- disable all bell sounds from Neovim

-- spellcheck
opt.spelllang      = "en_us,fr"
