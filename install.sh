if [ "$EUID" -ne 0 ]
  then echo "Please run the script as root to proceed."
  exit
fi

echo "export ZDOTDIR=\$HOME/.config/zsh" >> /etc/zsh/zshrc
echo "zsh-newuser-install() { :; }" >> /etc/zsh/zshenv
