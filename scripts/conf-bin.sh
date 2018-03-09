#!/usr/bin/env bash

dotfiles_root=$HOME/dotfiles
bin_symlink=$HOME/bin
if [ $# -eq 0 ]; then
    ln -is $dotfiles_root/bin $bin_symlink
    echo "Set up symlink for bin."
elif [[ $1 =~ -D|--delete ]]; then
    rm $bin_symlink
    echo "Deleted symlink for bin."
fi
