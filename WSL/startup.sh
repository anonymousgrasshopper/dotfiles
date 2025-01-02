#!/bin/zsh

source /etc/zsh/zshrc
source ~/.config/zsh/.zshrc 
cd ~
exec i3
nohup i3 > /dev/null 2>&1
