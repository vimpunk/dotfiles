#!/usr/bin/env bash

dotfiles_root=$HOME/dotfiles
polybar_symlink=$XDG_CONFIG_HOME/polybar
if [ $# -eq 0 ]; then
    ln -is $dotfiles_root/polybar $polybar_symlink
    echo "Set up symlink for polybar."
elif [[ $1 =~ -D|--delete ]]; then
    rm $polybar_symlink
    echo "Deleted symlink for polybar."
fi
