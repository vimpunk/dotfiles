#!/usr/bin/env bash

dotfiles_root=$HOME/dotfiles
compton_symlink=$XDG_CONFIG_HOME/compton.conf
if [ $# -eq 0 ]; then
    ln -is $dotfiles_root/compton/compton.conf $compton_symlink
    echo "Set up symlink for compton."
elif [[ $1 =~ -D|--delete ]]; then
    rm $compton_symlink
    echo "Deleted symlink for compton."
fi
