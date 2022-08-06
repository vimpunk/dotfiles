#!/bin/bash

set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails

# Prints the error message given as the first argument and exits.
function error {
    echo "[ERROR]: $1."
    echo "<<<<<< ABORTING SETUP >>>>>>"
    exit 1
}

# brew

function setup_brew_packages {
  if ! which brew
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  packages=(
    stow
    zsh
    fzf
    bash
    openssl
    git
    neovim
    yarn
    node
    python
    shellcheck
    htop
    llvm
    alacritty
    jq
    solidity
    git-delta
  )
  for package in "${packages[@]}"
  do
    brew install "$package"
  done

  "$(brew --prefix)/opt/fzf/install" <<< yyn

  # nerd-fonts: https://gist.github.com/davidteren/898f2dcccd42d9f8680ec69a3a5d350e
  brew tap homebrew/cask-fonts
  # solidity: https://docs.soliditylang.org/en/v0.8.9/installing-solidity.html#macos-packages
  brew tap ethereum/ethereum
  casks=(
    font-hack-nerd-font
    font-jetbrains-mono-nerd-font
    amethyst
    visual-studio-code
    keepassxc
    transmission
  )
  for cask in "${casks[@]}"
  do
    brew install --cask "$cask"
  done

  # alacritty is not signed with Apple's notary service but it can be trusted
  brew install --cask alacritty --no-quarantine
}

setup_brew_packages

# rust

function setup_rust {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

  rustup component add \
    rust-analysis \
    rust-src \
    clippy \
    rustfmt

  source ~/.cargo/env

  cargo install \
    cargo-edit \
    cargo-bloat \
    cargo-feature-analyst \
    cargo-audit \
    cargo-outdated \
    cargo-expand \
    cargo-whatfeatures \
    starship \
    ripgrep \
    tokei \
    bat
}

setup_rust

# lunarvim

bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)

# zsh

chsh -s /bin/zsh

# configs

function setup_config {
  # Applies the configuration of the first argument, which is a unit in the
  # dotfiles repository.
  function apply_conf {
      echo "Configuring $1."
      (
          cd "$HOME/dotfiles"
          if [ ! -e "$1" ]; then
              error "$1 is not a saved configuration"
          fi
          # TODO: add check for whether target of stow exists
          stow "$1"
      )
  }

  if [ ! -e ~/dotfiles ]; then
      echo "Cloning dotfiles repo."
      (
        cd ~/
        git clone https://github.com/mandreyel/dotfiles
        cd dotfiles
        git submodule update --init --recursive
      )
  fi

  conf=(
    zsh
    lvim
    bash
    git
    bin
    tmux
    alacritty
  )

  for conf in "${conf[@]}"
  do
    apply_conf "$conf"
  done
}

setup_config

# macos system settings

function config_system {
  # disable press-and-hold so that ex navigating in vim works as expected
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
  # hide dock for a long time so that it doesn't annoy me
  defaults write com.apple.dock autohide-delay -float 1000; killall Dock
}

config_system
