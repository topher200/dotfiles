#!/bin/bash

# TODO: update this to fail loudly on errors
set -x

# install packages
# stop 'tzdata' from prompting for timezone. this can be removed when CircleCI passes without it.
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update && sudo apt-get install -y \
    autojump \
    bat \
    curl \
    docker \
    file \
    fzf \
    htop \
    httpie \
    moreutils \
    neovim \
    jq \
    pspg \
    ripgrep \
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
git clone --depth 1 https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/Homebrew
mkdir /home/linuxbrew/.linuxbrew/bin
ln -s /home/linuxbrew/.linuxbrew/Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin
# shellcheck disable=SC2016
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>/home/topher/.zprofile

# install python packages
sudo apt-get install -y python3-dev python3-pip python3-setuptools python3-venv
sudo pip3 install \
    thefuck

# install node packages
sudo apt-get install -y npm
sudo npm install \
    sql-formatter \
    tldr

exists() {
    command -v "$1" >/dev/null 2>&1
}

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

# install fzf, from https://github.com/junegunn/fzf#using-git
if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --completion --no-update-rc --no-key-bindings
fi

# download stgit from git repo, since the version in ubuntu is out of date
if ! exists stg; then
    wget https://github.com/stacked-git/stgit/releases/download/v1.4/stgit-1.4.tar.gz -O /tmp/stgit.tar.gz
    pushd /tmp || exit
    unp stgit.tar.gz
    pushd stgit-1.4 || exit
    make all
    sudo make prefix=/usr/local install
    popd || exit
    popd || exit
fi
# install vim plugins
vim +PlugInstall +qall

# set shell to zsh
sudo chsh -s "$(which zsh)" "$(whoami)"
