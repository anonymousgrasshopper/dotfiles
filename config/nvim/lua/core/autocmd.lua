-- show the cursorline in the active buffer only, excepted in excluded filetypes
vim.api.nvim_create_autocmd("WinLeave", {
  callback = function ()
    vim.opt_local.cursorline = false
  end
})
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function ()
    local excluded_filetypes = { "alpha", "neo-tree-popup", "mason", "notify" }
    for _, filetype in pairs(excluded_filetypes) do
      if vim.bo.filetype == filetype then
        vim.cmd[[
          hi Cursor blend=100
          set guicursor+=a:Cursor/lCursor
          ]]
        return
      end
    end
    vim.opt_local.cursorline = true
  end
})

-- hide cursor in chosen filetypes
vim.api.nvim_create_autocmd({ "WinEnter", "Filetype" }, {
  pattern = { "neo-tree-popup", "alpha" },
  callback = function ()
    vim.cmd[[
      hi Cursor blend=100
      set guicursor+=a:Cursor/lCursor
      ]]
  end
})
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function ()
    local excluded_filetypes = { "alpha", "neo-tree-popup" }
    for _, filetype in pairs(excluded_filetypes) do
      if vim.bo.filetype == filetype then
        return
      end
    end
    vim.cmd[[
      hi Cursor blend=0
      set guicursor-=a:Cursor/lCursor
      ]]
  end
})

-- Auto create dir when saving a file if some of the intermediate directories do not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
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
    "tutor",
    "checkhealth",
    "lspinfo",
    "spectre_panel",
    "CompetiTest",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
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
  end,
})
