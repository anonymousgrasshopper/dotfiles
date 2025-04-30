---------------------------------------------------------------------------------------------------
--------------------------------------------- KEYMAPS  --------------------------------------------
---------------------------------------------------------------------------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- buffers
vim.keymap.set("n", "<S-h>", "<Cmd>bprevious<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<S-l>", "<Cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<Cmd>bprevious<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "]b", "<Cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<Cmd>e #<CR>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bd", "<Cmd>:bd<CR>", { desc = "Delete Buffer and Window" })

-- tabs
vim.keymap.set("n", "<leader>tt", "<Cmd>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>td", "<Cmd>tabclose<CR>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader>tx", "<Cmd>tabonly<CR>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader>tn", "<Cmd>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader>tp", "<Cmd>tabprevious<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader>tf", "<Cmd>tabfirst<CR>", { desc = "First Tab" })
vim.keymap.set("n", "<leader>tl", "<Cmd>tablast<CR>", { desc = "Last Tab" })

-- windows
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })

-- Terminal Mappings
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-h>", "<Cmd>wincmd h<CR>", { desc = "Go to Left Window" })
vim.keymap.set("t", "<C-j>", "<Cmd>wincmd j<CR>", { desc = "Go to Lower Window" })
vim.keymap.set("t", "<C-k>", "<Cmd>wincmd k<CR>", { desc = "Go to Upper Window" })
vim.keymap.set("t", "<C-l>", "<Cmd>wincmd l<CR>", { desc = "Go to Right Window" })
vim.keymap.set("t", "<C-/>", "<Cmd>close<CR>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<c-_>", "<Cmd>close<CR>", { desc = "which_key_ignore" })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- Move Lines
vim.keymap.set("n", "<M-j>", "<Cmd>m .+1<CR>==", { desc = "Move Down" })
vim.keymap.set("n", "<M-k>", "<Cmd>m .-2<CR>==", { desc = "Move Up" })
vim.keymap.set("i", "<M-j>", "<esc><Cmd>m .+1<CR>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<M-k>", "<esc><Cmd>m .-2<CR>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move Up" })

-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<Cmd>close<CR>", { desc = "Close current split" })

-- diagnostics
local diagnostic_jump = function(count, severity)
	local severity = severity and vim.diagnostic.severity[severity] or nil
	return function() vim.diagnostic.jump({ count = count, severity = severity }) end
end
vim.keymap.set("n", "<leader>sd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_jump(1), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_jump(-1), { desc = "Previous Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_jump(1, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_jump(-1, "ERROR"), { desc = "Previous Error" })
vim.keymap.set("n", "]w", diagnostic_jump(1, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_jump(-1, "WARN"), { desc = "Previous Warning" })

-- better up and down motions
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Automatically add undo breakpoints
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- yanking and pasting
vim.keymap.set("x", "<leader>r", '"_dP')
vim.keymap.set("n", "<leader>P", "i<C-R><C-P>+<ESC>", { desc = 'Paste "+ content before cursor' })
vim.keymap.set({ "n", "v" }, "<C-S-y>", "<Cmd>%y+<CR>", { desc = "Yank file text into the + register" })
vim.keymap.set("v", "<C-z>", '"+y', { desc = 'Yank selected text into "+' })
vim.keymap.set("n", "<leader>cwd", '<Cmd>let @+=expand("%")<CR>', { desc = 'Copy absolute path to the "+' })

-- indenting
vim.keymap.set({ "n", "v" }, "<leader>i", "gg=G<C-o>", { desc = "Indent file" })
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- command line keymaps
vim.keymap.set("c", "<M-a>", "<C-e>", { desc = "Go to end" })
vim.keymap.set("c", "<M-i>", "<C-b>", { desc = "Go to beginning" })

-- toggle options
vim.keymap.set("n", "<leader>os", "<Cmd>set spell!<CR>", { desc = "Toggle spell checking" })
vim.keymap.set("n", "<leader>ow", "<Cmd>set wrap!<CR>", { desc = "Toggle line wrapping" })
vim.keymap.set("n", "<leader>or", "<Cmd>set relativenumber!<CR>", { desc = "Toggle relative numbers" })
vim.keymap.set("n", "<leader>oa", "<Cmd>set autochdir!<CR>", { desc = "Sync cwd with buffer's" })
vim.keymap.set(
	"n",
	"<leader>od",
	function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
	{ desc = "Toggle diagnostics" }
)

-- search
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "<leader>nh", "<Cmd>nohl<CR>", { desc = "Clear search highlights" })

-- new file
vim.keymap.set("n", "<leader>fn", "<Cmd>enew<CR>", { desc = "New File" })

-- lazy
vim.keymap.set("n", "<leader>L", "<Cmd>Lazy<CR>", { desc = "Open Lazy.nvim ui" })

-- clean up copied LaTeX from AoPS
vim.api.nvim_create_user_command("Aops", ":s/![\\(\\$.\\{-}\\$\\).(.\\{-}png)/\\1/g", {})

-- Zen mode
vim.api.nvim_create_user_command("Zen", function()
	if vim.api.nvim_get_option_value("laststatus", {}) ~= 0 then
		vim.cmd([=[
      set laststatus=0
      set showtabline=0
      silent ![[ -n $TMUX ]] && tmux set -g status off
    ]=])
	else
		vim.cmd([=[
      set laststatus=3
      set showtabline=2
      silent ![[ -n $TMUX ]] && tmux set -g status on
    ]=])
	end
end, {})
