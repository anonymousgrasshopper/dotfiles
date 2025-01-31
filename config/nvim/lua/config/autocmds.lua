------------------------------------------------------------------
-------------------------- AUTOCOMMANDS --------------------------
------------------------------------------------------------------

-- show the cursorline in the active buffer only, excepted in excluded filetypes
vim.api.nvim_create_autocmd("WinLeave", {
  callback = function() vim.opt_local.cursorline = false end,
})
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    local excluded_filetypes = { "alpha", "neo-tree-popup", "mason" }
    for _, filetype in ipairs(excluded_filetypes) do
      if vim.bo.filetype == filetype then
        return
      end
    end
    vim.opt_local.cursorline = true
  end,
})

-- hide cursor in chosen filetypes
vim.api.nvim_create_autocmd({ "BufEnter", "CmdlineLeave" }, {
  callback = function()
    local enabled_filetypes = { "alpha", "neo-tree", "neo-tree-popup", "undotree", "diff" }
    for _, filetype in ipairs(enabled_filetypes) do
      if vim.bo.filetype == filetype then
        vim.cmd([[
          hi Cursor blend=100
          set guicursor+=a:Cursor/lCursor
          ]])
        return
      end
    end
    vim.cmd([[
      hi Cursor blend=0
      set guicursor+=a:Cursor/lCursor
      ]])
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "alpha",
  callback = function()
    vim.cmd([[
      hi Cursor blend=100
      set guicursor+=a:Cursor/lCursor
      ]])
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  callback = function()
    vim.cmd([[
      hi Cursor blend=0
      set guicursor-=a:Cursor/lCursor
      ]])
  end,
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
  pattern = {
    "help",
    "diff",
    "tutor",
    "lspinfo",
    "grug-far",
    "CompetiTest",
    "checkhealth",
  },
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
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
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
    vim.keymap.set("i", "<C-m>", "<c-g>u<Esc>[szg`]a<c-g>u", { desc = "Add last word marked as misspelled to dictionnary", buffer = true })
  end,
})
