#!/bin/bash

# install packages
# stop 'tzdata' from prompting for timezone. this can be removed when CircleCI passes without it.
export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -y \
    autojump \
    curl \
    fzf \
    htop \
    httpie \
    moreutils \
    jq \
    pspg \
    shellcheck \
    silversearcher-ag \
    stow \
    tig \
    tmux \
    tree \
    unp \
    vim \
    wget \
    zsh

# install python packages
sudo apt-get install -y python3-dev python3-pip python3-setuptools python3-venv
sudo pip3 install \
    thefuck

# install node packages
sudo apt-get install -y npm
sudo npm install \
    tldr

# pet snippet manager
if [ ! -f /tmp/pet.deb ]; then
    wget https://github.com/knqyf263/pet/releases/download/v0.3.6/pet_0.3.6_linux_amd64.deb -O /tmp/pet.deb
    sudo dpkg -i /tmp/pet.deb
fi

# install fzf, from https://github.com/junegunn/fzf#using-git
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --completion --no-update-rc --no-key-bindings

# install vim plugins
vim +PlugInstall +qall

# install fusuma
sudo apt-get install -y \
    libinput-tools \
    ruby \
    xdotool
sudo gem install fusuma
# NEXT: add fusuma to startup programs

# set shell to zsh
sudo chsh -s "$(which zsh)" "$(whoami)"
