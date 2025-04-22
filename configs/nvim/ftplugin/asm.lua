-- assembles and links the current asm file
vim.api.nvim_create_user_command("Assemble", function()
  local filename = vim.fn.fnamemodify(vim.fn.expand("%"), ":r")
  vim.system({ "nasm", "-f", "elf64", "-o", filename .. ".o", filename .. ".asm" }, { text = true }, function(obj)
    print(obj.stderr)
    if obj.signal == 0 then
      vim.system(
        { "ld", "-o", filename .. ".exe", filename .. ".o" },
        { text = true },
        function(obj) print(obj.stderr) end
      )
      vim.fn.system("rm " .. filename .. ".o")
    end
  end)
end, {})

vim.keymap.set(
  "n",
  "<localleader>as",
  "<Cmd>Assemble<CR>",
  { desc = "Assemble and link the current file", buffer = true }
)
