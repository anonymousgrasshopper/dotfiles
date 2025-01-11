-  install WSL and install Arch WSL through the Microsoft Store
https://learn.microsoft.com/fr-fr/windows/wsl/install 
- in Arch WSL, create a root password and a user, sudo pacman -S git and git clone https://github.com/anonymousgrasshopper/dotfiles (in ~/.config), then run install.sh
Note : yazi caches stuff in /home/Antoine/.cache/yazi. Replace the user name if necessary.

- install Vcxsrv 
https://vcxsrv.com/ 

- copy fullscreen.xlaunch into C:\Program Files\Vcxsrv (config.xlaunch can be used as well but i have a bug in Windows 10 with the taskbar not going out completely so i use fullscreen to get rid of it)
- place arch.ps1 on the Windows desktop
- place startup.sh in ~/.scripts

- use some online tutorial to install Pulseaudio on both the windows and linux sides if necessary

- Disable the windows keybindings, the Win+g and Win+L keybindings :
https://www.top-password.com/blog/disable-windows-key-shortcuts-hotkeys-in-windows-10/
https://superuser.com/questions/1059511/how-to-disable-winl-in-windows-10 for Win+L
