#!/bin/bash

set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails

# parse CLI args

for arg in "$@"; do 
    case "${arg}" in 
    --mobile)
        mobile=true
    ;;
    --no-db)
        skip_dbs=true
    ;;
    --no-cpp)
        skip_cpp=true
    ;;
    --no-node)
        skip_node=true
    ;;
    --no-rust-tools)
        skip_rust_tools=true
    ;;
    --no-nvim)
        skip_nvim=true
    ;;
    --no-docker)
        skip_docker=true
    ;;
    --no-k8s)
        skip_k8s=true
    ;;
    --no-apps)
        skip_apps=true
    ;;
    --minimal)
        skip_dbs=true
        skip_cpp=true
        skip_node=true
        skip_rust_tools=true
        skip_nvim=true
        skip_apps=true
    ;;
    -h|--help)
        help="
Usage: $(basename $0) [OPTIONS]

Options:
    --mobile        Configure installation for laptops. Defaults to true.
    --no-cpp        Skip installation of C/C++ toolchains.
    --no-db         Skip installation of databases (postgres, redis, sqlite).
    --no-node       Skip installation of node.
    --no-nvim       Skip installation of neovim.
    --no-docker     Skip installation of docker.
    --no-k8s        Skip installation of k8s.
    --no-apps       Skip installation of apps like spotify, signal, etc.
    --no-rust-tools Skip installation of optional Rust tooling.
    --minimal       Skip all above optional installations.
    -h, --help      Show this help message.
"

        echo "${help}"
        exit 0
    ;;
    esac
    # next arg
    shift
done

# initialize defaults, otherwise the script fails due to set -u
mobile=${mobile:-true}
skip_dbs=${skip_dbs:-false}
skip_cpp=${skip_cpp:-false}
skip_node=${skip_node:-true}
skip_rust_tools=${skip_rust_tools:-false}
skip_nvim=${skip_nvim:-false}
skip_docker=${skip_docker:-false}
skip_k8s=${skip_k8s:-false}
skip_apps=${skip_apps:-false}

ubuntu_release="$(lsb_release --codename --short)"
echo -e "Setting up Ubuntu ${ubuntu_release}.\n\n"


# Prints the error message given as the first argument and exits.
function error {
    echo "[ERROR]: $1."
    echo "<<<<<< ABORTING SETUP >>>>>>"
    exit 1
}

function start_section {
    echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    echo $1
    echo "======================================================================"
}

function end_section {
    echo "======================================================================"
    echo $1
    echo -e ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n"
}

# Applies the configuration of the first argument, which is a unit in the
# dotfiles repository.
function apply_conf {
    echo "Configuring $1."
    (
        cd $HOME/dotfiles
        if [ ! -e $1 ]; then
            error "$1 is not a saved configuration"
        fi
        # TODO: add check for whether target of stow exists
        stow $1
    )
}

############################################################
# PRE-INSTALL
############################################################

# execute everything from $HOME
cd "${HOME}"

# tools required to run further installation steps
# NOTE: has to come first
function before_install {
    start_section "Running pre-install hook."

    sudo apt -y update
    sudo apt -y upgrade

    # packages to allow apt to use a repo over HTTPS
    sudo apt -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        ssh \
        stow \
        git \
        software-properties-common \
        libssl-dev

    if [ ! -e dotfiles ]; then
        echo "Cloning dotfiles repo."
        git clone https://github.com/mandreyel/dotfiles
    fi

    end_section "Pre-install hook complete."
}

before_install

################################################################################
# DEV
################################################################################

# compilers, linters, etc
function install_lang_toolchains {
    start_section "Installing various language toolchains."

    # scripts
    sudo apt -y install \
        shellcheck

    # C/C++ toolchain
    if [ "${skip_cpp}" != true ]; then
        echo "Installing C/C++ toolchains."
        sudo apt -y install \
            cmake \
            gcc \
            g++ \
            clang
        echo "Installed gcc: $(gcc --version)"
        echo "Installed clang: $(clang --version)"
    fi

    # dbs
    if [ "${skip_dbs}" != true ]; then
        echo "Installing postgres, sqlite, redis."
        sudo apt -y install \
            postgresql \
            libpq-dev \
            redis \
            sqlite3 \
            libsqlite3-dev
        echo "Installed postgres: $(psql --version)"
        echo "Installed sqlite3: $(sqlite3 --version)"
        echo "Installed redis: $(redis-server --version)"
    fi

    # node version manager and latest node
    if [ "${skip_node}" != true ]; then
        echo "Installing nvm and node."
        wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
        # export nvm for this session to install node
        export NVM_DIR=$HOME/.nvm
        # load nvm
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        # install latest node
        nvm install node
        echo "Node (and nvm) installed: $(node --version)"
    fi

    end_section "Language toolchains installed."
}

install_lang_toolchains

# latest docker community edition
function install_docker {
    start_section "Installing latest Docker community edition."

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

    end_section "Docker installed: $(docker --version)"
}

if [ "${skip_docker}" != true ]; then
    install_docker
fi

function install_k8s {
    start_section "Installing latest k8s tooling"

    # kubectl
    # google cloud signing key
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    # k8s apt repo
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt -y update
    sudo apt -y install kubectl

    # minikube
    (
        cd /tmp
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
        sudo dpkg -i minikube_latest_amd64.deb
    )

    # helm
    curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt -y update
    sudo apt -y install helm

    # kubectx + kubens
    # TODO

    # k9s
    # TODO

    end_section "K8s installed: $(kubectl version --short)"
}

if [ "${skip_k8s}" != true ]; then
    install_k8s
fi

function setup_rust {
    start_section "Installing latest Rust toolchain."

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # this takes a _long_ time and can be skipped if not needed
    if [ "${skip_rust_tools}" != true ]; then
        # source cargo so it's available in this shell
        source ~/.cargo/env

        # dev tools
        rustup component add \
            rls \
            rust-analysis \
            rust-src \
            clippy \
            rustfmt

        # cargo tools
        cargo install \
            cargo-bloat \
            cargo-feature-analyst \
            cargo-audit \
            cargo-outdated \
            cargo-expand \
            git-delta
    fi

    end_section "Rust installed: $(rustc --version)"
}

setup_rust

################################################################################
# SHELL & DESKTOP ENV
################################################################################

function setup_regolith {
    sudo add-apt-repository -y ppa:regolith-linux/release

    if [ "${mobile}" == "true" ]; then
        start_section "Installing latest Regolith for mobile."
        sudo apt -y install regolith-desktop-mobile
    else
        end_section "Installing latest Regolith for desktop."
        sudo apt -y install regolith-desktop-standard
    fi

    # colorscheme
    sudo apt -y install regolith-look-solarized-dark
    regolith-look set solarized-dark

    # memory status indicator
    sudo apt -y install i3xrocks-memory

    # override default config
    apply_conf regolith

    end_section "Regolith installed & configured. Changes will take effect on next restart."
}

setup_regolith

function setup_shell {
    start_section "Installing shell and related tools."

    sudo apt -y install \
        zsh \
        feh \
        scrot \
        silversearcher-ag \
        xclip

    source ~/.cargo/env
    cargo install \
        starship \
        ripgrep \
        tokei

    # change shell to zsh
    sudo usermod -s /usr/bin/zsh "${USER}"

    # remove default config files (if they exist) as otherwise stow will fail
    [ -f ~/.zshrc ] && rm ~/.zshrc
    [ -f ~/.bashrc ] && rm ~/.bashrc

    apply_conf zsh
    apply_conf bash
    apply_conf git
    apply_conf bin

    # zsh relies on submodules, install these
    (
        cd dotfiles
        git submodule update --init --recursive

        # apply global config files
        (
            cd etc
            # delete default zsh config file and use own
            sudo rm /etc/zsh/zshrc
            sudo stow -t /etc/zsh zsh
        )

    )

    end_section "Shell installed and configured."
}

setup_shell

# Installs vim, vim-gtk3, nvim, vim-anywhere, and configures them.
function setup_vim {
    start_section "Installing vim and related tools."

    sudo apt -y install \
        vim \
        vim-gtk3

    # neovim
    if [ "${skip_nvim}" != true ]; then
        echo "Installing neovim."
        (
            if [ ! -d ~/.local/bin ]; then
                mkdir -p ~/.local/bin 
            fi

            cd ~/.local/bin
            curl --location \
                --output nvim \
                https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
            chmod u+x nvim

        )
        apply_conf nvim

        # Set defaults to point to nvim.
        set -u
        MY_NVIM_PATH=$HOME/.local/bin/nvim
        sudo update-alternatives --install /usr/bin/ex ex "${MY_NVIM_PATH}" 110
        sudo update-alternatives --install /usr/bin/vi vi "${MY_NVIM_PATH}" 110
        sudo update-alternatives --install /usr/bin/view view "${MY_NVIM_PATH}" 110
        sudo update-alternatives --install /usr/bin/vim vim "${MY_NVIM_PATH}" 110
        sudo update-alternatives --install /usr/bin/vimdiff vimdiff "${MY_NVIM_PATH}" 110

        echo "Neovim installed: $(nvim --version)"
    fi

    # configure
    apply_conf vim
    # install all plugins
    vim +PlugInstall +qall

    end_section "Vim installed: $(vim --version)"
}

setup_vim

# Installs general sysadmin tools.
function install_system_tools {
    start_section "Installing system tools."

    sudo apt -y install \
        htop \
        iftop

    end_section "System tools installed."
}

install_system_tools

# non-essentials
function install_apps {
    start_section "Installing apps."

    sudo apt -y install \
        mpv \
        transmission-gtk

    # signal
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
    echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" |\
        sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
    sudo apt -y update && sudo apt -y install signal-desktop

    # spotify
    curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt -y update && sudo apt -y install spotify-client

    # syncthing
    sudo apt -y install syncthing
    sudo systemctl enable "syncthing@${USER}.service"
    sudo systemctl start "syncthing@${USER}.service"

    # TODO: pw manager

    end_section "Apps installed."
}

if [ "${skip_apps}" != true ]; then
    install_apps
fi
