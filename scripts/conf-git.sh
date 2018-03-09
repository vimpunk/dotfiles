#!/usr/bin/env bash

dotfiles_root=$HOME/dotfiles
gitconfig_symlink=$HOME/.gitconfig
if [ $# -eq 0 ]; then
    ln -is $dotfiles_root/git/gitconfig $gitconfig_symlink
    echo "Set up symlink for .gitconfig."
elif [[ $1 =~ -D|--delete ]]; then
    rm $gitconfig_symlink
    echo "Deleted symlink for .gitconfig."
fi
