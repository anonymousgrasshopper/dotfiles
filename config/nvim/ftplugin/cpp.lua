-- Compile and run SFML programs
vim.keymap.set(
  "n",
  "<localleader>sf",
  function() vim.system({ "compile_sfml", vim.fn.fnamemodify(vim.fn.expand("%"), ":p:r") }, { text = true }) end,
  { expr = true, buffer = true }
)
