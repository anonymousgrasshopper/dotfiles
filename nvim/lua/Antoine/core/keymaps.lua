-----------------------------------------------------------------
---------------------------- KEYMAPS ----------------------------
-----------------------------------------------------------------

vim.g.mapleader = " "

-- clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- copying/pasting
vim.keymap.set("n", "<leader> p", "i<C-R><C-P>+<ESC>", { desc = "copy text from \"+\"" })

-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

vim.keymap.set("n", "<leader>to", "<cmd>to<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>txlose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>ta<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tp<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<leader>tb", "<cmd>tb<CR>", { desc = "Open current buffer in new tab" })

-- competitive programming
vim.keymap.set("n", "<F3>", ":w <CR> :!g++ -fsanitize=address -std=c++17 -Wall -Wextra -Wshadow -DONPC -O2 -o %< % <CR>", { desc = "save file and compile" })

-- competitive programming templates
vim.keymap.set("n","<leader>template", "i#include <bits/stdc++.h>\nusing namespace std;\n#define ANSWER cout<<(ans?\"OUI\":\"NON\")<<'\\n'\n#define dbg(x) cerr<<#x<<\" = \"<<x<<'\\n'\n#define f      first	    	//    .\n#define s      second	    	//   .'.\n#define nint   new int  		//   |o|\n#define nchar  new char	  	//  .'o'.\n#define bltn __builtin	   	//  |.-.|\n#define pb     push_back	  //  ' ; '\nusing ll    =  long long          ;\nusing vi    =  vector<int>        ;\nusing uint  =  unsigned int       ;\nusing vc    =  vector<char>       ;\nusing vii   =  vector<int,int>    ;\nusing vvi   =  vector<vector<int>>;\n\n///////////////////////////////////\n\n\nint main() {\n \bios::sync_with_stdio(false); cin.tie(nullptr);\n\n}", { desc = "Insert CP template" })
vim.keymap.set("n","<leader>codeforces", "i#include <bits/stdc++.h>\nusing namespace std;\n#define ANSWER cout<<(ans?\"OUI\":\"NON\")<<'\\n'\n#define dbg(x) cerr<<#x<<\" = \"<<x<<'\\n'\n#define f      first	    	//    .\n#define s      second	    	//   .'.\n#define nint   new int  		//   |o|\n#define nchar  new char	  	//  .'o'.\n#define bltn __builtin	   	//  |.-.|\n#define pb     push_back	  //  ' ; '\nusing ll    =  long long          ;\nusing vi    =  vector<int>        ;\nusing uint  =  unsigned int       ;\nusing vc    =  vector<char>       ;\nusing vii   =  vector<int,int>    ;\nusing vvi   =  vector<vector<int>>;\n\n///////////////////////////////////\n\nvoid solve() {\n \bint n; cin >> n;\n\n\b}\n\n////////////////////////////////////////\n\nint main(){\n \bios::sync_with_stdio(false); cin.tie(nullptr);\n\n\b}", { desc = "Insert Codeforces template" })
