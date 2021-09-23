#!/bin/bash

# add repo for 'broot'
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ bullseye main" | sudo tee /etc/apt/sources.list.d/azlux.list
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg  https://azlux.fr/repo.gpg

# install packages
# stop 'tzdata' from prompting for timezone. this can be removed when CircleCI passes without it.
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update && sudo apt-get install -y \
    autojump \
    bat \
    broot \
    curl \
    docker \
    exa \
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
    vim \
    wget \
    zsh

# install Linuxbrew
yes "" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/topher/.zprofile

# install python packages
sudo apt-get install -y python3-dev python3-pip python3-setuptools python3-venv
sudo pip3 install \
    thefuck

# install node packages
sudo apt-get install -y npm
sudo npm install \
    sql-formatter \
    tldr

# pet snippet manager
if [ ! -f /tmp/pet.deb ]; then
    wget https://github.com/knqyf263/pet/releases/download/v0.3.6/pet_0.3.6_linux_amd64.deb -O /tmp/pet.deb
    sudo dpkg -i /tmp/pet.deb
fi

# install viddy, from https://github.com/sachaos/viddy
if [ ! -f /usr/local/bin/viddy ]; then
    wget -O viddy.tar.gz https://github.com/sachaos/viddy/releases/download/v0.3.0/viddy_0.3.0_Linux_x86_64.tar.gz && tar xvf viddy.tar.gz && mv viddy /usr/local/bin
fi

# install fzf, from https://github.com/junegunn/fzf#using-git
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --completion --no-update-rc --no-key-bindings

# install vim plugins
vim +PlugInstall +qall

# set shell to zsh
sudo chsh -s "$(which zsh)" "$(whoami)"
