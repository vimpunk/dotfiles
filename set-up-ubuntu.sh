#!/bin/bash

set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails

# execute everything from $HOME
cd "${HOME}"

ubuntu_release="$(lsb_release --codename --short)"
echo "Setting up Ubuntu ${ubuntu_release}"

############################################################
# installs
############################################################

sudo apt -y update

# packages to allow apt to use a repo over HTTPS
sudo apt -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# general env
sudo apt -y install \
    vim \
    vim-gtk3 \
    i3 \
    dmenu \
    compton \
    feh \
    scrot \
    stow \
    git \
    zsh \
    curl \
    ssh \
    silversearcher-ag \
    xclip \
    mpv \
    sshfs \
    htop \
    iftop

# vim anywhere
curl --fail --silent --show-error --location \
    https://raw.github.com/cknadler/vim-anywhere/master/install | bash

# dev tools
sudo apt -y install \
    shellcheck \
    gcc \
    g++ \
    clang \
    nodejs \
    npm \
    postgresql \
    libpq-dev \
    redis \
    cmake \
    golang \
    sqlite3 \
    libsqlite3-dev \
    libmysqlclient-dev

# docker
#
# add docker gpg keys
curl --fail --silent --show-error --location \
    https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# docker stable repo ppa
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   ${ubuntu_release} \
   stable"
sudo apt -y update
sudo apt -y install docker-ce
# add user to docker group so we can connect to the docker daemon socket
sudo usermod -a -G docker "${USER}"

if [ ! -d ~/.local/bin ]; then
    mkdir -p ~/.local/bin 
fi

# node version manager and latest node
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
# export nvm for this session to install node
export NVM_DIR=$HOME/.nvm
$NVM_DIR/nvm.sh
# install latest node
nvm install node

# neovim
(
    cd ~/.local/bin
    curl --location \
        --output nvim \
        https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
    chmod u+x nvim
)

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# source cargo so it's available in this shell
source ~/.cargo/env
cargo install \
    cargo-bloat \
    cargo-feature-analyst \
    cargo-audit \
    cargo-outdated \
    cargo-expand \
    diesel_cli \
    sqlx_cli \
    git-delta \
    ripgrep \
    tokei \
    starship \
    evxcr_repl
rustup component add \
    rls \
    rust-analysis \
    rust-src \
    clippy \
    rustfmt

# rust analyzer (need to build from source for now)
# TODO: check if vim-coc doesn't already take care of this
#(
    #cd /tmp
    #git clone https://github.com/rust-analyzer/rust-analyzer.git
    #cd rust-analyzer
    ## only build the lsp binary, we don't need the vscode extension
    #cargo xtask install --server
#)

############################################################
# configuration
############################################################

# change shell to zsh
sudo usermod -s /usr/bin/zsh "${USER}"

# clone configuration repo
git clone https://github.com/mandreyel/dotfiles

# remove default config files (if they exist) as otherwise stow will fail
[ -f ~/.zshrc ] && rm ~/.zshrc
[ -f ~/.bashrc ] && rm ~/.bashrc

(
    cd dotfiles

    git submodule update --init --recursive

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

############################################################
# vim
############################################################

# install all plugins
vim +PlugInstall +qall

# install coc-nvim plugins
vim "+CocInstall coc-rls coc-lists" +qall
