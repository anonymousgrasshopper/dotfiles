#!/bin/zsh

source /etc/zsh/zshrc
source ~/.config/zsh/.zshrc 
cd ~
nohup i3 > /dev/null 2>&1
