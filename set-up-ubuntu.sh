#!/bin/bash

#set -e

# execute everything from $HOME
cd "${HOME}"

############################################################
# installs
############################################################

sudo apt update

# packages to allow apt to use a repo over HTTPS
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# env
sudo apt -y install vim vim-gnome i3 dmenu compton feh scrot stow git zsh curl ssh silversearcher-ag

# vim anywhere
curl --fail --silent --show-error --location \
    https://raw.github.com/cknadler/vim-anywhere/master/install | bash

# dev tools
sudo apt -y install shellcheck gcc g++ clang nodejs npm postgresql libpq-dev redis cmake golang sqlite3 sqlite3-dev
# docker
# add docker gpg keys
curl --fail --silent --show-error --location \
    https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# docker stable repo ppa (note: use cosmic release as there are currently no
# stable docker releases for disco)
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   cosmic \
   stable"
sudo apt update
sudo apt -y install docker-ce
# add user to docker group so we can connect to the docker daemon socket
sudo usermod -a -G docker "${USER}"

# postgres doesn't link correctly right off the bat, because the linker can't
# find libpq.so as there will only be a libpq.so.n, so create a symlink to that
sudo ln -s /lib/x86_64-linux-gnu/libpq.so.[0-9] /lib/x86_64-linux-gnu/libpq.so

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# source cargo so it's available in this shell
source ~/.cargo/env
cargo install sccache
cargo install diesel_cli --no-default-features --features "postgres sqlite"
rustup component add rls rust-analysis rust-src rustfmt

############################################################
# configuration
############################################################

# start ssh server
sudo systemctl enable ssh
sudo systemctl start ssh
# enable postgres
sudo systemctl enable postgresql

# change shell to zsh
sudo usermod -s /usr/bin/zsh mandreyel

# clone configuration repo
git clone https://github.com/mandreyel/dotfiles

# remove default config files as otherwise stow will fail
rm ~/.zshrc
rm ~/.bashrc

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
    stow i3

    # apply global config files
    (
        cd etc
        # delete default zsh config file and use own
        sudo rm /etc/zsh/zshrc
        sudo stow -t /etc/zsh zsh
    )
)
