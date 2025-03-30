# Installation instruction for Windows
-  [Install WSL](https://learn.microsoft.com/en-us/windows/wsl/install) and install [Arch WSL](https://apps.microsoft.com/detail/9mznmnksm73x?hl=en-us&gl=US) through the Microsoft Store
- Inside of the Arch WSL, create a root password and a user, `sudo pacman -S git` and `git clone https://github.com/anonymousgrasshopper/dotfiles` (in `~/.config` for example), then run `install.sh`.

- Install [Vcxsrv](https://vcxsrv.com/) ([download link](https://sourceforge.net/projects/vcxsrv/files/latest/download)).

- Run ./install.sh:

- If you want audio support in WSL, [this link](https://www.reddit.com/r/bashonubuntuonwindows/comments/hrn1lz/wsl_sound_through_pulseaudio_solved/) explains how to setup PulseAudio for this purpose.

- Disable the [windows keybindings](https://www.top-password.com/blog/disable-windows-key-shortcuts-hotkeys-in-windows-10/), the [Win+g](https://stackoverflow.com/questions/51502871/how-to-block-wing-keyboard-event) and [Win+L](https://superuser.com/questions/1059511/how-to-disable-winl-in-windows-10) keybindings to avoid conflicts with i3wm.

- Installing the Bibata cursor theme : `yay -S bibata-cursor-theme-bin` and `sudo mv /usr/share/icons/Bibata-Modern-Classic /usr/share/icons/default` is the quickest way to do so.
