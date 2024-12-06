-----------------------------------------------------------------
---------------------------- KEYMAPS ----------------------------
-----------------------------------------------------------------

vim.g.mapleader = " "

------ buffers ------
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bd", "delete buffer", { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

------ tabs ------
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

------ windows ------
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })

------ diagnostic ------
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
vim.keymap.set("n", "<leader>sd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

------ Terminal Mappings ------
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

------ Move to window using the <ctrl> hjkl keys ------
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

------ Resize window using <ctrl> arrow keys ------
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

------ Move Lines ------
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

------ search highlights ------
vim.keymap.set("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<leader>L", "<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / Clear hlsearch / Diff Update" })

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

------ indenting ------
vim.keymap.set({"n", "v"}, "<leader>i", "gg=G<C-o>", { desc = "Indent file" })
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

------ commenting ------
vim.keymap.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
vim.keymap.set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

------ yanking and pasting ------
vim.keymap.set("n", "<leader>P", "i<C-R><C-P>+<ESC>", { desc = "Paste text from \"+" })
vim.keymap.set("n", "<leader>p", "\"_p" )
vim.keymap.set( {"n", "v"}, "<C-a>", 'ggVG"+y', { desc = "Yank file text into \"+" } )
vim.keymap.set( "v", "<C-z>", '"+y', { desc = "Yank selected text into \"+" } )
vim.keymap.set("n", "<leader>cwd", '<cmd>let @+=expand("%")<CR>', { desc = "Copy absolute path to + register"})

------ increment/decrement numbers ------
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

------ lazy ------
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Open Lazy.nvim ui" })

------ new file ------
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

------ toggle options ------
vim.keymap.set("n", "<leader>wrap", "<cmd>set wrap!<CR>", { desc = "Toggle line wrapping" })
vim.keymap.set("n", "<leader>chdir", "<cmd>set autochdir!<CR>", { desc = "Sync cwd with buffer's" })

------ inspect ------
vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Position" })
vim.keymap.set("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

------ improved up and downn motions ------
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

------ Add undo break-points ------
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

------ keywordprg ------
vim.keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

------ go to nvim config directory ------
vim.keymap.set("n", "<leader>cdrc", "<cmd>cd ~/.config/nvim<Cr><cmd>Neotree reveal<Cr>E")

------ clean up copied LaTeX from AoPS ------
vim.api.nvim_create_user_command("Aops", ":s/![\\(\\$.\\{-}\\$\\).(.\\{-}png)/\\1/g", {})

-----------------------------------------------------------------
-------------------- COMPETITIVE PROGRAMMING --------------------
-----------------------------------------------------------------


------ compile C++ code ------
local escape_spaces = function (path)
  local skip_next = false
  local nb_added_chars = 0
  for i = 1,path:len() do
    if not skip_next then
      if path:sub(i,i) == ' ' then
        path = path:sub(1,i-1) .. "\\" .. path:sub(i,path:len()+nb_added_chars)
        skip_next = true
        nb_added_chars = nb_added_chars +1
      end
    else
      skip_next = false
    end
  end
  return path
end
vim.keymap.set("n", "<leader>dbg", function()
  return ":!clang++ --debug " .. escape_spaces(vim.fn.expand("%")) .. " -o " .. escape_spaces(vim.fn.fnamemodify(vim.fn.expand("%"), ":r")) .. ".exe<CR>"
end, { expr = true })

------ competitive programming templates ------
-- vim.keymap.set("n","<leader>template", "i#pragma GCC optimize(\"O3,unroll-loops\")\n#pragma GCC target(\"avx2,bmi,bmi2,lzcnt,popcnt\")\n\n#include <bits/stdc++.h>\nusing namespace std;\n#define REP(i,a,b) for(int i=0;i<a;i+=b)\n#define dbg(x) cerr<<#x<<\" = \"<<x<<'\\n'\n#define dbgarray(x) cerr<<#x<<\" :\\n=======\\n\";for(auto y:x)cerr<<y<<\" \";\n#define all(x) x.begin(), x.end()\n#define rall(x) x.rbegin(), x.rend()\n#define f      first        //    .\n#define s      second       //   .'.\n#define nint   new int      //   |o|\n#define nchar  new char     //  .'o'.\n#define bltn __builtin      //  |.-.|\n#define pb     push_back    //  ' ; '\nusing ll    =  long long          ;\nusing vi    =  vector<int>        ;\nusing uint  =  unsigned int       ;\nusing vc    =  vector<char>       ;\nusing vii   =  vector<int,int>    ;\nusing vvi   =  vector<vector<int>>;\n\n///////////////////////////////////\n\n\nint main() {\n \bios::sync_with_stdio(false); cin.tie(nullptr);\n}<Esc>ki\t<Esc>o", { desc = "Insert CP template" })
-- vim.keymap.set("n","<leader>codeforces", "i#pragma GCC optimize(\"O3,unroll-loops\")\n#pragma GCC target(\"avx2,bmi,bmi2,lzcnt,popcnt\")\n\n#include <bits/stdc++.h>\nusing namespace std;\n#define REP(i,a,b) for(int i=0;i<a;i+=b)\n#define dbg(x) cerr<<#x<<\" = \"<<x<<'\\n'\n#define dbgarray(x) cerr<<#x<<\" :\\n=======\\n\";for(auto y:x)cerr<<y<<\" \";\n#define all(x) x.begin(), x.end()\n#define rall(x) x.rbegin(), x.rend()\n#define f      first        //    .\n#define s      second       //   .'.\n#define nint   new int      //   |o|\n#define nchar  new char     //  .'o'.\n#define bltn __builtin      //  |.-.|\n#define pb     push_back    //  ' ; '\nusing ll    =  long long          ;\nusing vi    =  vector<int>        ;\nusing uint  =  unsigned int       ;\nusing vc    =  vector<char>       ;\nusing vii   =  vector<int,int>    ;\nusing vvi   =  vector<vector<int>>;\n\n///////////////////////////////////\n\nvoid solve() {\n \bint n; cin >> n;\n\n\b}\n\n///////////////////////////////////\n\nint main(){\n \bios::sync_with_stdio(false); cin.tie(nullptr);\n<tab>int nbTests; cin >> nbTests;\n<tab>while (nbTests--) {\n<tab><tab>solve();\n}\n}<esc>10kO", { desc = "Insert Codeforces template" })
vim.keymap.set("n","<leader>template", "i#pragma GCC optimize(\"O3,unroll-loops\")\n#include <bits/stdc++.h>\nusing namespace std;\n#define REP(i,a,b) for(int i=0;i<a;i+=b)\n#define all(x) x.begin(), x.end()\n#define rall(x) x.rbegin(), x.rend()\n#define f      first        //    .\n#define s      second       //   .'.\n#define nint   new int      //   |o|\n#define nchar  new char     //  .'o'.\n#define bltn __builtin      //  |.-.|\n#define pb     push_back    //  ' ; '\nusing ll    =  long long          ;\nusing vi    =  vector<int>        ;\nusing uint  =  unsigned int       ;\nusing vc    =  vector<char>       ;\nusing vii   =  vector<int,int>    ;\nusing vvi   =  vector<vector<int>>;\n#ifdef LOCAL\n#include \"dbg.h\"\n#else\n#define n(...) 42\n#define id(...) 42\n#define dbg(...) 42\n#define line(...) 42\n#define dbgarr(...) 42\n#define dbg_var(...) 42\n#endif\n\n///////////////////////////////////\n\n\n///////////////////////////////////\n\n\nint main() {<Esc>oios::sync_with_stdio(false); cin.tie(nullptr);\n}<Esc>ki\t<Esc>o", { desc = "Insert Codeforces template" })
vim.keymap.set("n","<leader>codeforces", "i#pragma GCC optimize(\"O3,unroll-loops\")\n#include <bits/stdc++.h>\nusing namespace std;\n#define REP(i,a,b) for(int i=0;i<a;i+=b)\n#define all(x) x.begin(), x.end()\n#define rall(x) x.rbegin(), x.rend()\n#define f      first        //    .\n#define s      second       //   .'.\n#define nint   new int      //   |o|\n#define nchar  new char     //  .'o'.\n#define bltn __builtin      //  |.-.|\n#define pb     push_back    //  ' ; '\nusing ll    =  long long          ;\nusing vi    =  vector<int>        ;\nusing uint  =  unsigned int       ;\nusing vc    =  vector<char>       ;\nusing vii   =  vector<int,int>    ;\nusing vvi   =  vector<vector<int>>;\n#ifdef LOCAL\n#include \"dbg.h\"\n#else\n#define n(...) 42\n#define id(...) 42\n#define dbg(...) 42\n#define line(...) 42\n#define dbgarr(...) 42\n#define dbg_var(...) 42\n#endif\n\n///////////////////////////////////\n\nvoid solve() {\n}\n\n///////////////////////////////////\n\nint main() {\n \bios::sync_with_stdio(false); cin.tie(nullptr);\n  int nbTests; cin >> nbTests;\n  while(nbTests--){\n    solve();\n}\n}<Esc>10kO", { desc = "Insert Codeforces template" })
vim.keymap.set("n", "<leader>setio", 'Ovoid setIO(string name = "") {\n \bif (sz(name)) {\n    freopen((name+".in").c_str(), "r", stdin);\n    freopen((name+".out").c_str(), "w", stdout);\n  }\n}\n', { desc = "Add io function for USACO" })

------ shortcuts ------
vim.keymap.set("n", "<leader>array", "0iint n; cin >> n;\nint* array = new int [n];\nREP(i,0,n) cin >> array[i];\n")
