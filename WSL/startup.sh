#!/bin/zsh

source /etc/zsh/zshenv
source ~/.config/zsh/.zshrc 
cd ~
nohup i3 > /dev/null 2>&1
