#!/usr/bin/env bash

dotfiles_root=$HOME/dotfiles
termite_symlink=$XDG_CONFIG_HOME/termite
if [ $# -eq 0 ]; then
    if [ -d $termite_symlink ]; then
        echo "ERROR: termite directory exists"
    fi
    ln -is $dotfiles_root/termite $termite_symlink
    echo "Set up symlink for termite."
elif [[ $1 =~ -D|--delete ]]; then
    rm $termite_symlink
    echo "Deleted symlink for termite."
fi
