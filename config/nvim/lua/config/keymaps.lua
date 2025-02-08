-----------------------------------------------------------------
---------------------------- KEYMAPS ----------------------------
-----------------------------------------------------------------

vim.g.mapleader = " "

------ buffers ------
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>:bd<CR>", { desc = "Delete Buffer and Window" })

------ tabs ------
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<CR>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<CR>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<CR>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<CR>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<CR>", { desc = "Previous Tab" })

------ windows ------
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })

------ Terminal Mappings ------
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<CR>", { desc = "Go to Left Window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<CR>", { desc = "Go to Lower Window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<CR>", { desc = "Go to Upper Window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<CR>", { desc = "Go to Right Window" })
vim.keymap.set("t", "<C-/>", "<cmd>close<CR>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<c-_>", "<cmd>close<CR>", { desc = "which_key_ignore" })

------ Move to window using the <ctrl> hjkl keys ------
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

------ Resize window using <ctrl> arrow keys ------
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase Window Width" })

------ Move Lines ------
vim.keymap.set("n", "<M-j>", "<cmd>m .+1<CR>==", { desc = "Move Down" })
vim.keymap.set("n", "<M-k>", "<cmd>m .-2<CR>==", { desc = "Move Up" })
vim.keymap.set("i", "<M-j>", "<esc><cmd>m .+1<CR>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<M-k>", "<esc><cmd>m .-2<CR>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move Up" })

------ window management ------
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

vim.keymap.set("n", "<leader>to", "<cmd>to<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>txlose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>ta<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tp<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<leader>tb", "<cmd>tb<CR>", { desc = "Open current buffer in new tab" })

------ diagnostics ------
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function() go({ severity = severity }) end
end
vim.keymap.set("n", "<leader>sd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Previous Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Previous Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Previous Warning" })

------- better up and down motions ------
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

------ Add undo break-points ------
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

------ yanking and pasting ------
vim.keymap.set("n", "<leader>P", "i<C-R><C-P>+<ESC>", { desc = "Paste text from + register before cursor" })
vim.keymap.set({ "n", "v" }, "<C-a>", 'ggVG"+y<C-o>', { desc = "Yank file text into the + register" })
vim.keymap.set("v", "<C-z>", '"+y', { desc = 'Yank selected text into "+' })
vim.keymap.set("n", "<leader>cwd", '<cmd>let @+=expand("%")<CR>', { desc = "Copy absolute path to the + register" })

----- indenting ------
vim.keymap.set({ "n", "v" }, "<leader>i", "gg=G<C-o>", { desc = "Indent file" })
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

------ toggle options ------
vim.keymap.set("n", "<leader>os", "<cmd>set spell!<CR>", { desc = "Toggle spell checking" })
vim.keymap.set("n", "<leader>ow", "<cmd>set wrap!<CR>", { desc = "Toggle line wrapping" })
vim.keymap.set("n", "<leader>or", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative numbers" })
vim.keymap.set("n", "<leader>od", "<cmd>set autochdir!<CR>", { desc = "Sync cwd with buffer's" })

------ clear search highlights ------
vim.keymap.set("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Clear search highlights" })

------ increment/decrement numbers ------
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

------ lazy ------
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Open Lazy.nvim ui" })

------ new file ------
vim.keymap.set("n", "<leader>fn", "<cmd>enew<CR>", { desc = "New File" })

------ Treesitter ------
vim.keymap.set("n", "<leader>uI", "<cmd>InspectTree<CR>", { desc = "Inspect Tree" })
vim.api.nvim_create_user_command(
  "GetNode",
  "lua print(vim.treesitter.get_node({ pos = { vim.api.nvim_win_get_cursor(0)[1] - 1, vim.api.nvim_win_get_cursor(0)[2] - 1 }}):type())",
  {}
)

------ go to nvim config directory ------
vim.keymap.set("n", "<leader>cdrc", "<cmd>cd ~/.config/nvim<CR><cmd>Neotree<CR>")

------ clean up copied LaTeX from AoPS ------
vim.api.nvim_create_user_command("Aops", ":s/![\\(\\$.\\{-}\\$\\).(.\\{-}png)/\\1/g", {})

------ Compile and run SFML programs ------
vim.api.nvim_create_autocmd("Filetype", {
  pattern = {
    "cpp",
  },
  callback = function()
    vim.schedule(function()
      vim.keymap.set(
        "n",
        "<leader>sf",
        function() return "<cmd>!compile_sfml " .. vim.fn.fnamemodify(vim.fn.expand("%"), ":p:r") .. " &<CR><CR>" end,
        { expr = true, buffer = true }
      )
    end)
  end,
})

------ Zen mode ------
vim.api.nvim_create_user_command("Zen", function()
  if vim.api.nvim_get_option_value("laststatus", {}) ~= 0 then
    vim.cmd([[
        set laststatus=0
        set showtabline=0
      ]])
  else
    vim.cmd([[
        set laststatus=3
        set showtabline=2
      ]])
  end
end, {})
