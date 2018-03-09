#!/usr/bin/env bash

dotfiles_root=$HOME/dotfiles
scripts_path=$dotfiles_root/scripts
if [ $# -eq 0 ]; then
    for s in *; do
        if [[ $s != conf-all.sh ]]; then
            $scripts_path/$s
        fi
    done
    echo "Set up symlinks for everything."
elif [[ $1 =~ -D|--delete ]]; then
    for s in *; do
        if [[ $s != conf-all.sh ]]; then
            $scripts_path/$s -D
        fi
    done
    echo "Deleted symlinks for everything."
fi
