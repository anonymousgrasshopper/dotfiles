#!/bin/bash

# colors
RED='\x1b[38;2;232;36;36m'     # #e82424
YELLOW='\x1b[38;2;255;158;59m' # #ff9e3b
GREEN='\x1b[38;2;106;149;137m' # #6a9589
BLUE='\x1b[38;2;126;156;216m'  # #7E9CD8
WHITE='\x1b[38;2;220;215;186m' # #DCD7BA

# change dir to the script's directory
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$SCRIPT_DIR" || exit

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

# list the files to copy and ther destination
declare -A scripts
scripts=(
  ["startup.sh"]="$HOME/.local/bin"
  ["arch.vbs"]="/mnt/c/Users/$win_username/Desktop"
  ["dvorak.vbs"]="/mnt/c/Users/$win_username/Desktop"
  ["HomeRowMods.kbd"]="/mnt/c/Program Files/Kmonad"
  ["kmonad.exe"]="/mnt/c/Program Files/Kmonad"
  ["HomeRowMods.vbs"]="/mnt/c/Users/$win_username/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
  ["capslock.ahk"]="/mnt/c/Users/$win_username/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
)
for script in *.xlaunch; do
  scripts["$script"]="/mnt/c/Program Files/Vcxsrv"
done

# move each file to their destination
for i in "${!scripts[@]}"; do
  copy_file "$i" "${scripts[$i]}"
done

# place system-wide configuration files
eval type picom >/dev/null && copy_file picom.conf /etc/xdg sudo
[[ -f /etc/arch-release ]] && copy_file pacman.conf /etc sudo

printf '\n'
echo -e "${GREEN}Completed !"
