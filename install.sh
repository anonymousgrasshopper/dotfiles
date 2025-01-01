#!/bin/bash

# colors
RED='\033[0;31m'
BLUE="\e[0;94m"
GREEN='\033[0;32m'
WHITE='\033[0;37m'

# check the user is running the script as root
if [[ "$EUID" -ne 0 ]]; then
  echo -e "${RED}Please run the script as root to proceed."
  exit
fi

# check wether the default shell is zsh or not
if [[ "$SHELL" != "/bin/zsh" && "$SHELL" != "/usr/bin/zsh" ]]; then # since the script is being runned as root, the user may use zsh but still be prompted
  echo -e "${WHITE}Install zsh if it is not already installed on your system and make it your default shell :"
  echo -e "${WHITE}> ${BLUE}chsh \$USER"
  echo -e "${WHITE}> ${BLUE}/bin/zsh"
  echo ""
fi

# configure /etc/zsh files for dotfiles-free home directory
if [[ -f "/etc/zsh/zshrc" ]]; then
  zdotdir=false
  while IFS='' read -r LINE || [[ -n "${LINE}" ]]; do
    if [[ "${LINE}" == "export ZDOTDIR=\$HOME/.config/zsh" ]]; then
      zdotdir=true
      break
    fi
  done < /etc/zsh/zshrc
  if [[ $zdotdir == false ]]; then
    echo "export ZDOTDIR=\$HOME/.config/zsh" >> /etc/zsh/zshrc
  fi
else
  if [[ ! -d /etc/zsh ]]; then
    mkdir /etc/zsh
  fi
  touch /etc/zsh/zshrc
  echo "export ZDOTDIR=\$HOME/.config/zsh" >> /etc/zsh/zshrc
fi
if [[ -f "/etc/zsh/zshenv" ]]; then
  zsh_newuser_install=false
  while IFS='' read -r LINE || [[ -n "${LINE}" ]]; do
    if [[ "${LINE}" == "zsh-newuser-install() { :; }" ]]; then
      zsh_newuser_install=true
      break
    fi
  done < /etc/zsh/zshenv
  if [[ $zsh_newuser_install == false ]]; then
    echo "zsh-newuser-install() { :; }" >> /etc/zsh/zshenv
  fi
else
  touch /etc/zsh/zshrc
  echo "zsh-newuser-install() { :; }" >> /etc/zsh/zshenv
fi

# Install required packages
if [[ -f "/etc/arch-release" ]]; then
  echo -en "${BLUE}Would you like to synchronize the required packages with pacman ? (y/n) ${WHITE}"
  read answer
  case "$answer" in
    [yY][eE][sS]|[yY]) 
      pacman -S bat eza fd fzf git github-cli i3-wm kitty man-db ncdu neovim npm picom poppler python ripgrep rofi tmux unzip wget xdotool yazi zathura zathura-pdf-mupdf zoxide zsh
      ;;
    *)
      echo -e "${GREEN}Make sure the following packages are installed :"
      echo -e "${WHITE}bat eza fd fzf git github-cli i3-wm kitty man-db ncdu neovim npm picom poppler python ripgrep rofi tmux unzip wget xdotool yazi zathura zathura-pdf-mupdf zoxide zsh"
      ;;
  esac
  echo -en "${BLUE}Would you like to install the Noto font for having a fallback font for unicode symbols ? (y/n) ${WHITE}"
  read answer
  case "$answer" in
    [yY][eE][sS]|[yY]) 
      pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra 
      ;;
    esac
else
  echo -e "${GREEN}Make sure the following packages are installed :"
  echo -e "${WHITE}bat eza fd fzf git github-cli i3-wm kitty man-db ncdu neovim npm picom poppler python ripgrep rofi tmux unzip wget xdotool yazi zathura zathura-pdf-mupdf zoxide zsh"
fi

# copy scripts to /usr/local/bin
cd scripts || { echo -e "Error : scripts folder is not present in the script's directory"; exit; }
printf '\n'
for file in *; do
  if [[ ! -f "/usr/local/bin/$file" ]]; then
    cp "$file" "/usr/local/bin/"
    chmod +x "/usr/local/bin/$file"
  else
    echo -en "${BLUE}Would you like to delete your current $file script to replace it with the one in this repo ? (y/n) ${WHITE}"
    read answer
    case "$answer" in 
      [yY][eE][sS]|[yY])
        cp "$file" "/usr/local/bin/"
        chmod +x "/usr/local/bin/$file"
        ;;
    esac
  fi
done
cd ..

# copy .config folders
WORKING_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [[ "$WORKING_DIR" =~ (/home/[^/]+) ]]; then
  HOME_DIR=${BASH_REMATCH[1]}
else
  HOME_DIR="/root"
fi
cd "$WORKING_DIR/config" || { echo -e "Error : config folder is not present in the script's directory"; exit; }
printf '\n'
for item in *; do
  if [[ ! -d "$HOME_DIR/.config/$item" && ! -f "$HOME_DIR/.config/$item"  ]]; then
    cp -r "$item" "$HOME_DIR/.config/"
  else
    echo -en "${RED}Would you like to :\n- 1 : create a backup of your current $item config before replacing it\n- 2 : delete your current $item config and replace it\n- 3 : skip this step and keep your current $item config ?\n${WHITE}Enter a number (default 3) : "
    read answer
    case "$answer" in
      1) 
        if [[ -d "$HOME_DIR/.config/$item-backup" || -f "$HOME_DIR/.config/$item-backup" ]]; then
          rm -rf "$HOME_DIR/.config/$item-backup"
        fi
        mv "$HOME_DIR/.config/$item" "$HOME_DIR/.config/$item-backup"
        cp -r "$item" "$HOME_DIR/.config/"
        chmod -R 777 "$HOME_DIR/.config/$item"
        chmod -R 777 "$HOME_DIR/.config/$item-backup"
        ;;
      2)
        rm -rf "$HOME_DIR/.config/$item"
        cp -r "$item" "$HOME_DIR/.config/"
        chmod -R 777 "$HOME_DIR/.config/$item"
        ;;
      *)
        echo -e "${WHITE}Skipping..."
        ;;
    esac
  fi
done

# TexLive
if [[ ! -d "/usr/local/texlive" ]]; then
  echo -e "${GREEN}Follow instructions at https://www.tug.org/texlive/quickinstall.html to install TexLive."
fi
