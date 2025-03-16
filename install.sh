#!/bin/bash

# colors
RED='\x1b[38;2;232;36;36m'     # #E82424
YELLOW='\x1b[38;2;255;158;59m' # #FF9E3B
GREEN='\x1b[38;2;106;149;137m' # #6A9589
BLUE='\x1b[38;2;126;156;216m'  # #7E9CD8
WHITE='\x1b[38;2;220;215;186m' # #DCD7BA

# change dir to the script's directory
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$SCRIPT_DIR" || exit

# warn the user if the script is being runned as root
if [[ "$EUID" == 0 ]]; then
  if [[ ! $SCRIPT_DIR =~ ^/root ]]; then
    echo -e "${YELLOW} Running this script as root might cause permission issues"
    echo -en "${YELLOW}Do you really want to continue (y/n) ? ${WHITE}"
    read -r answer
    case "$answer" in
    [yY][eE][sS] | [yY]) ;;
    *)
      exit 1
      ;;
    esac
  fi
fi

# check wether the default shell is zsh or not
if [[ "$SHELL" != /bin/zsh && "$SHELL" != /usr/bin/zsh ]]; then
  echo -e "${WHITE}Install zsh if it is not already installed on your system and make it your default shell :"
  echo -e "${GREEN}> ${BLUE}chsh $USER"
  echo -e "${GREEN}> ${BLUE}/bin/zsh"
  echo ""
fi

# configure /etc/zsh files for avoiding dotfiles clutter in home directory
if [[ -f /etc/zsh/zshenv ]]; then
  if ! grep "export ZDOTDIR=\$HOME/.config/zsh" </etc/zsh/zshenv >/dev/null; then
    echo "export ZDOTDIR=\$HOME/.config/zsh" | sudo tee -a /etc/zsh/zshenv >/dev/null
  fi
else
  if [[ ! -d /etc/zsh ]]; then
    sudo mkdir /etc/zsh
  fi
  sudo touch /etc/zsh/zshenv
  echo "export ZDOTDIR=\$HOME/.config/zsh" | sudo tee -a /etc/zsh/zshenv >/dev/null
fi
if [[ -f /etc/zsh/zshrc ]]; then
  if ! grep "zsh-newuser-install() { :; }" </etc/zsh/zshrc >/dev/null; then
    echo "zsh-newuser-install() { :; }" | sudo tee -a /etc/zsh/zshrc >/dev/null
  fi
else
  sudo touch /etc/zsh/zshrc
  echo "zsh-newuser-install() { :; }" | sudo tee -a /etc/zsh/zshrc >/dev/null
fi

# configure Pulseaudio to avoid having its cookies in ~/.config
if [[ -f /etc/pulse/client.conf ]]; then
  if ! grep -E "cookie-file = /.+/.cache/pulse/cookie" </etc/pulse/client.conf >/dev/null; then
    printf "\ncookie-file = %s/.cache/pulse/cookie" "$HOME" | sudo tee -a /etc/pulse/client.conf >/dev/null
  fi
fi

# Install required packages
if [[ -f /etc/arch-release ]]; then
  packages=("bat" "eza" "fd" "fzf" "gcc" "git" "github-cli" "glow" "hexyl" "i3-wm" "kitty" "man-db" "ncdu" "neovim" "npm" "picom" "poppler" "python" "ripgrep" "rofi" "tmux" "tree-sitter-cli" "rustup" "unzip" "wget" "xdotool" "yazi" "zathura" "zathura-pdf-mupdf" "zoxide" "zsh")
  echo -en "${BLUE}Would you like to synchronize the required packages with pacman ? (y/n) ${WHITE}"
  read -r answer
  case "$answer" in
  [yY][eE][sS] | [yY])
    sudo pacman -S "${packages[@]}"
    ;;
  *)
    echo -e "${GREEN}Make sure the following packages are installed :"
    echo -e "${WHITE}${packages[*]}"
    ;;
  esac
  if [[ ! -f /usr/share/fonts/TTF/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf ]]; then
    if [[ ! -f /usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf ]]; then
      echo -en "${BLUE}Would you like to install the JetBrains Mono Nerd Font ? (y/n) ${WHITE}"
      read -r answer
      case "$answer" in
      [yY][eE][sS] | [yY])
        sudo pacman -S ttf-jetbrains-mono-nerd
        [[ -d /usr/share/fonts/TTF/JetBrainsMono ]] || sudo mkdir -p /usr/share/fonts/TTF/JetBrainsMono
        sudo mv /usr/share/fonts/TTF/JetBrainsMonoNerdFont*.ttf /usr/share/fonts/TTF/JetBrainsMono/
        ;;
      esac
    else
      [[ -d /usr/share/fonts/TTF/JetBrainsMono ]] || sudo mkdir -p /usr/share/fonts/TTF/JetBrainsMono
      sudo mv /usr/share/fonts/TTF/JetBrainsMonoNerdFont*.ttf /usr/share/fonts/TTF/JetBrainsMono/
    fi
  fi
  if [[ ! -f /usr/share/fonts/TTF/FiraCode/FiraCodeNerdFont-Regular.ttf ]]; then
    if [[ ! -f /usr/share/fonts/TTF/FiraCodeNerdFont-Regular.ttf ]]; then
      echo -en "${BLUE}Would you like to install the FiraCode Nerd Font ? (y/n) ${WHITE}"
      read -r answer
      case "$answer" in
      [yY][eE][sS] | [yY])
        sudo pacman -S ttf-firacode-nerd
        [[ -d /usr/share/fonts/TTF/FiraCode ]] || sudo mkdir -p /usr/share/fonts/TTF/FiraCode
        sudo mv /usr/share/fonts/TTF/FiraCodeNerdFont*.ttf /usr/share/fonts/TTF/FiraCode/
        ;;
      esac
    else
      [[ -d /usr/share/fonts/TTF/FiraCode ]] || sudo mkdir -p /usr/share/fonts/TTF/FiraCode
      sudo mv /usr/share/fonts/TTF/FiraCodeNerdFont*.ttf /usr/share/fonts/TTF/FiraCode/
    fi
  fi
  if [[ ! -d /usr/share/fonts/noto ]]; then
    echo -en "${BLUE}Would you like to install the Noto font for having a fallback font for unicode symbols ? (y/n) ${WHITE}"
    read -r answer
    case "$answer" in
    [yY][eE][sS] | [yY])
      sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
      ;;
    esac
  fi
else
  echo -e "${GREEN}Make sure the following packages are installed :"
  echo -e "${WHITE}$packages"
fi

# Install yay (AUR helper)
if [[ -f /etc/arch-release ]]; then
  if [[ ! -f /usr/bin/yay ]]; then
    echo -en "${BLUE}Do you want to install the Yet Another Yogurt AUR helper (y/n) ? ${WHITE}"
    read -r answer
    case "$answer" in
    [yY][eE][sS] | [yY])
      if [[ ! -f /usr/bin/git ]]; then
        echo "${YELLOW}Having git installed is necessary to install yay."
        sudo pacman -S git
      fi
      if [[ ! -f /usr/bin/makepkg ]]; then
        echo "${YELLOW}The base-devel package is necessary to install yay."
        sudo pacman -S base-devel
      fi

      git clone https://aur.archlinux.org/yay.git
      if cd yay; then
        makepkg -si
      else
        echo "${RED} Cloning yay failed. Check your internet connection and try again."
      fi
      ;;
    esac
  fi
fi

# TexLive
if [[ ! -d /usr/local/texlive ]]; then
  echo -e "${WHITE}Follow instructions at ${BLUE}https://www.tug.org/texlive/quickinstall.html${BLUE} to install TexLive."
fi

# copy scripts to /usr/local/bin
cd scripts || {
  echo -e "${RED}Error:${WHITE} scripts folder is not present in the script's directory"
  exit
}
printf '\n'
for file in *; do
  if [[ ! -f "/usr/local/bin/$file" ]]; then
    sudo cp "$file" "/usr/local/bin/"
    sudo chmod +x "/usr/local/bin/$file"
  elif ! cmp --silent "$file" "/usr/local/bin/$file"; then
    echo -en "${BLUE}Would you like to delete your current ${GREEN}$file${BLUE} script to replace it with the one in this repo ? (y/n) ${WHITE}"
    read -r answer
    case "$answer" in
    [yY][eE][sS] | [yY])
      sudo cp "$file" "/usr/local/bin/"
      sudo chmod +x "/usr/local/bin/$file"
      ;;
    esac
  fi
done
cd .. || exit

# copy config folders
if [[ "$SCRIPT_DIR" =~ (/home/[^/]+) ]]; then
  HOME_DIR=${BASH_REMATCH[1]}
else
  HOME_DIR="/root"
fi
[[ -d "$HOME_DIR/.config" ]] || mkdir "$HOME_DIR/.config"
cd "$SCRIPT_DIR/config" || {
  echo -e "${RED}Error:${WHITE} config folder is not present in the script's directory"
  exit
}
printf '\n'
for item in *; do
  if [[ ! -d "$HOME_DIR/.config/$item" && ! -f "$HOME_DIR/.config/$item" ]]; then
    cp -r "$item" "$HOME_DIR/.config/"
  else
    echo -en "${BLUE}Would you like to :\n${BLUE}- 1 :${WHITE} create a backup of your current ${GREEN}$item${WHITE} config before replacing it\n${BLUE}- 2 :${WHITE} delete your current ${GREEN}$item${WHITE} config and replace it\n${BLUE}- 3 :${WHITE} skip this step and keep your current ${GREEN}$item${WHITE} config ?\n${RED}Enter a number (default 3) : "
    read -r answer
    case "$answer" in
    1)
      if [[ -d "$HOME_DIR/.config/$item.bak" || -f "$HOME_DIR/.config/$item.bak" ]]; then
        rm -rf "$HOME_DIR/.config/$item.bak"
      fi
      mv "$HOME_DIR/.config/$item" "$HOME_DIR/.config/$item.bak"
      cp -r "$item" "$HOME_DIR/.config/"
      ;;
    2)
      rm -rf "$HOME_DIR/.config/$item"
      cp -r "$item" "$HOME_DIR/.config/"
      ;;
    *)
      echo -e "${WHITE}Skipping..."
      ;;
    esac
  fi
done

# copy dbg.h in $CPLUS_INCLUDE_PATH
cd .. || exit
if [[ -n "$CPLUS_INCLUDE_PATH" ]]; then
  [[ -d "$CPLUS_INCLUDE_PATH" ]] || mkdir -p "$CPLUS_INCLUDE_PATH"
  if [[ ! -f "$CPLUS_INCLUDE_PATH/dbg.h" ]]; then
    cp dbg.h "$CPLUS_INCLUDE_PATH"
  elif ! cmp --silent "dbg.h" "$CPLUS_INCLUDE_PATH/dbg.h"; then
    echo -en "${BLUE}Would you like to :\n${BLUE}- 1 :${WHITE} create a backup of your current ${GREEN}dbg.h${WHITE} header file before replacing it\n${BLUE}- 2 :${WHITE} delete your current ${GREEN}dbg.h${WHITE} header file and replace it\n${BLUE}- 3 :${WHITE} skip this step and keep your current ${GREEN}dbg.h${WHITE} header file ?\n${RED}Enter a number (default 3) : "
    read -r answer
    case "$answer" in
    1)
      if [[ -f "$CPLUS_INCLUDE_PATH/dbg.h.bak" ]]; then
        rm -f "$CPLUS_INCLUDE_PATH/dbg.h.bak"
      fi
      mv "$CPLUS_INCLUDE_PATH/dbg.h" "$CPLUS_INCLUDE_PATH/dbg.h.bak"
      cp dbg.h "$CPLUS_INCLUDE_PATH"
      ;;
    2)
      rm -f "$CPLUS_INCLUDE_PATH/dbg.h"
      cp dbg.h "$CPLUS_INCLUDE_PATH"
      ;;
    *)
      echo -e "${WHITE}Skipping..."
      ;;
    esac
  fi
fi

# modify yazi cache directory
[[ -f ~/.config/yazi/yazi.toml ]] && sed -i 's@/home/Antoine@'"$HOME"'@g' ~/.config/yazi/yazi.toml

# run WSL/install.sh
if [[ -n "$WSLENV" ]]; then
  echo ""
  echo -en "${BLUE}Looks like you are using WSL. Do you want to run ${GREEN}WSL/install.sh (y/n)${BLUE} ? ${WHITE}"
  read -r answer
  case "$answer" in
  [yY][eE][sS] | [yY])
    WSL/install.sh
    ;;
  esac
fi
