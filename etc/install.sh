#!/bin/bash

# colors
RED='\x1b[38;2;232;36;36m'     #e82424
YELLOW='\x1b[38;2;255;158;59m' #ff9e3b
GREEN='\x1b[38;2;106;149;137m' #6a9589
BLUE='\x1b[38;2;126;156;216m'  #7e9cd8
WHITE='\x1b[38;2;220;215;186m' #dcd7ba

# change dir to the script's directory
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$SCRIPT_DIR" || exit

[[ -n "$WSL_DISTRO_NAME" ]] && WINDOWS=1

# $1: file to copy relative to $SCRIPT_DIR, $2: destination
function copy_file {
	[[ -f "$1" ]] || {
		echo -e "${YELLOW} $1 not found"
		return 1
	}
	[[ "$2" = ^/home ]] || sudo="sudo"
	[[ -d "$2" ]] || $sudo mkdir -p "$2" 2>/dev/null
	if [[ ! -f "$2/$1" ]]; then
		$sudo cp "$1" "$2/" 2>/dev/null || echo -e "${RED} ${WHITE}You need to manually move ${GREEN}$1${WHITE} to ${GREEN}$2${WHITE}"
	elif ! cmp --silent "$1" "$2/$1"; then
		echo -en "${BLUE}Would you like to delete your current ${GREEN}$1${BLUE} to replace it with the one in this repo ? (y/n) ${WHITE}"
		read -r answer
		case "$answer" in
			[yY][eE][sS] | [yY])
			$sudo cp "$1" "$2/" 2>/dev/null || echo -e "${RED} ${WHITE}You need to manually move ${GREEN}$1${WHITE} to ${GREEN}$2${WHITE}"
			;;
		esac
	fi
}

# place system-wide configuration files
[[ -f /bin/pacman ]] && copy_file pacman.conf /etc
eval type picom >/dev/null 2>&1 && copy_file picom.conf /etc/xdg
[[ -f /etc/arch-release ]] && copy_file paccache.timer /etc/systemd/system
[[ -f /etc/systemd/journald.conf ]] && copy_file journald.conf /etc/systemd
[[ -n "$CPLUS_INCLUDE_PATH" ]] && copy_file dbg.h "$CPLUS_INCLUDE_PATH"
[[ -f /usr/bin/neomutt ]] && copy_file neomutt.desktop /usr/share/applications
[[ -f /usr/bin/neomutt ]] && copy_file neomutt.png /usr/share/icons/hicolor/325x325/apps

# Windows and WSL specific files
if [[ -n "$WINDOWS" ]]; then
	# get the Windows username
	while true; do
		echo -en "${BLUE}What is your Windows username ? ${WHITE}"
		read -r win_username
		if [[ -n "$win_username" && -d "/mnt/c/Users/$win_username" ]]; then
			break
		else
			echo -e "${RED}Home directory not found. Try again..."
		fi
	done

	# list the files to copy and ther destination
	(
		cd WSL || exit 1
		declare -A wsl_scripts
		wsl_scripts=(
			["startup.sh"]="$HOME/.local/bin"
			["arch.vbs"]="/mnt/c/Users/$win_username/Desktop"
			["dvorak.vbs"]="/mnt/c/Users/$win_username/Desktop"
			["HomeRowMods.kbd"]="/mnt/c/Program Files/Kmonad"
			["kmonad.exe"]="/mnt/c/Program Files/Kmonad"
			["HomeRowMods.vbs"]="/mnt/c/Users/$win_username/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
			["capslock.ahk"]="/mnt/c/Users/$win_username/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
		)
		for script in *.xlaunch; do
			wsl_scripts["$script"]="/mnt/c/Program Files/VcXsrv/"
		done

	# move each file to their destination
	for i in "${!wsl_scripts[@]}"; do
		copy_file "$i" "${wsl_scripts[$i]}"
	done
	)
fi

printf '\n'
echo -e "${GREEN}Completed !"
