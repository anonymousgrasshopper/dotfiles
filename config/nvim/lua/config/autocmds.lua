---------------------------------------------------------------------------------------------------
--------------------------------------------- AUTOCMDS  -------------------------------------------
---------------------------------------------------------------------------------------------------

-- show the cursorline in the active buffer only, and hide it in chosen filetypes
vim.api.nvim_create_autocmd("WinLeave", {
  callback = function() vim.opt_local.cursorline = false end,
})
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    local excluded_filetypes = { "alpha", "neo-tree-popup" }
    if not vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
      vim.opt_local.cursorline = true
    end
  end,
})

-- hide cursor in chosen filetypes
vim.api.nvim_create_autocmd({ "BufEnter", "CmdlineLeave" }, {
  callback = function()
    local enabled_filetypes =
      { "diff", "alpha", "aerial", "undotree", "neo-tree", "dropbar_menu", "DiffviewFiles", "neo-tree-popup", "yazi" }
    if vim.tbl_contains(enabled_filetypes, vim.bo.filetype) or vim.g.undotree_settargetfocus then
      vim.cmd("hi Cursor blend=100")
    else
      vim.cmd("hi Cursor blend=0")
    end
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "alpha",
  callback = function() vim.cmd("hi Cursor blend=100") end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  callback = function() vim.cmd("hi Cursor blend=0") end,
})

-- Auto create dir when saving a file if some of the intermediate directories do not exist
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "diff", "tutor", "lspinfo", "grug-far", "CompetiTest", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Fix conceallevel for json files and add a comma at the end of lines automatically
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
    vim.keymap.set("n", "o", function()
      local line = vim.api.nvim_get_current_line()
      local should_add_comma = string.find(line, "[^,{[]$")
      if should_add_comma then
        return "A,<cr>"
      else
        return "o"
      end
    end, { buffer = true, expr = true })
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown", "tex" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true

    vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { desc = "Correct last spelling mistake", buffer = true })
    vim.keymap.set(
      "i",
      "<C-r>",
      "<c-g>u<Esc>[szg`]a<c-g>u",
      { desc = "Add last word marked as misspelled to dictionnary", buffer = true }
    )
  end,
})

-- type 's ' in the command line to subsitute globally with very magic mode
local function s_abbreviation()
  local cmd_type = vim.fn.getcmdtype()
  local cmd_line = vim.fn.getcmdline()

  if cmd_type == ":" then
    if cmd_line == "s " then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-u>%s/\\v//g<Left><Left><Left>", true, true, true), "n", false)
    elseif cmd_line == "'<,'>s " then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-u>'<,'>s/\\v//g<Left><Left><Left>", true, true, true), "n", false)
    else
      local match = string.match(cmd_line, "(%d+,%s*%d+%s*s) ")
      if match then
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<C-u>" .. match .. "/\\v//g<Left><Left><Left>", true, true, true),
          "n",
          false
        )
      end
    end
  end
end

vim.api.nvim_create_autocmd("CmdlineChanged", {
  pattern = "*",
  callback = s_abbreviation,
})
