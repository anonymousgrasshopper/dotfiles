#!/bin/zsh

source /etc/zsh/zshenv
source ~/.config/zsh/.zshrc 
cd ~
exec i3 > /dev/null 2>&1
