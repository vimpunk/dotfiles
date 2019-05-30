#!/bin/bash

#set -e

# execute everything from $HOME
cd "${HOME}"

############################################################
# installs
############################################################

sudo apt update

# install basic tools
sudo apt -y install vim i3-wm stow git docker zsh curl shellcheck gcc g++ nodejs npm

# install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# source cargo so it's available in this shell
source ~/.cargo/env

cargo install rls rustfmt sccache

############################################################
# configuration
############################################################

# change shell to zsh
sudo usermod -s /usr/zsh mandreyel

# clone configuration repo
git clone https://github.com/mandreyel/dotfiles

# execute in subshell for convenient cd-ing
(
    cd dotfiles

    # apply local ($HOME) config files
    stow vim
    stow zsh
    stow bash
    stow bin
    stow git
    stow i3status

    # apply device specific config files
    (
        cd desktop
        stow -t "${HOME}" i3
    )

    # apply global config files
    (
        cd etc
        # delete default zsh config file and use own
        sudo rm /etc/zsh/zshrc
        sudo stow -t /etc/zsh zsh
    )
)
