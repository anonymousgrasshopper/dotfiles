vim.filetype.add({
  extension = {
    tex = "tex", -- without VimTex plaintex is assigned instead
    zsh = "bash", -- until zsh gets proper support...
    rasi = "css",
  },
  filename = {
    [".zshrc"] = "bash",
    [".zshenv"] = "bash",
    [".zlogout"] = "bash",
    [".zprofile"] = "bash",
  },
  pattern = {
    ["kitty/*.conf"] = "kitty",
    ["$HOME/.config/kitty/*.conf.bak"] = "kitty",
  },
})
