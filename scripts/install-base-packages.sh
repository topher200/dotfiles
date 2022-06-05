#!/bin/bash

set -Eeuox pipefail

# use the latest version of git (important for git 2.35)
sudo add-apt-repository ppa:git-core/ppa -y
# timezone copy and DEBIAN_FRONTEND are to stop 'tzdata' from prompting for timezone during install
sudo ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
sudo apt-get update && DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
    autojump \
    build-essential \
    colorized-logs \
    curl \
    docker \
    file \
    flameshot \
    fzf \
    htop \
    httpie \
    git \
    moreutils \
    neovim \
    jq \
    pspg \
    shellcheck \
    silversearcher-ag \
    stow \
    tig \
    tmux \
    tree \
    unp \
    unzip \
    vim \
    wget \
    zsh

# install Linuxbrew
if ! command_exists brew; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
brew install \
    gcc \
    jesseduffield/lazygit/lazygit \
    pre-commit \
    thefuck \
    tmuxp \
    tldr \
    screenplaydev/tap/graphite

# install node packages
sudo apt-get install -y npm
sudo npm install \
    sql-formatter
