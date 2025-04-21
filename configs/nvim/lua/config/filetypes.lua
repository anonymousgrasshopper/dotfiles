vim.filetype.add({
  extension = {
    tex = "tex", -- without VimTex plaintex is assigned instead
    zsh = "bash", -- until zsh gets proper support...
    rasi = "css",
    muttrc = "neomuttrc",
  },
  filename = {
    [".zshrc"] = "bash",
    [".zshenv"] = "bash",
    [".zlogout"] = "bash",
    [".zprofile"] = "bash",
  },
  pattern = {
    ["${HOME}/.config/mutt/.+"] = "neomuttrc",
    ["${HOME}/.config/kitty/.*.conf.bak"] = "kitty",
  },
})
