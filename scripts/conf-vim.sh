#!/usr/bin/env bash

dotfiles_root=$HOME/dotfiles
vimrc_symlink=$HOME/.vimrc
vim_symlink=$HOME/.vim
if [ $# -eq 0 ]; then
    if ln -is $dotfiles_root/vim/vimrc $vimrc_symlink; then
        echo "Set up symlinks for vimrc"
    fi
    if ln -is $dotfiles_root/vim/vim $vim_symlink; then
        echo "Set up symlinks for vim."
    fi
elif [[ $1 =~ -D|--delete ]]; then
    rm $vimrc_symlink $vim_symlink
    echo "Deleted symlinks for vim."
fi
