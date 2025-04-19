#!/bin/bash

# colors
RED='\x1b[38;2;232;36;36m'     #e82424
YELLOW='\x1b[38;2;255;158;59m' #ff9e3b
GREEN='\x1b[38;2;106;149;137m' #6a9589
BLUE='\x1b[38;2;126;156;216m'  #7E9CD8
WHITE='\x1b[38;2;220;215;186m' #DCD7BA

# change dir to the script's directory
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$SCRIPT_DIR" || exit

# get args passed to the script
while true; do
  if [[ "$1" = "--wsl" ]]; then
    WINDOWS=1
    shift 1
  else
    break
  fi
done

# $1: file to copy relative to $SCRIPT_DIR, $2: destination, $3: command to pass cp to (sudo or nothing)
copy_file() {
  [[ -d "$2" ]] || mkdir -p "$2"
  [[ -f "$1" ]] || {
    echo -e "${YELLOW} $1 not found"
    return 1
  }
  if [[ ! -f "$2/$1" ]]; then
    $3 cp "$1" "$2/" 2>/dev/null || echo -e "${RED} ${WHITE}You need to manually move ${GREEN}$1${WHITE} to ${GREEN}$2${WHITE}"
  elif ! cmp --silent "$1" "$2/$1"; then
    echo -en "${BLUE}Would you like to delete your current ${GREEN}$1${BLUE} script to replace it with the one in this repo ? (y/n) ${WHITE}"
    read -r answer
    case "$answer" in
    [yY][eE][sS] | [yY])
      $3 cp "$1" "$2/" 2>/dev/null || echo -e "${RED} ${WHITE}You need to manually move ${GREEN}$1${WHITE} to ${GREEN}$2${WHITE}"
      ;;
    esac
  fi
}

# place system-wide configuration files
[[ -f /bin/pacman ]] && copy_file pacman.conf /etc sudo
eval type picom >/dev/null && copy_file picom.conf /etc/xdg sudo
[[ -f /etc/arch-release ]] && copy_file paccache.timer /etc/systemd/system sudo
[[ -f /etc/systemd/journald.conf ]] && copy_file journald.conf /etc/systemd sudo
[[ -n "$CPLUS_INCLUDE_PATH" ]] && copy_file dbg.h "$CPLUS_INCLUDE_PATH"

# Windows and WSL specific files
if [[ -n "$WINDOWS" ]]; then
  # get the Windows username
  while true; do
    echo -en "${BLUE}What is your Windows username ? ${WHITE}"
    read -r win_username
    if [[ -d "/mnt/c/Users/$win_username" ]]; then
      break
    else
      echo -e "${RED}Home directory not found. Try again..."
    fi
  done

  # list the files to copy and ther destination
  declare -A wsl_scripts
  wsl_scripts=(
    ["WSL/startup.sh"]="$HOME/.local/bin"
    ["WSL/arch.vbs"]="/mnt/c/Users/$win_username/Desktop"
    ["WSL/dvorak.vbs"]="/mnt/c/Users/$win_username/Desktop"
    ["WSL/HomeRowMods.kbd"]="/mnt/c/Program Files/Kmonad"
    ["WSL/kmonad.exe"]="/mnt/c/Program Files/Kmonad"
    ["WSL/HomeRowMods.vbs"]="/mnt/c/Users/$win_username/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
    ["WSL/capslock.ahk"]="/mnt/c/Users/$win_username/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
  )
  for script in WSL/*.xlaunch; do
    wsl_scripts["$script"]="/mnt/c/Program Files/Vcxsrv"
  done

  # move each file to their destination
  for i in "${!wsl_scripts[@]}"; do
    copy_file "$i" "${wsl_scripts[$i]}"
  done
fi

printf '\n'
echo -e "${GREEN}Completed !"
