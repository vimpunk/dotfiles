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

  packages=(stow zsh fzf bash openssl git neovim yarn node python shellcheck htop llvm)
  for package in "${packages[@]}"
  do
    brew install "$package"
  done

  brew tap homebrew/cask-fonts
  casks=(font-hack-nerd-font amethyst)
  for cask in "${casks[@]}"
  do
    brew install --cask "$cask"
  done
}

setup_brew_packages

# rust

function setup_rust {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

  source ~/.cargo/env

  rustup component add \
    rust-analysis \
    rust-src \
    clippy \
    rustfmt

  cargo install \
    cargo-edit \
    cargo-bloat \
    cargo-feature-analyst \
    cargo-audit \
    cargo-outdated \
    cargo-expand \
    starship \
    ripgrep \
    tokei \
    bat \
    alacritty
}

setup_rust

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
  )

  for conf in "${conf[@]}"
  do
    apply_conf "$conf"
  done
}

setup_config
