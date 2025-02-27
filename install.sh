#!/bin/bash

# colors
RED='\033[0;31m'
BLUE="\e[0;94m"
GREEN='\033[0;32m'
WHITE='\033[0;37m'

# change dir in script's directory
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$SCRIPT_DIR"

# warn the user if the script is being runned as root
if [[ "$EUID" == 0 ]]; then
  if [[ ! $SCRIPT_DIR =~ ^/root ]]; then
    echo -e "${RED}WARNING: running this script as root might cause permission issues."
  fi
fi

# check wether the default shell is zsh or not
if [[ "$SHELL" != "/bin/zsh" && "$SHELL" != "/usr/bin/zsh" ]]; then
  echo -e "${WHITE}Install zsh if it is not already installed on your system and make it your default shell :"
  echo -e "${WHITE}> ${BLUE}chsh \$USER"
  echo -e "${WHITE}> ${BLUE}/bin/zsh"
  echo ""
fi

# configure /etc/zsh files for avoiding dotfiles clutter in home directory
if [[ -f "/etc/zsh/zshenv" ]]; then
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
if [[ -f "/etc/zsh/zshrc" ]]; then
  if ! grep "zsh-newuser-install() { :; }" </etc/zsh/zshrc >/dev/null; then
    echo "zsh-newuser-install() { :; }" | sudo tee -a /etc/zsh/zshrc >/dev/null
  fi
else
  sudo touch /etc/zsh/zshrc
  echo "zsh-newuser-install() { :; }" | sudo tee -a /etc/zsh/zshrc >/dev/null
fi

# configure Pulseaudio to avoid having its cookies in ~/.config
if [[ -f "/etc/pulse/client.conf" ]]; then
  if ! grep -E "cookie-file = /.+/.cache/pulse/cookie" </etc/pulse/client.conf >/dev/null; then
    printf "\ncookie-file = %s/.cache/pulse/cookie" "$HOME" | sudo tee -a /etc/pulse/client.conf >/dev/null
  fi
fi

# Install required packages
if [[ -f "/etc/arch-release" ]]; then
  packages="bat eza fd fzf gcc git github-cli glow i3-wm kitty man-db ncdu neovim npm picom poppler python ripgrep rofi tmux tree-sitter-cli unzip wget xdotool yazi zathura zathura-pdf-mupdf zoxide zsh"
  echo -en "${BLUE}Would you like to synchronize the required packages with pacman ? (y/n) ${WHITE}"
  read answer
  case "$answer" in
  [yY][eE][sS] | [yY])
    sudo pacman -S $packages
    ;;
  *)
    echo -e "${GREEN}Make sure the following packages are installed :"
    echo -e "${WHITE}$packages"
    ;;
  esac
  if [[ ! -f /usr/share/fonts/TTF/FiraCode/FiraCodeNerdFont-Regular.ttf ]]; then
    if [[ ! -f /usr/share/fonts/TTF/FiraCodeNerdFont-Regular.ttf ]]; then
      echo -en "${BLUE}Would you like to install the FiraCode Nerd Font ? (y/n) ${WHITE}"
      read answer
      case "$answer" in
      [yY][eE][sS] | [yY])
        sudo pacman -S ttf-firacode-nerd
        [[ -d /usr/share/fonts/TTF/FiraCode ]] || sudo mkdir -p /usr/share/fonts/TTF/FiraCode
        sudo mv /usr/share/fonts/TTF/FiraCode-NerdFont*.ttf /usr/share/fonts/TTF/FiraCode/
        ;;
      esac
    else
      [[ -d /usr/share/fonts/TTF/FiraCode ]] || sudo mkdir -p /usr/share/fonts/TTF/FiraCode
      sudo mv /usr/share/fonts/TTF/FiraCodeNerdFont*.ttf /usr/share/fonts/TTF/FiraCode/
    fi
  fi
  if [[ ! -d /usr/share/fonts/noto ]]; then
    echo -en "${BLUE}Would you like to install the Noto font for having a fallback font for unicode symbols ? (y/n) ${WHITE}"
    read answer
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
    echo -en "${BLUE}Do you want to install the Yet Another Yogurt AUR helper ? "
    read answer
    case "$answer" in
    [yY][eE][sS] | [yY])
      if [[ ! -f /usr/bin/git ]]; then
        echo "${RED}Having git installed is necessary to install yay."
        sudo pacman -S git
      fi
      if [[ ! -f /usr/bin/makepkg ]]; then
        echo "${RED}The base-devel package is necessary to install yay."
        sudo pacman -S base-devel
      fi

      git clone https://aur.archlinux.org/yay.git
      cd yay
      makepkg -si
      ;;
    esac
  fi
fi

# TexLive
if [[ ! -d "/usr/local/texlive" ]]; then
  echo -e "${GREEN}Follow instructions at https://www.tug.org/texlive/quickinstall.html to install TexLive."
fi

# copy scripts to /usr/local/bin
cd scripts || {
  echo -e "Error : scripts folder is not present in the script's directory"
  exit
}
printf '\n'
for file in *; do
  if [[ ! -f "/usr/local/bin/$file" ]]; then
    sudo cp "$file" "/usr/local/bin/"
    sudo chmod +x "/usr/local/bin/$file"
  else
    if ! cmp --silent "$file" "/usr/local/bin/$file"; then
      echo -en "${BLUE}Would you like to delete your current $file script to replace it with the one in this repo ? (y/n) ${WHITE}"
      read answer
      case "$answer" in
      [yY][eE][sS] | [yY])
        sudo cp "$file" "/usr/local/bin/"
        sudo chmod +x "/usr/local/bin/$file"
        ;;
      esac
    fi
  fi
done
cd ..

# copy config folders
if [[ "$SCRIPT_DIR" =~ (/home/[^/]+) ]]; then
  HOME_DIR=${BASH_REMATCH[1]}
else
  HOME_DIR="/root"
fi
if [[ ! -d "$HOME_DIR/.config" ]]; then
  mkdir "$HOME_DIR/.config"
fi
cd "$SCRIPT_DIR/config" || {
  echo -e "Error : config folder is not present in the script's directory"
  exit
}
printf '\n'
for item in *; do
  if [[ ! -d "$HOME_DIR/.config/$item" && ! -f "$HOME_DIR/.config/$item" ]]; then
    cp -r "$item" "$HOME_DIR/.config/"
  else
    echo -en "${RED}Would you like to :\n- 1 : create a backup of your current $item config before replacing it\n- 2 : delete your current $item config and replace it\n- 3 : skip this step and keep your current $item config ?\n${WHITE}Enter a number (default 3) : "
    read answer
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

# modify yazi cache directory
[[ -f ~/.config/yazi/yazi.toml ]] && sed -i 's@/home/Antoine@'"$HOME"'@g' ~/.config/yazi/yazi.toml
