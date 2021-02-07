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
    --minimal)
        skip_dbs=true
        skip_cpp=true
        skip_node=true
        skip_rust_tools=true
        skip_nvim=true
    ;;
    -h|--help)
        help="
Usage: $(basename $0) [OPTIONS]

Options:
    --mobile        Configure installation for laptops. Defaults to false.
    --no-cpp        Skip installation of C/C++ toolchains.
    --no-db         Skip installation of databases (postgres, redis, sqlite).
    --no-node       Skip installation of node.
    --no-nvim       Skip installation of neovim.
    --no-rust-tools Skip installation of optional Rust tooling.
    --minimal       Skip all above optional installations.
    -h, --help      Show this help message.
"

        echo "${help}"
    ;;
    esac
    # next arg
    shift
done

ubuntu_release="$(lsb_release --codename --short)"
echo "Setting up Ubuntu ${ubuntu_release}.\n\n"


# Prints the error message given as the first argument and exits.
function error {
    echo "[ERROR]: $1."
    echo "<<<<<< ABORTING SETUP >>>>>>"
    exit 1
}

function start_section {
    echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    echo $1
}

function end_section {
    echo $1
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
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

    # packages to allow apt to use a repo over HTTPS
    sudo apt -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        ssh \
        stow \
        git \
        software-properties-common

    echo "Cloning dotfiles repo."
    git clone https://github.com/mandreyel/dotfiles

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
        $NVM_DIR/nvm.sh
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

install_docker

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

        # db tools
        if [ "${skip_dbs}" != true ]; then
            cargo install \
                diesel_cli \
                sqlx_cli
        fi
    fi

    end_section "Rust installed: $(rustc --version)"
}

setup_rust

################################################################################
# SHELL & DESKTOP ENV
################################################################################

function setup_regolith {
    sudo add-apt-repository ppa:regolith-linux/release

    if [ "${mobile}" == "true" ]; then
        start_section "Installing latest Regolith for mobile."
        sudo apt -y install regolith-desktop-mobile
    else
        end_section "Installing latest Regolith for desktop."
        sudo apt -y install regolith-desktop-standard
    fi

    # colorscheme
    regolith-look set solarized-dark

    # memory status indicator
    sudo apt install -y i3xrocks-memory

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

    cargo install \
        starship \
        ripgrep \
        tokei \
        evxcr_repl

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

# installs vim, vim-gtk3, nvim, vim-anywhere, and configures them
function setup_vim {
    start_section "Installing vim and related tools."

    sudo apt -y install \
        vim \
        vim-gtk3

    # vim anywhere
    curl --fail --silent --show-error --location \
        https://raw.github.com/cknadler/vim-anywhere/master/install | bash

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
        echo "Neovim installed: $(nvim --version)"
    fi

    # configure
    apply_conf vim
    # install all plugins
    vim +PlugInstall +qall
    # install coc-nvim plugins
    # FIXME: this doesn't work
    # possibly look at https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim#automation-script
    vim "+CocInstall coc-rls coc-lists" +qall

    end_section "Vim installed: $(vim --version)"
}

setup_vim

# general sysadmin tools
function install_system_tool {
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
        mpv

    # TODO: signal

    end_section "Apps installed."
}

install_apps
