vim.opt.makeprg = "typst compile --diagnostic-format short " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
