if [ "$EUID" -ne 0 ]
  then echo "Please run the script as root to proceed."
  exit
fi

echo "export ZDOTDIR=\$HOME/.config/zsh" >> /etc/zsh/zshrc
echo "zsh-newuser-install() { :; }" >> /etc/zsh/zshenv

if [ -f /etc/arch-release ]
  then sudo pacman -S bat eza fd fzf git github-cli man-db neovim npm python ranger ripgrep tmux unzip wget xdotool zathura zathura-pdf-mupdf zoxide zsh
else
  echo "Make sure you install the packages listed at line 10 of install.sh"
fi

echo "Follow instructions at https://www.tug.org/texlive/quickinstall.html to install TexLive"
