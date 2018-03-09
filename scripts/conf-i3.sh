#!/usr/bin/env bash

dotfiles_root=$HOME/dotfiles
i3_symlink=$XDG_CONFIG_HOME/i3
if [ $# -eq 0 ]; then
    ln -is $dotfiles_root/i3 $i3_symlink
    echo "Set up symlink for i3."
elif [[ $1 =~ -D|--delete ]]; then
    rm $i3_symlink
    echo "Deleted symlink for i3."
fi
