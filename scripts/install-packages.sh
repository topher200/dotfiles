#!/bin/bash

set -Eeuox pipefail

# install packages
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

# workaround for https://github.com/sharkdp/bat/issues/938, required for ubuntu 20.04 (but not later!)
sudo apt-get install -y -o Dpkg::Options::="--force-overwrite" bat ripgrep

sudo apt-get update
sudo apt-get install git -y

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# install Linuxbrew
if ! command_exists brew ; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
brew install gcc
brew install jesseduffield/lazygit/lazygit
brew install jesseduffield/lazydocker/lazydocker
brew install pre-commit
brew install thefuck
brew install tmuxp
brew install tldr
brew install screenplaydev/tap/graphite

# install python packages
sudo apt-get install -y python3-dev python3-pip python3-setuptools python3-venv
# sudo pip3 install \
    # thefuck

# install node packages
sudo apt-get install -y npm
sudo npm install \
    sql-formatter

# pet snippet manager
if [ ! -f /tmp/pet.deb ]; then
    wget https://github.com/knqyf263/pet/releases/download/v0.3.6/pet_0.3.6_linux_amd64.deb -O /tmp/pet.deb
    sudo dpkg -i /tmp/pet.deb
fi

# install viddy, from https://github.com/sachaos/viddy
if [ ! -f /usr/local/bin/viddy ]; then
    wget -O /tmp/viddy.tar.gz https://github.com/sachaos/viddy/releases/download/v0.3.0/viddy_0.3.0_Linux_x86_64.tar.gz
    pushd /tmp || exit
    tar xvf /tmp/viddy.tar.gz
    sudo mv /tmp/viddy /usr/local/bin
    popd || exit
fi

# install exa, (not available on Ubuntu 20.04)
if [ ! -f /usr/local/bin/exa ]; then
    wget -O /tmp/exa.zip https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip
    pushd /tmp || exit
    unp exa.zip
    sudo mv bin/exa /usr/local/bin
    popd || exit
fi

# set shell to zsh
sudo chsh -s "$(command -v zsh)" "$(whoami)"
