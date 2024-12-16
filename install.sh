#!/bin/zsh

# colors
RED='\033[0;31m'
WHITE='\033[0;37m'
GREEN='\033[0;32m'

# check the user is running the script as root
if [[ "$EUID" -ne 0 ]]; then
  echo "${RED}Please run the script as root to proceed."
  exit
fi

# check wether the default shell is zsh or not
if [[ "$SHELL" != "/bin/zsh" && "$SHELL" != "/usr/bin/zsh" ]]; then # since the script is being runned as root, the user may use zsh but still be prompted
  echo "${WHITE}Install zsh if it is not already installed on your system and make it your default shell :"
  echo "${WHITE}> ${GREEN}chsh \$USER"
  echo "${WHITE}> ${GREEN}/bin/zsh"
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
  echo -n "${WHITE}Would you like to synchronize the required packages with pacman ? "
  read answer
  case "$answer" in
    [yY][eE][sS]|[yY]) 
      pacman -S bat eza fd fzf git github-cli man-db neovim npm python ranger ripgrep tmux unzip wget xdotool zathura zathura-pdf-mupdf zoxide zsh
      ;;
    *)
      echo "${WHITE}Make sure the following packages are installed :"
      echo "${GREEN}bat eza fd fzf git github-cli man-db neovim npm python ranger ripgrep tmux unzip wget xdotool zathura zathura-pdf-mupdf zoxide zsh"
      ;;
  esac
else
  echo "${WHITE}Make sure the following packages are installed :"
  echo "${GREEN}bat eza fd fzf git github-cli man-db neovim npm python ranger ripgrep tmux ueberzug unzip wget xdotool zathura zathura-pdf-mupdf zoxide zsh"
fi

# copy scripts to /usr/local/bin
cd scripts || echo "Error : scripts folder is not present in the script's directory" exit
for file in *; do
  if [[ ! -f "/usr/local/bin/$file" ]]; then
    cp "$file" "/usr/local/bin/"
    chmod +x "/usr/local/bin/$file"
  fi
done
cd ..

# copy .config folders
HOME_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [[ "$HOME_DIR" =~ (/home/[^/]+) ]]; then
  HOME_DIR=${BASH_REMATCH[1]}
else
  HOME_DIR="/root"
fi
cd .config || echo "Error : .config folder is not present in the script's directory" exit
for folder in *; do
  if [[ ! -d "$HOME_DIR/.config/$folder" ]]; then
    cp -r "$folder" "$HOME_DIR/.config/"
  else
    echo -n "${RED}Would you like to :\n-1 : create a backup of your current $folder config before replacing it\n-2 : delete your current $folder config and replace it\n-3 : skip this step and keep your current $folder config ? "
    read answer
    case "$answer" in
      1) 
        if [[ -d "$HOME_DIR/.config/$folder-backup" ]]; then
          rm -rf "$HOME_DIR/.config/$folder-backup"
        fi
        mv "$HOME_DIR/.config/$folder" "$HOME_DIR/.config/$folder-backup"
        cp -r "$folder" "$HOME_DIR/.config/"
        chmod -R 777 "$HOME_DIR/.config/$folder"
        chmod -R 777 "$HOME_DIR/.config/$folder-backup"
        ;;
      2)
        rm -rf "$HOME_DIR/.config/$folder"
        cp -r "$folder" "$HOME_DIR/.config/"
        chmod -R 777 "$HOME_DIR/.config/$folder"
        ;;
      *)
        echo "${WHITE}Skipping..."
        ;;
    esac
  fi
done

# TexLive
if [[ ! -d "/usr/local/texlive" ]]; then
  echo "${GREEN}Follow instructions at https://www.tug.org/texlive/quickinstall.html to install TexLive."
fi
