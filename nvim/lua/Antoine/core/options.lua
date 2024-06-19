-----------------------------------------------------------------
---------------------------- OPTIONS ----------------------------
-----------------------------------------------------------------

------ folding ------
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.opt.foldlevel      = 99     -- only close folds with at least 100 lines
vim.opt.foldlevelstart = 99     -- no folds closed upon entering buffer
vim.opt.foldmethod     = "expr" -- use treesitter to determine the level of each line
vim.opt.foldexpr       ="v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext       = ""
vim.opt.foldcolumn     = "0"    --size of column for folding indications
vim.opt.conceallevel   = 2      -- replace concealed text by predefined fillchars

------ lines & statuscolumn ------
vim.opt.statuscolumn   = "%s%C%l"
vim.opt.number         = true   -- shows absolute line number on cursor line
vim.opt.signcolumn     = "yes"  -- show sign column so that text doesn't shift
vim.opt.sidescrolloff  = 4      -- always have >= 4 lines above and below your cursor (excepted at <bof> and <eof>)
vim.opt.smoothscroll   = true   -- smooth scroll with wraped lines
vim.opt.cursorline     = true   -- highlight the current cursor line

------ line wrapping and auto-commenting ------
vim.opt.wrap           = false  -- enable/disable line wrapping
vim.opt.breakindent    = true   -- 
vim.opt.breakindentopt = { "min:30", "shift:-1" }
vim.opt.linebreak      = true   --
vim.opt.breakat        = " "    --
vim.cmd([[autocmd BufEnter * set formatoptions=jcoqlnt2]])

------ writing, undo & backup ------
vim.opt.autowrite      = false  -- enable/disable autowrite
vim.opt.swapfile       = false  -- disable swapfiles
vim.opt.undofile       = true   -- save undofiles
vim.opt.undolevels     = 1024   -- number of inverted operations that can be done per file
vim.opt.confirm        = true   -- when quitting with unsaved changes, open dialog instead of asking to override

------ tabs & indentation ------
vim.opt.tabstop        = 2      -- 2 spaces for tabs
vim.opt.shiftwidth     = 2      -- 2 spaces for indent width
vim.opt.expandtab      = true   -- expand tab to spaces
vim.opt.autoindent     = true   -- copy indent from current line when starting new one
vim.opt.shiftround     = true   -- round indentation

------ split windows ------
vim.opt.splitkeep      = "screen"
vim.opt.splitright     = true   -- split vertical window to the right
vim.opt.splitbelow     = true   -- split horizontal window to the bottom
vim.opt.winminwidth    = 5      -- minimum window width

------popup windows ------
vim.opt.pumblend       = 20   -- transparency of the window
vim.opt.pumheight      = 10   -- Maximum number of entries in a popup
vim.opt.updatetime     = 250  -- delay for LSP pop-up windows to appear
vim.opt.completeopt    = "menu,menuone,noselect"
vim.cmd([[autocmd WinScrolled * hi PmenuSel blend=5]]) -- doesn't work

------ statusline ------
vim.opt.laststatus     = 3      -- since we have a statusline,
vim.opt.showmode       = false  -- we want to disable the
vim.opt.ruler          = false  -- default one

------ mouse ------
vim.opt.mouse          = "nvi"  -- disable mouse for command mode
vim.cmd.aunmenu({ "PopUp.How-to\\ disable\\ mouse" })
vim.cmd.aunmenu({ "PopUp.-1-" })

------ search settings ------
vim.opt.ignorecase     = true   -- ignore case when searching
vim.opt.smartcase      = true   -- if mixed cases are used, then the search is case-sensitive

------ colors ------
vim.opt.termguicolors  = true   -- requires a true colors terminal
vim.opt.background     = "dark" -- colorschemes that can be light or dark will be made dark

------ backspace ------
vim.opt.backspace      = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

------ change cwd ------
--vim.opt.autochdir      = true   -- sync cwd directory with buffer's

------ command-line completion ------
vim.opt.wildmode = "longest:full,full"

------ prompts ------
vim.opt.shortmess      = "tToOcCFI"
