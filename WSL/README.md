### Installation instruction for Windows
-  [install WSL](https://learn.microsoft.com/en-us/windows/wsl/install) and install [Arch WSL](https://apps.microsoft.com/detail/9mznmnksm73x?hl=en-us&gl=US) through the Microsoft Store
- Inside of the Arch WSL, create a root password and a user, `sudo pacman -S git` and `git clone https://github.com/anonymousgrasshopper/dotfiles` (in `~/.config` for example), then run `install.sh`.

- Install [Vcxsrv](https://vcxsrv.com/) ([download link](https://vcxsrv.com/wp-content/uploads/2024/09/vcxsrv-64.1.17.2.0.installer.zip)).

- Copy `fullscreen.xlaunch` into `C:\Program Files\Vcxsrv` (`window.xlaunch` can be also be fused for a large window without titlebar; in this case, you may want to hide the taskbar in windows. On my machine it doesn't disappear completely though, causing display issues.).
- Place `arch.ps1` on the Windows desktop.
- Place `startup.sh` in `~/.scripts`.

- If you want audio support in WSL, [this link](https://www.reddit.com/r/bashonubuntuonwindows/comments/hrn1lz/wsl_sound_through_pulseaudio_solved/) explains how to setup PulseAudio for this purpose.

- Disable the [windows keybindings](https://www.top-password.com/blog/disable-windows-key-shortcuts-hotkeys-in-windows-10/), the [Win+g](https://stackoverflow.com/questions/51502871/how-to-block-wing-keyboard-event) and [Win+L](https://superuser.com/questions/1059511/how-to-disable-winl-in-windows-10) keybindings to avoid conflicts with i3wm.

- Installing the Bibata cursor theme : `yay -S bibata-cursor-theme-bin` and `sudo mv /usr/share/icons/Bibata-Modern-Classic /usr/share/icons/default` is the quickest way to do so.

##### Caveats :
- Expect the window manager to disconnect from the X server when changing network connections.

#### Notes :
- The path to a Firefox executable is hardcoded in `nvim/lua/plugins/util/browsing.lua`
