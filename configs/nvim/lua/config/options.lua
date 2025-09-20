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
opt.foldlevel      = 99
opt.foldlevelstart = 99
opt.foldmethod     = "indent"
opt.foldcolumn     = "0"
opt.foldlevelstart = 99
opt.conceallevel   = 2
opt.concealcursor  = ""

-- lines & statuscolumn
opt.number         = true
opt.relativenumber = true
opt.signcolumn     = "yes"
opt.scrolloff      = 999
opt.sidescrolloff  = 10
opt.smoothscroll   = true
opt.cursorline     = true

-- line wrapping and auto-commenting
opt.wrap           = false
opt.breakindent    = true
opt.breakindentopt = { "min:30", "shift:-1" }
opt.linebreak      = true
opt.breakat        = " "
opt.formatoptions  = "c,o,/,q,n,2,j"

-- writing, undo & backup
opt.autowrite      = false
opt.swapfile       = false
opt.undofile       = true
opt.undolevels     = 1024
opt.confirm        = false
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- tabs & indentation
opt.tabstop        = 2
opt.shiftwidth     = 2
opt.expandtab      = false
opt.autoindent     = true
opt.shiftround     = true
opt.smarttab       = true

-- split windows
opt.splitkeep      = "screen"
opt.splitright     = true
opt.splitbelow     = true
opt.winminwidth    = 5
opt.winwidth       = 10
opt.equalalways    = false

-- popup windows
opt.timeout        = true
opt.timeoutlen     = 500
opt.pumblend       = 20
opt.pumheight      = 10
opt.updatetime     = 250
opt.completeopt    = "menu,menuone,noselect"

-- statusline
opt.laststatus     = 3
opt.showmode       = false
opt.ruler          = false
opt.cmdheight      = 0

-- mouse
opt.mouse          = "nvi"

-- search settings
opt.gdefault       = true
opt.ignorecase     = true
opt.smartcase      = true

-- colors
opt.termguicolors  = true
opt.background     = "dark"

-- cursor
opt.guicursor      = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:Cursor/lCursor"

-- backspace
opt.backspace      = "indent,eol,start"

-- command-line completion
opt.wildmode       = "longest:full,full"

-- prompts
opt.shortmess      = "tToOcCFI"

-- bell
opt.belloff        = "all"

-- spellcheck
opt.spelllang      = "en_us,fr"
